"""
.Synopsis
    password generator
.Description
    password generator
    generates random password and will be handled from cmdline via py filename.py --arg --arg
.Author
    James Lewis
.Date
    03/12/2025
"""

import random
import argparse

def genPwd(number, length):

    print('Welcome To Password Generator')

    chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*(),.'

    print("\nhere are your passwords: ")

    for pwd in range(number):
        passwords = ""
        for c in range(length):
            passwords += random.choice(chars)
        print(passwords)


cmdLine = argparse.ArgumentParser(description="Password Generator")
cmdLine.add_argument("--number", type=int, default=5, help="amount of passwords to generate")
cmdLine.add_argument("--length", type=int, default=8, help="length of each password")

args = cmdLine.parse_args()

genPwd(args.number, args.length)