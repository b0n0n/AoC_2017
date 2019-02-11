=begin

           -z        +y

             \ n  /
           nw +--+ ne
             /    \
    +x     -+      +-     -x
             \    /
           sw +--+ se
             / s  \

            -y       +z

=end
# x, y, z
DIRS = {
	:n => [0, 1, -1],
	:ne => [-1, 1, 0],
	:se => [-1, 0, 1],
	:s => [0, -1, 1],
	:sw => [1, -1, 0],
	:nw => [1, 0, -1]
}

data = "ne,ne,ne"
data = "ne,ne,sw,sw"
data = "ne,ne,s,s"
data = "se,sw,se,sw,sw"
data = File.open("data").read.strip

input = data.split(",").map(&:to_sym)

class Hexagon
	def initialize(x, y, z)
		@x = x
		@y = y
		@z = z
	end
	# 2 manhanton distance at 3D
	def distance(other)
		return ((other.x-@x).abs + (other.y-@y).abs + (other.z-@z).abs)/2
	end

	attr_reader :x, :y, :z
end

def adj_hexagon(h, dir)
	unless DIRS.include? dir
		puts "Invalid direction #{dir}"
		exit(1)
	end

	add_x, add_y, add_z = DIRS[dir]

	return Hexagon.new(h.x+add_x, h.y+add_y, h.z+add_z)
end

grid = [Hexagon.new(0, 0, 0)]
cur_h = grid.first

input.each { |dir|
	grid << adj_hexagon(cur_h, dir)
	cur_h = grid.last
}

# part2

max_dis = grid.map { |h|
	h.distance grid.first
}.max

puts "part1 => #{cur_h.distance(grid.first)}"

puts "part2 => #{max_dis}"
