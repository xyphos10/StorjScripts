#!/bin/bash

RED='\033[1;31m'
YEL='\033[1;33m'
GRE='\033[1;32m'
NC='\033[0m' # No Color


port=$2
server=$1

echo "The server is $server and the port is $port"

printf " \n"
echo "*********************************************************************************"


readarray -t sats < <( curl -s $server:$port/api/dashboard | jq .data.satellites | jq -r '.[]')

for n in "${sats[@]}"
do
  echo -e "${GRE}Satellite: ${NC}${YEL}$n${NC}"

  success=$(curl -s $server:$port/api/satellite/$n | jq .data.audit.successCount)
	total=$(curl -s $server:$port/api/satellite/$n | jq .data.audit.totalCount)
	score=$(curl -s $server:$port/api/satellite/$n | jq .data.audit.score)

  if [ $total -gt '0' ]
	then
		audrate=$(awk "BEGIN { pc=100*${success}/${total}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
		echo -e "${GRE}Audits:${NC} $success/$total >> ${RED}$audrate%${NC} --- Overall Score: ${RED}$score${NC}"
	else
		echo -e "${GRE}Audits:${NC} No audits from ths satellite!"
	fi

	success=$(curl -s $server:$port/api/satellite/$n | jq .data.uptime.successCount)
  total=$(curl -s $server:$port/api/satellite/$n | jq .data.uptime.totalCount)
	score=$(curl -s $server:$port/api/satellite/$n | jq .data.uptime.score)

	echo -e "${GRE}Uptime:${NC} $success/$total --- Overall Score: ${RED}$score${NC}"
	printf " \n"
	echo "*********************************************************************************"
	printf " \n"
done
