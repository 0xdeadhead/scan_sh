#! /bin/bash

wget https://chaos-data.projectdiscovery.io/index.json
jq ".[] | if .bounty and .count < 300 then .URL else null end" index.json  | grep -v "null" | sed 's/"//g' | parallel -j 10 wget {}
for zip in *.zip
do
dir=$( echo $zip | cut -f 1 -d . )
[[ -d "${dir}_dir" ]] || mkdir "${dir}_dir"
unzip $zip -d "${dir}_dir" -o
find . -maxdepth 1  -type d -name "*_dir" | parallel -j 10 bash scan.sh {} 