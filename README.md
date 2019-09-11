# StorjScripts
Personal Storj V3 Scripts

This is my personal script made to check up on my nodes with the new dashboard API, I based it off from a script made by @kevink on the storj forums. This script will only run on debian based systems like Ubuntu. 


## Script Requirements
1. The package jq is needed, install it by running the command sudo apt install jq
2. The script needs execution privileges, run the command sudo +x checkapi.sh
3. The api port must be opened. This is done by editing the storj docker run command and adding -p 127.0.0.1:14002:14002 example

> docker run -d --restart unless-stopped -p 28967:28967 **-p 127.0.0.1:14002:14002** \
    -e WALLET="0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
    -e EMAIL="user@example.com" \
    -e ADDRESS="domain.ddns.net:28967" \
    -e BANDWIDTH="20TB" \
    -e STORAGE="2TB" \
    --mount type=bind,source="<identity-dir>",destination=/app/identity \
    --mount type=bind,source="<storage-dir>",destination=/app/config \
    --name storagenode storjlabs/storagenode:beta
  
**Intructions on setting up a Node: https://documentation.storj.io**

**Forum thread talking about the API: https://forum.storj.io/t/storage-node-dashboard-api/1270**


## How to use the script?

Simply call the script passing the server address first and then the port number of the API, see example below. If the script is not given any server or port, the default localhost and port 14002 are used.

./checkapi.sh 192.168.0.1 14002

*In the above command, 192.168.0.1 is the address of the storj server and 14002 is the port number.



