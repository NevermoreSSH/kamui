#!/bin/bash

source /kamui/params
source <(curl -s ${repoDir}files/others/link.sources)

cd

while true; do
	unset choice
	n=7
	clear
	echo ""
	echo -e "\e[4mPackages Updater\e[24m"
	echo ""
	echo "[1] Update APT Packages"
	echo "[2] Update Dropbear"
	echo "[3] Update SlowDNS"
	echo "[4] Update BadVPN UDPGw"
	echo "[5] Update Xray Core"
	echo "[6] Update Stunnel"
	echo "[7] Update Fail2Ban"
	echo ""
	echo "[x] Back"
	echo ""
	until [[ $choice -ge 1 ]] && [[ $choice -le $n ]] || [[ $choice == "x" ]]; do
		read -p "Choose option : " choice
		if [[ $choice -lt 1 ]] || [[ $choice -gt $n ]]; then
			[[ $choice != "x" ]] && echo "[ERROR] Invalid choice."
		fi
	done
	case $choice in
		1)
			clear
			echo "[INFO] Update APT Packages"
			sleep 2
			apt update
			apt upgrade -y
			echo -e "\n[INFO] APT packages successfully updated.\n"
			read -n 1 -r -s -p $"Press any key to continue ... "
			;;
		2)
			clear
			echo "[INFO] Update Dropbear"
			sleep 2
			pkill dropbear
			git clone https://github.com/mkj/dropbear.git
			cd dropbear
			./configure
			make
			make install
			cd
			rm -rf dropbear
			dropbear -Rw -p 85 -b /etc/db-issue.net
			echo -e "\n[INFO] Dropbear successfully updated.\n"
			read -n 1 -r -s -p $"Press any key to continue ... "
			;;
		3)
			clear
			echo "[INFO] Update SlowDNS"
			sleep 2
			screen -XS dnstt quit
			rm -rf /usr/local/go
			wget -O go.tar.gz "${linkGo}"
			tar -xzf go.tar.gz -C /usr/local
			rm -f go.tar.gz
			rm -f /usr/bin/dnstt-server
			git clone https://www.bamsoftware.com/git/dnstt.git
			cd dnstt/dnstt-server
			go build
			cp dnstt-server /usr/bin/dnstt-server
			chmod +x /usr/bin/dnstt-server
			cd
			rm -rf dnstt
			screen -AmdS dnstt dnstt-server -udp :5300 -privkey-file /kamui/dnstt/server.key ns-${installSubDomain} 127.0.0.1:85
			echo -e "\n[INFO] SlowDNS successfully updated.\n"
			read -n 1 -r -s -p $"Press any key to continue ... "
			;;
		4)
			clear
			echo "[INFO] Update BadVPN UDPGw"
			sleep 2
			screen -XS badvpn quit
			git clone https://github.com/ambrop72/badvpn.git
			mkdir badvpn/build-badvpn
			cd badvpn/build-badvpn
			cmake .. -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1
			make install
			cd
			rm -rf badvpn
			screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300
			echo -e "\n[INFO] BadVPN UDPGw successfully updated.\n"
			read -n 1 -r -s -p $"Press any key to continue ... "
			;;
		5)
			clear
			echo "[INFO] Update Xray Core"
			sleep 2
			systemctl stop xray@tls
			systemctl stop xray@tls
			systemctl stop xray@ntls
			bash -c "$(curl -sL https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
			systemctl start xray@tls
			systemctl start xray@tls
			systemctl start xray@ntls
			echo -e "\n[INFO] Xray Core successfully updated.\n"
			read -n 1 -r -s -p $"Press any key to continue ... "
			;;
		6)
			clear
			echo "[INFO] Update Stunnel"
			sleep 2
			pkill stunnel
			wget -O stunnel.tar.gz "${linkStunnel}"
			tar -xzf stunnel.tar.gz
			rm -f stunnel.tar.gz
			cd $(ls -d */ | cut -f1 -d '/' | grep stunnel)
			./configure
			make
			make install
			cd
			rm -rf $(ls -d */ | cut -f1 -d '/' | grep stunnel)
			stunnel /usr/local/etc/stunnel/stunnel.conf
			echo -e "\n[INFO] Stunnel successfully updated.\n"
			read -n 1 -r -s -p $"Press any key to continue ... "
			;;
		7)
			clear
			echo "[INFO] Update Fail2Ban"
			sleep 2
			systemctl stop fail2ban
			rm -f /etc/init.d/fail2ban
			git clone https://github.com/fail2ban/fail2ban.git
			cd fail2ban
			python3 setup.py install
			cp files/debian-initd /etc/init.d/fail2ban
			cd
			rm -rf fail2ban
			update-rc.d fail2ban defaults
			systemctl start fail2ban
			echo -e "\n[INFO] Fail2Ban successfully updated.\n"
			read -n 1 -r -s -p $"Press any key to continue ... "
			;;
		x)
			break
			;;
	esac
done
