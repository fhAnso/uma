# uma.sh - subdomain enumeration

uma.sh automates the enumeration of subdomains from a specific target with RapidDNS and crt.sh. 

## Usage

- Command:
```bash
bash uma.sh targetURI
```

- Output:
```txt
[*] Requesting subdomains..
[+] blog.targetURI, state: active
[+] www.targetURI, state: active
[*] Subdomains: 2
[*] Save output file? (y/n): y
[*] Output saved: 2024-06-26_23-47-24-targetURI.txt
[*] Done, total runtime: 2.000 seconds
```

## LICENSE
This script is published under the [MIT](https://github.com/fhAnso/uma/blob/main/LICENSE) license.