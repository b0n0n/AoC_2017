=begin
If the current node is infected, it turns to its right. Otherwise, it turns to its left. (Turning is done in-place; the current node does not change.)

If the current node is clean, it becomes infected. Otherwise, it becomes cleaned. (This is done after the node is considered for the purposes of changing direction.)

The virus carrier moves forward one node in the direction it is facing.
=end
require "Set"

CLEAN = "."
INFECTED = "#"

class Virus
	# face => [left, right]
	DIRECTION = {
		:up => [[-1, 0, :left], [1, 0, :right]],
		:down => [[1, 0, :right], [-1, 0, :left]],
		:left => [[0, 1, :down], [0, -1, :up]],
		:right => [[0, -1, :up], [0, 1, :down]],
	}

	def initialize(x=0, y=0)
		@x = x
		@y = y
		@dir = :up
	end

	def move(infected)
		left, right = DIRECTION[@dir]
		add_x, add_y, new_dir = if infected then right else left end

		@x += add_x
		@y += add_y

		@dir = new_dir
	end

	attr_accessor :x, :y
end

input = File.open("data").read.strip
# input = "\
# ..#
# #..
# ...
# "

def init_grid(input)
	# use set to store infected nodes
	infected = Set.new()

	init_x, init_y = 0, 0
	input.split("\n").each.with_index { |line, y|
		line.chars.each.with_index { |status, x|
			infected.add([x, y]) if status == INFECTED

			init_x = x / 2
		}
		init_y = y / 2
	}

	return infected, [init_x, init_y]
end

def solve(input, bursts)
	new_infected = 0

	infected, pos = init_grid(input)
	x, y = pos

	v = Virus.new(x, y)

	bursts.times { |i|
		cur_x, cur_y = v.x, v.y

		is_infected = infected.include?([cur_x, cur_y])
		v.move(is_infected)

		if is_infected
			infected.delete([cur_x, cur_y])
		else
			infected.add([cur_x, cur_y])
			new_infected += 1
		end
	}
	# puts infected
	puts "part1 => #{new_infected}"
end

solve(input, 10000)
