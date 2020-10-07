#! /usr/bin/env python3

from telegram import Bot
import argparse

parser=argparse.ArgumentParser()
parser.add_argument("--file",help="file to send")
args=parser.parse_args()
ids=[1179253094, 941027155]
bot=Bot(token='1324292465:AAEi9u7QudguR2VGgJj6pwH40P7zsu4Cw_A')

for id in ids:
    bot.send_document(chat_id=id,document=open(args.file,"rb"))
