#!/bin/env python3
# pw.py A passwd recorder.

import sys, pyperclip

PASSWD = { 'sgs': 'xxxxx',
           'steam': 'xxxx'
           }

if len(sys.argv) < 2:
    print('Usage: py pw.py [account] - copy account passwd')
account = sys.argv[1]

if account in PASSWD:
    pyperclip.copy(PASSWD[account])
    print("All right.")
else:
    print("Seems that we don't have restore this.")
