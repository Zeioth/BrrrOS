#!/usr/bin/env python

import subprocess
import datetime
import json
import textwrap
from html import escape

data = {}

today = datetime.date.today().strftime("%Y-%m-%d")

next_week = (datetime.date.today() +
             datetime.timedelta(days=10)).strftime("%Y-%m-%d")

ph = ""


output = subprocess.check_output("khal list now "+next_week, shell=True)
output = output.decode("utf-8")

lines = output.split("\n")
new_lines = []
for line in lines:
    clean_line = escape(line).split(" ::")[0]
    if len(clean_line) and not clean_line[0] in ['0', '1', '2']:
        clean_line = "\n<b>"+clean_line+"</b>"
    new_lines.append(clean_line)
output = "\n".join(new_lines).strip()

if today in output:
    event_title = output.split('\n')[1][0: -5]
    event_title_short = textwrap.shorten(
        event_title, width=15, placeholder=ph)

    data['text'] = "Next appointment →   " + event_title_short
    data['tooltip'] = " " + event_title
else:
    data['text'] = ""
    data['tooltip'] = " No events currently"

print(json.dumps(data))
