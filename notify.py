#! /usr/bin/env python3

from telegram import Bot
import argparse

parser=argparse.ArgumentParser()
parser.add_argument("--file",help="file to send")
parser.add_argument("--plain_msg",help="message to send")
args=parser.parse_args()
ids=[]
bot=Bot(token='')

for id in ids:
    if args.plain_msg:
        bot.send_message(chat_id=id,text=args.plain_msg)
    try:
        bot.send_document(chat_id=id,document=open(args.file,"rb"))
    except TypeError as e:
        print("file not found")
