# -*- coding: utf-8 -*-

input = open('data', 'rb').read().strip()

valid = 0
part2 = 0
for l in input.split('\n'):
        valid += 1 if len(set(l.split(' '))) == len(l.split(' ')) else 0
        part2 += 1 if len(map(lambda x: ''.join(sorted(x)), l.split(' '))) == len(set(map(lambda x: ''.join(sorted(x)), l.split(' ')))) else 0

print 'part1=>', valid
print 'part2=>', part2
