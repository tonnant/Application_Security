#!/usr/bin/python

import io
f = open("obfuscated.js", "r")
text = f.read()
print text
splitter = text.split(' ')
print splitter
for number in splitter:
	final = int(number) - 27
	print final
