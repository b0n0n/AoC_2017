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
	l.each_slice(16) { |i| hash += "%02x" % i.reduce(:^)}

	return hash
end

input = "flqrgnkx"
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
def adj_squares(x, y)
	[[-1, 0], [0, 1], [1, 0], [-1, 0]].each{ |add_x, add_y|
		new_x, new_y = x + add_x, y + add_y
		if new_x >= 0 && new_y >= 0 && new_x <= 127 && new_y <= 127
			yield(new_x, new_y) if block_given?
		end
	}
end

pairs = []

id_grid.each_with_index { |row, x|
	row.each_with_index { |id, y|
		next if id == 0
		adj_squares(x, y) { |adj_x, adj_y|
			adj_id = id_grid[adj_x][adj_y]
			pairs << [id, adj_id] if adj_id != 0
		}
	}
}
# 0 is place holder
$ids = [*0..id]
$sz = [1]*(id + 1)
$cnt = $ids.size - 1

def find(id)
	id = $ids[id] until id == $ids[id]
	return id
end

def union(i1, i2)
	r1, r2 = find(i1), find(i2)
	return if r1 == r2

	if $sz[r1] > $sz[r2]
		$ids[r2] = $ids[r1]
		$sz[r1] += $sz[r2]
	else
		$ids[r1] = $ids[r2]
		$sz[r2] += $sz[r1]
	end
	$cnt -= 1
end

pairs.each { |i1, i2| union(i1, i2)}
puts "part2=>#{$cnt}"
