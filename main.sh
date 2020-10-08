#! /bin/bash
while true; do
    [[ -d scan_data ]] || mkdir scan_data
    cd scan_data
    rm index.json
    rm *.zip
    wget -q https://chaos-data.projectdiscovery.io/index.json
    jq ".[] | if .bounty and .count < 300 then .URL else null end" index.json | grep -v "null" | sed 's/"//g' | parallel -j 10 wget -q {}
    programs=0
    for zip in *.zip; do
        dir=$(echo $zip | cut -f 1 -d .)
        [[ -d "${dir}_dir" ]] || mkdir "${dir}_dir"
        unzip -o $zip -d "${dir}_dir"
        cd "${dir}_dir"
        rm *_alive.txt*
        rm *_report*
        for hosts in *.txt; do
            httpx -l $hosts -threads 100 -o "${hosts}_alive.txt" -no-color -silent -follow-redirects
            nuclei -t $HOME/nuclei-templates -o "${dir}_${hosts}_report" -v -l "${hosts}_alive.txt"
            [[ -f "${dir}_${hosts}_report" ]] && python3 ../../notify.py --file "${dir}_${hosts}_report"
        done
        cd ..
    ((programs++))
    done
    cd ..
    python3 notify.py --plain_msg "scan completed for ${programs} programs"
    break
done
