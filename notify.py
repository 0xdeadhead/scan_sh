#! /usr/bin/env python3

from telegram import Bot
import argparse

parser=argparse.ArgumentParser()
parser.add_argument("--file",help="file to send")
args=parser.parse_args()
ids=[]
bot=Bot(token='')

for id in ids:
    bot.send_document(chat_id=id,document=open(args.file,"rb"))
