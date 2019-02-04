# -*- coding: utf-8 -*-

"""
1, 1
2, 1 + 2*4
3, 1 + 2*4 + 4*4 + 6*4

dis:    0   1     2     3
total:  1 + 1*8 + 2*8 + 3*8

total = 1 + ((1 + x)*x / 2 * 8)

21012
1   1
0   0
1   1
21012

3 210123
"""
n = 277678
FOUND = 0

for layer in xrange(n):
        if layer == 0:
                total = 1
        else:
                total = 1 + ((1+layer)*layer // 2 * 8)

        if total >= n:
                layer_distance = [i for i in xrange(layer+1)]
                layer_distance = layer_distance[1:-1] + layer_distance
                layer_distance = layer_distance[::-1]

                print 'part1 =>', layer_distance[(total-n)%(layer*2)] + layer
                break


W, H = 100, 100

M = [[0 for x in xrange(W)] for y in xrange(H)]


def adj_square(p):
        x, y = p
        for i in (-1, 0, 1):
                for j in (-1, 0, 1):
                        yield M[y+j][x+i]

x, y = (W//2, H//2)

cur = 1
M[y][x] = 1

for layer in xrange(1, n):
        # out of prev layer
        x, y = x+1, y
        # M[y][x] = sum([v for v in adj_square((x, y))])
        M[y][x] = sum(adj_square((x, y)))

        # walk current layer
        for move in [(0, -1), (-1, 0), (0, 1), (1, 0)]:

                times = layer*2 if move != (0, -1) else layer*2-1

                for i in xrange(times):
                        a_x, a_y = move
                        x, y = x+a_x, y+a_y
                        M[y][x] = sum(adj_square((x, y)))
                        if M[y][x] >= n:
                                print 'part2 =>', M[y][x]
                                exit(1)
