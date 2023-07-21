#!/bin/bash

clear
echo ""
echo "[INFO] Script started"
echo ""
while true; do
	data=($(ps aux | grep -i dropbear | awk '{print $2}'))
	for pid in "${data[@]}"; do
		num=$(cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$pid\]" | wc -l)
		user=$(cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$pid\]" | awk '{print $10}' | tr -d "'")
		if [[ $num -eq 1 ]]; then
			echo -e "$pid\t$user" >> /tmp/multilogin1.txt
		fi
	done
	if [[ -f /tmp/multilogin1.txt ]]; then
		cat /tmp/multilogin1.txt | awk '{print $2}' | uniq -c > /tmp/multilogin2.txt
		while read limit; do
			user=$(echo $limit | awk '{print $2}')
			login=$(echo $limit | awk '{print $1}')
			userlimit=$(cat /kamui/user_database.json | jq -r '(.ssh[] | select(.username == "'${user}'")).limit')
			if [[ $userlimit != 0 ]] && [[ $login -gt $userlimit ]]; then
				pid=($(cat /tmp/multilogin1.txt | grep -w $user | awk '{print $1}'))
				for toKill in "${pid[@]}"; do
					kill $toKill
				done
				echo "[$(date)] Killed user '$user'. Total login(s): $login" | tee -a /kamui/log/ssh-limit.log
			fi
		done < /tmp/multilogin2.txt
		rm -f /tmp/{multilogin1.txt,multilogin2.txt}
	fi
	sleep 10
done
