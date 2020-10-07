#! /bin/bash

rm index.json
rm *.zip
wget https://chaos-data.projectdiscovery.io/index.json
jq ".[] | if .bounty and .count < 50 then .URL else null end" index.json | grep -v "null" | sed 's/"//g' | parallel -j 10 wget {}
for zip in *.zip; do
    dir=$(echo $zip | cut -f 1 -d .)
    [[ -d "${dir}_dir" ]] || mkdir "${dir}_dir"
    unzip -o $zip -d "${dir}_dir"
    cd "${dir}_dir"
    for hosts in *.txt; do
        httpx -l $hosts -threads 100 -o "${hosts}_alive.txt" -no-color -silent -follow-redirects
        nuclei -t $HOME/nuclei-templates -o "${dir}_report.txt" -v -l "${hosts}_alive.txt"
        python3 ../notify.py --file "${dir}_report.txt"
    done
    cd ..
done
