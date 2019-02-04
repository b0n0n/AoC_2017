#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-

input = open('./data', 'rb').read().strip()
# input = """
# 5	9	2	8
# 9	4	7	3
# 3	8	6	5
# """.strip()

def find_div(a, b):
        return a // b if a % b == 0 else 0

chksum = 0
part2 = 0
for line in input.split('\n'):
        nums = map(int, line.split('	'))
        # part2
        nums = sorted(nums, reverse=True)
        for i, a in enumerate(nums):
                for b in nums[i+1:]:
                        assert a > b
                        part2 += find_div(a, b)

        min_n, max_n = min(nums), max(nums)
        chksum += max_n - min_n

print 'part1=>', chksum
print 'part2=>', part2
