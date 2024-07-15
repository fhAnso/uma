# uma.sh - subdomain enumeration

Automated enumeration of subdomains from a specific target using RapidDNS and crt.sh. 

## Usage

- Command:
```bash
bash uma.sh targetURI
```

- Output:
```txt

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

[*] Processing subdomains..

[NOTE] Subdomain pinging disabled

[+] mail.target.xyz
[+] www.target.xyz
[+] pop.target.xyz
[+] demo.target.xyz
[+] backup.target.xyz

[NOTE] Output saved: target_results.txt

[*] Subdomains: 2
[*] Done, total runtime: 2.000 seconds
```

## LICENSE
This script is published under the [MIT](https://github.com/fhAnso/uma/blob/main/LICENSE) license.