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
	printf "[ERROR] Try %s -h/--help\n" "$0"
	exit 1
}

uma="
 ▄▄▄    ██▒   █▓ ▄▄▄       ██▓     ██▓    ▄▄▄       ▄████▄   ██░ ██ 
▒████▄ ▓██░   █▒▒████▄    ▓██▒    ▓██▒   ▒████▄    ▒██▀ ▀█  ▓██░ ██▒
▒██  ▀█▄▓██  █▒░▒██  ▀█▄  ▒██░    ▒██░   ▒██  ▀█▄  ▒▓█    ▄ ▒██▀▀██░
░██▄▄▄▄██▒██ █░░░██▄▄▄▄██ ▒██░    ▒██░   ░██▄▄▄▄██ ▒▓▓▄ ▄██▒░▓█ ░██ 
 ▓█   ▓██▒▒▀█░   ▓█   ▓██▒░██████▒░██████▒▓█   ▓██▒▒ ▓███▀ ░░▓█▒░██▓
 ▒▒   ▓▒█░░ ▐░   ▒▒   ▓▒█░░ ▒░▓  ░░ ▒░▓  ░▒▒   ▓▒█░░ ░▒ ▒  ░ ▒ ░░▒░▒
  ▒   ▒▒ ░░ ░░    ▒   ▒▒ ░░ ░ ▒  ░░ ░ ▒  ░ ▒   ▒▒ ░  ░  ▒    ▒ ░▒░ ░
  ░   ▒     ░░    ░   ▒     ░ ░     ░ ░    ░   ▒   ░         ░  ░░ ░
      ░  ░   ░        ░  ░    ░  ░    ░  ░     ░  ░░ ░       ░  ░  ░
            ░                                      ░                
"

banner="
Options
=======
 -h, --help		Show this help message
 -t, --target	Set target (example.com)
 -o, --out		Save output to x
 -p, --ping		Ping subdomains
"

flag_error()
{
	local flag="$1"
	printf "[ERROR] Flag %s requires an argument!\n" "$flag"
	exit 1
}

ping_subdomain=0

echo "$uma"

while [[ $# -gt 0 ]]
do
	case "$1" in
	-h|--help)
		printf "%s\n" "$banner"
		exit 0
		;;
	-t|--target)
		[[ -n "$2" ]] && {
			host="$2"
			shift
		} || flag_error "-u/--url"
		;;
	-o|--out)
		[[ -n "$2" ]] && {
			out="$2"
			shift
		} || flag_error "-o/--out"
		;;
	-p|--ping)
		ping_subdomain=1 
		;;
	*)
		printf "Unknown Flag: %s\n" "$1"
		exit 1
		;;
	esac
	shift
done

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
runtime_start="$(date +%s)"

(
	curl -s "https://crt.sh/?q=%25.$host" \
		| grep -oE "[\.a-zA-Z0-9-]+\.$host" \
		| sort -u \
		| awk '!seen[$0]++' \
		| tee "$output" &> /dev/null;

	curl -s "https://rapiddns.io/subdomain/$host?full=1" \
		| grep -oE "[\.a-zA-Z0-9-]+\.$host" \
		| sort -u \
		| awk '!seen[$0]++' \
		| tee "$output" &> /dev/null;
) &

spinner "$!"
printf "\r%s Processing subdomains..\n" "$info"
[[ $ping_subdomain -eq 0 ]] && printf "\n[NOTE] Subdomain pinging disabled\n"
awk '!seen[$0]++' "$output" | while IFS= read -r line
do
	printf "\n%s %s" "$success" "$line"
	[[ $ping_subdomain -eq 1 ]] && {
		printf " state: " 
		ping -c 1 "$line" &> /dev/null && echo "active" || echo "inactive"
	} 
done 

hits=$(wc -l < "$output")
[[ -z "${out+x}" ]] || [[ $hits -eq 0 ]] && {
	rm "$output"
} || {
	mv "$output" "$out"
	printf "\n\n[NOTE] Output saved: %s\n\n" "$out"
}

printf "%s Subdomains: %s\n" "$info" "$hits"
runtime_end=$(date +%s)
runtime=$((runtime_end - runtime_start))
printf "%s Done, total runtime: %.3f seconds\n" "$info" "$runtime"
exit 0
