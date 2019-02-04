import itertools

"""
17  16  15  14  13
18   5   4   3  12
19   6   1   2  11
20   7   8   9  10
21  22  23  24  25
"""

TARGET = 368078
#TARGET = 23

c = 0
n = 1
while n*n < TARGET:
	n += 2
	
print n - 2, n

v = (n-2)*(n-2) + 1
square_side = n

print "v=", v
print "square_side =", n

TR = v + square_side - 2
TL = TR + square_side - 1
BL = TL + square_side - 1
BR = BL + square_side - 1

vals = [TR, TL, BL, BR]
mids = [TR - (square_side - 1)/2, TR + (square_side - 1)/2, TL + (square_side - 1)/2, BL + (square_side - 1)/2]

print vals
print mids

v = min(abs(TARGET-a) for a in mids) # distance to middle of this square side
v += (n // 2) # distance to center
print "part1", v

# part 2
grid = {(0, 0) : 1}
x, y = 0, 0

def adj_values(x, y):
	for dx, dy in itertools.product([0,-1,1], repeat=2):
		if dx == 0 and dy == 0:
			continue
		nx = x + dx
		ny = y + dy
		yield grid[(nx,ny)] if (nx,ny) in grid else 0

def sum_adj(x, y):
	res = sum(adj_values(x, y))
	if res > TARGET:
		print res
		raise
	return res

n = 1

while 1:
	n += 2
	square_side = n
	
	# go right
	x += 1
	grid[(x,y)] = sum_adj(x, y)
	
	# go to top right
	for i in range(square_side - 2):
		y -= 1
		grid[(x,y)] = sum_adj(x, y)
		
	# go to top left
	for i in range(square_side-1):
		x -= 1
		grid[(x,y)] = sum_adj(x, y)

	# go to bottom left
	for i in range(square_side-1):
		y += 1
		grid[(x,y)] = sum_adj(x, y)

	# go to bottom right
	for i in range(square_side-1):
		x += 1
		grid[(x,y)] = sum_adj(x, y)
