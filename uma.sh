#!/bin/bash

# Author: fhAnso
# Date: 25.06.24
# License: MIT
#
# uma.sh automates the enumeration of subdomains 
# from a specific target. 
#
# Example:
# 	bash uma.sh example.com 

[[ $# -eq 0 ]] && {
	printf "Syntax: %s <host>\n" "$0"
	exit 1
}

host="$1"
output="$(date +"%Y-%m-%d_%H-%M-%S")-${host%.*}.txt"
info="[*]"
success="[+]"
spin_chars="|/-\\"

spinner() {
	local pid=$1
	local iter=0

	while ps -p $pid > /dev/null
	do
		local char=${spin_chars:iter++%${#spin_chars}:1}
		echo -en "\r[$char] Requesting subdomains.."
		sleep 0.5
	done
}

ctrl_c() {
	echo -e "\n\n\e[41;30mCtrl+C was pressed. Abort!\e[0m"
	exit 1
}

trap ctrl_c INT
runtime_start=$(date +%s)

(
	curl -s "https://crt.sh/?q=%25.$host" \
		| grep -oE "[\.a-zA-Z0-9-]+\.$host" \
		| sort -u \
		| awk '!seen[$0]++' \
		| tee $output &> /dev/null;

	curl -s "https://rapiddns.io/subdomain/$1?full=1" \
		| grep -oE "[\.a-zA-Z0-9-]+\.$1" \
		| sort -u \
		| awk '!seen[$0]++' \
		| tee $output &> /dev/null;
) &

spinner $!
printf "\r%s Requesting subdomains..\n" $info

awk '!seen[$0]++' $output | while IFS= read -r line
do
	printf "%s %s, state: " $success $line
	ping -c 1 $line &> /dev/null && echo -e "active" || echo -e "inactive"
done 

hits=$(wc -l < $output)

leave() {
	local question=$1
	local response

	while true
	do
		read -p "$question (y/n): " response
		case $response in
		[Yy]*)
			return 0  
			;;
		[Nn]*)
			return 1  
			;;
		*)
			echo "Please enter 'y' for yes or 'n' for no."
			;;
		esac
	done
}

printf "%s Subdomains: %s\n%s" $info $hits $info

[[ $hits == 0 ]] && rm $output || {
	leave " Save output file?" $info && {
		printf "%s Output saved: %s\n" $info $output
	} || {
		rm $output
	}
}

runtime_end=$(date +%s)
runtime=$((runtime_end - runtime_start))

printf "%s Done, total runtime: %.3f seconds\n" $info $runtime
exit 0
