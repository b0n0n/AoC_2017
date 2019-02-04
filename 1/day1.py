#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-

data = open('input', 'rb').read().strip()
# data = '91212129'
prev = data[-1]
s = 0

for cur in data:
        if cur == prev:
                s += int(prev)
        prev = cur

print 'part1=>', s

s = 0
for idx, cur in enumerate(data):
        nxt = data[(len(data)//2 + idx) % len(data)]
        if cur == nxt:
                s += int(cur)

print 'part2=>', s
