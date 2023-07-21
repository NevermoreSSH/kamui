## Installed Services
|No.|Service|Port|Note|
|---|---|---|---|
|1|Dropbear|85|-|
|2|Stunnel|465|-|
|||990|OpenVPN|
|3|OpenVPN|1194|UDP|
|||194|TCP|
|4|SlowDNS|53|UDP|
|5|WireGuard|51820|-|
|6|Squid Proxy|8080|-|
|7|Open HTTP Puncher|3128|Dropbear|
|||8000|OpenVPN|
|8|Python Proxy (WebSocket)|8888|Dropbear|
|||8989|OpenVPN|
|9|Xray Core|443|TLS|
|||80|Non-TLS|
|10|Nginx|443|TLS|
|||80|Non-TLS|
|11|BadVPN UDPgW|7300|-|

## Other Services
- Disable IPv6
- Enable BBR
- Time zone set to Asia/Kuala_Lumpur (GMT +8)
- Reset iptables
- Speedtest CLI
- Fail2Ban
- DDoS Deflate
- Vnstat
- Neofetch

## Requirements
- Clean VPS, Debian 11 with KVM, Xen or Hyper-V virtualization

## Installation
1. Update packages and reboot.
	```bash
	apt update; apt upgrade -y; apt install -y screen curl; reboot
	```
2. Run installation.
	```bash
	wget -O install.sh "https://raw.githubusercontent.com/NevermoreSSH/kamui/main/install.sh" && chmod +x install.sh && screen ./install.sh
	```
3. VPS will automatically reboot upon completion.

## Current Progress
1. Install basic SSH & VPN services (Dropbear, Stunnel, BadVPN UDPgW, Squid Proxy, Python Proxy, Open HTTP Puncher (OHP), OpenVPN, WireGuard)
2. Install / Configure 'Other Services' part
3. Install SlowDNS
4. Install Xray Core, 3 protocol (vless, vmess & trojan) at single port 443/80
5. Xray WebSocket support custom path

## Known Bug
1. You tell me. Kindly contact me via Telegram.

