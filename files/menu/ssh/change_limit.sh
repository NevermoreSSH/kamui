#!/bin/bash

clear
if [[ ! $(cat /kamui/user_database.json | jq -r '.ssh[].username') ]]; then
	echo ""
	echo "There are no SSH users."
	echo ""
	exit 0
fi

unset choice

n=0
echo ""
while read expired; do
	account=$(echo $expired | cut -d: -f1)
	id=$(echo $expired | grep -v nobody | cut -d: -f3)
	exp=$(chage -l $account | grep "Account expires" | awk -F": " '{print $2}')

	if [[ $id -ge 1000 ]] && [[ $exp != "never" ]]; then
		n=$((n+1))
		user[$n]=$account
		echo "[$n] $account"
	fi
done < /etc/passwd
echo ""
echo "[x] Cancel"
echo ""
until [[ $choice -ge 1 ]] && [[ $choice -le $n ]] || [[ $choice == "x" ]]; do
	read -p "Choose user : " choice
	if [[ $choice -lt 1 ]] || [[ $choice -gt $n ]]; then
		[[ $choice != "x" ]] && echo "[ERROR] Invalid choice."
	fi
done
[[ $choice == "x" ]] && echo "" && exit
until [[ $limit == ?(+|-)+([0-9]) ]] && [[ ! $limit -lt 0 ]]; do
	read -p "Login limit (0=no limit) : " limit
	[[ $limit != ?(+|-)+([0-9]) ]] && echo -e "[ERROR] Invalid characters."
	[[ $limit -lt 0 ]] && echo -e "[ERROR] Invalid limit."
done
username=${user[${choice}]}

cat /kamui/user_database.json | jq '(.ssh[] | select(.username == "'$username'")).limit |= "'$limit'"' > /kamui/user_database.json.tmp
mv /kamui/user_database.json.tmp /kamui/user_database.json

clear
echo ""
echo "SSH login limit changed successfully."
echo ""
echo "Username : $username"
echo "New Limit : $limit"
echo ""
