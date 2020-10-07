#! /bin/bash

cd $1
for hosts in *.txt
do
httpx -l $hosts -threads 100 -o alive.txt -no-color -silent -follow-redirects
nuclei -t $HOME/nuclei-templates -o "$1_report.txt" -silent -v -l alive.txt
python3 ../notify.py --file "$1_report.txt"
done
cd ..