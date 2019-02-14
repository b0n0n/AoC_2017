=begin
128 x 128 grid

knot hash for per row, 128 knot hashes in total.

=end

USED = 1
FREE = 0

def knot_hash(data)
	suffix = [17, 31, 73, 47, 23]
	seq = data.strip.bytes
	seq.push(*suffix)
	l = [*0..255]

	t_r = 0

	seq.cycle(64).each_with_index { |r_l, s_l|
		l[0, r_l] = l[0, r_l].reverse
		t_r += r_l+s_l
		l.rotate!(r_l+s_l)
	}
	l.rotate!(-(t_r%l.size))

	hash = ""
	l.each_slice(16) { |i| hash += i.reduce(:^).to_s(16)}

	return hash
end

# input = "flqrgnkx"
input = "xlqgujun"

grid = 128.times.map { |row|
	s = "%0128b" % knot_hash(input + "-#{row}").to_i(16)
	s.split("").map(&:to_i)
}

used = grid.inject(0) { |used, row| used += row.count USED }

puts "part1=>#{used}"

id = 0
# part2
# set id
id_grid = grid.clone
grid.each_with_index { |row, x|
	row.each_with_index { |col, y|
		id_grid[x][y] = (id+=1) if col != 0
	}
}
# get pairs
