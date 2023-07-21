#!/bin/bash

clear
echo ""
echo "=============================================="
echo "  Username       Exp. Date       Login Limit"
echo "----------------------------------------------"
n=0
while read user; do
	[[ -z $user ]] && break
	expired=$(cat /kamui/user_database.json | jq -r '(.ssh[] | select(.username == "'$user'")).expired')
	limit=$(cat /kamui/user_database.json | jq -r '(.ssh[] | select(.username == "'$user'")).limit')
	printf "  %-14s %-15s %s\n" $user "$(date -d "$expired" +"%d %b %Y")" $limit
	n=$((n+1))
done <<< "$(cat /kamui/user_database.json | jq -r '.ssh[].username')"
echo "----------------------------------------------"
echo "  Total users : $n"
echo "=============================================="
echo ""
