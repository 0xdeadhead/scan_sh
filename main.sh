#! /bin/bash

wget https://chaos-data.projectdiscovery.io/index.json
jq ".[] | if .bounty and .count < 300 then .URL else null end" index.json  | grep -v "null" | sed 's/"//g' | parallel -j 10 wget {}
find .  -name "*.zip"  | parallel -j 10 bash -c "[[ -d {}_dir ]] || mkdir {}_dir ; unzip {} -d {}_dir"
find . -maxdepth 1  -type d -name "*_dir" | parallel -j 10 bash scan.sh {} 