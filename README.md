# StorjScripts
Personal Storj V3 Scripts

This is my personal script made to check up on my nodes with the new dashboard API, I based it off from a script made by @kevink on the storj forums. This script will only run on linux systems. 

**For this script to run please ensure jq is installed on your system; run sudo apt install jq**

**Also, make the script runnable by using the command sudo chmod +x checkapi.sh**

## How to use the script?

Simply call the script passing the server address first and then the port number of the API, see example below. If the script is not given any server or port, the default localhost and port 14002 are used.

./checkapi.sh 192.168.0.1 14002

##192.168.0.1 is the address of the storj server and 14002 is the port number



