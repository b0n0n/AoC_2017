=begin
If it is clean, it turns left.
If it is weakened, it does not turn, and will continue moving in the same direction.
If it is infected, it turns right.
If it is flagged, it reverses direction, and will go back the way it came.

Clean nodes become weakened.
Weakened nodes become infected.
Infected nodes become flagged.
Flagged nodes become clean.
=end
require "Set"

CLEAN = "."
WEAKENED = "W"
INFECTED = "#"
FLAGGED = "F"

class Virus
	# clean
	C_DIRECTION = {
		:up => [-1, 0, :left],
		:down => [1, 0, :right],
		:left => [0, 1, :down],
		:right => [0, -1, :up],
	}

	# infected
	I_DIRECTION = {
		:up => [1, 0, :right],
		:down => [-1, 0, :left],
		:left => [0, -1, :up],
		:right => [0, 1, :down],
	}

	# weakened
	W_DIRECTION = {
		:up => [0, -1, :up],
		:down => [0, 1, :down],
		:left => [-1, 0, :left],
		:right => [1, 0, :right],
	}

	# flagged
	F_DIRECTION = {
		:up => [0, 1, :down],
		:down => [0, -1, :up],
		:left => [1, 0, :right],
		:right => [-1, 0, :left],
	}

	def initialize(x=0, y=0)
		@x = x
		@y = y
		@dir = :up
	end

	def move(status)
		case status
		when CLEAN
			add_x, add_y, new_dir = C_DIRECTION[@dir]
		when WEAKENED
			add_x, add_y, new_dir = W_DIRECTION[@dir]
		when INFECTED
			add_x, add_y, new_dir = I_DIRECTION[@dir]
		when FLAGGED
			add_x, add_y, new_dir = F_DIRECTION[@dir]
		else
			raise("Invalid status!")
		end

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
	n_status = {}

	init_x, init_y = 0, 0
	input.split("\n").each.with_index { |line, y|
		line.chars.each.with_index { |status, x|
			n_status[[x, y]] = status if status == INFECTED

			init_x = x / 2
		}
		init_y = y / 2
	}

	return n_status, [init_x, init_y]
end

def solve(input, bursts)
	new_infected = 0

	n_status, pos = init_grid(input)
	x, y = pos

	v = Virus.new(x, y)

	bursts.times { |i|
		cur_x, cur_y = v.x, v.y
		# p [cur_x, cur_y]

		status = n_status[[cur_x, cur_y]]||CLEAN
		v.move(status)

		case status
		when CLEAN
			n_status[[cur_x, cur_y]] = WEAKENED
		when WEAKENED
			n_status[[cur_x, cur_y]] = INFECTED
			new_infected += 1
		when INFECTED
			n_status[[cur_x, cur_y]] = FLAGGED
		when FLAGGED
			n_status.delete([cur_x, cur_y])
		end
	}
	puts "part2 => #{new_infected}"
end

solve(input, 5000)
