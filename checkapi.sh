#!/bin/bash

RED='\033[1;31m'
YEL='\033[1;33m'
GRE='\033[1;32m'
NC='\033[0m' # No Color

if [ -z "$1" ]
then
	server=127.0.0.1
else
	server=$1
fi

if [ -z "$2" ]
then
	port=14002
else
	port=$2
fi

readarray -t sats < <( curl -s $server:$port/api/dashboard | jq .data.satellites | jq -r '.[]')

echo "Scores are based on recent node performance, all time stats are provided for reference only"

printf " \n"

for n in "${sats[@]}"
do
	echo -e "${GRE}Satellite: ${NC}${YEL}$n${NC}"

	success=$(curl -s $server:$port/api/satellite/$n | jq .data.audit.successCount)
	total=$(curl -s $server:$port/api/satellite/$n | jq .data.audit.totalCount)
	score=$(curl -s $server:$port/api/satellite/$n | jq .data.audit.score)

	if [ $total -gt '0' ]
	then
		audrate=$(awk "BEGIN { pc=100*${success}/${total}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
		echo -e "${GRE}Audits:${NC} Current score: ${RED}$score${NC} (all time stats: $success/$total >> $audrate%)"
	else
		echo -e "${GRE}Audits:${NC} No audits from this satellite!"
	fi

	success=$(curl -s $server:$port/api/satellite/$n | jq .data.uptime.successCount)
	total=$(curl -s $server:$port/api/satellite/$n | jq .data.uptime.totalCount)
	score=$(curl -s $server:$port/api/satellite/$n | jq .data.uptime.score)

	if [ $total -gt '0' ]
	then
		uprate=$(awk "BEGIN { pc=100*${success}/${total}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
		echo -e "${GRE}Uptime:${NC} Current score: ${RED}$score${NC} (all time stats: $success/$total >> $uprate%)"
	else
		echo -e "${GRE}Uptime:${NC} No uptime checks from this satellite!"
	fi
	printf " \n"
done
