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

#readarray -t sats < <( curl -s $server:$port/api/sno | jq -r '.data.satellites[].id' )

readarray -t sats < <( curl -s $server:$port/api/sno/ | jq '.satellites | .[] | .id' )

echo "Scores are based on recent node performance, all time stats are provided for reference only"

printf " \n"

for n in "${sats[@]}"
do
	echo -e "${GRE}Satellite: ${NC}${YEL}$n${NC}"
        n=$(echo $n | tr --delete '"')
	success=$(curl -s $server:$port/api/sno/satellite/$n | jq '.audit.successCount')
	total=$(curl -s $server:$port/api/sno/satellite/$n | jq '.audit.totalCount')
	score=$(curl -s $server:$port/api/sno/satellite/$n | jq '.audit.score')

	if [ $total -gt '0' ]
	then
		#audrate=$(awk "BEGIN { pc=100*${success}/${total}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
		echo -e "${GRE}Audits:${NC} Current score: ${RED}$score${NC} (all time stats: $success/$total)"
	else
		echo -e "${GRE}Audits:${NC} No audits from this satellite!"
	fi

	success=$(curl -s $server:$port/api/sno/satellite/$n | jq '.uptime.successCount')
	total=$(curl -s $server:$port/api/sno/satellite/$n | jq '.uptime.totalCount')
	score=$(curl -s $server:$port/api/sno/satellite/$n | jq '.uptime.score')

	if [ $total -gt '0' ]
	then
		#uprate=$(awk "BEGIN { pc=100*${success}/${total}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
		echo -e "${GRE}Uptime:${NC} Current score: ${RED}$score${NC} (all time stats: $success/$total)"
	else
		echo -e "${GRE}Uptime:${NC} No uptime checks from this satellite!"
	fi
	printf " \n"
done
