input = "\
     |
     |  +--+
     A  |  C
 F---|----E|--+
     |  |  |  D
     +B-+  +--+"
input = File.open("data").read

def gen_network(input)
	lines = input.split("\n")
	max_y = lines.map(&:size).max
	max_x = lines.size

	network = Array.new(max_x) {Array.new(max_y)}

	lines.each_with_index { |line, x|
		line.each_char.with_index{ |path, y| network[x][y] = path }
	}

	return network
end

class Packet
	DIRECTIONS = {
		:down => [1, 0],
		:left => [0, -1],
		:up => [-1, 0],
		:right => [0, 1],
	}

	def initialize(pos)
		@x, @y = pos
		@prv_x, @prv_y = @x, @y
		@dir = :down

		@path = ""
		@stopped = false
		@steps = 0
	end

	def valid_pos?(network)
		max_x = network.size
		max_y = network.first.size

		return false if @x < 0 || @y < 0 || @x >= max_x || @y >= max_y
		return false if [" ", nil].include? network[@x][@y]
		return true
	end

	def move(network)
		if !valid_pos? network
			@stopped = true
			return
		end
		@steps += 1
		path = network[@x][@y]
		#  don't care if overlapping
		if (["|", "-"].include? path) || path =~ /[[:alpha:]]/
			@path << path if path =~ /[[:alpha:]]/

			add_x, add_y = DIRECTIONS[@dir]
			@prv_x, @prv_y = @x, @y
			@x, @y = @x + add_x, @y + add_y
		# take turns
		elsif path == "+"
			DIRECTIONS.each { |dir, off|
				add_x, add_y = off
				nxt_x, nxt_y = @x+add_x, @y+add_y
				# walked
				next if nxt_x == @prv_x && nxt_y == @prv_y
				next if nxt_x < 0 || nxt_y < 0
				next if nxt_x >= network.size || nxt_y >= network[0].size
				nxt_path = network[nxt_x][nxt_y]

				if (([:up, :down].include? dir) && !(["-", " ", nil].include? nxt_path))||
				   (([:left, :right].include? dir) && !(["|", " ", nil].include? nxt_path))
					@prv_x, @prv_y = @x, @y
					@x, @y = nxt_x, nxt_y
					@dir = dir
				end
			}
		else
			puts "Invalid path=>#{path} !"
			@stopped = true
		end

	end

	attr_reader :x, :y, :path, :stopped, :steps
end

def walk(network)
	init_pos = [0, network[0].index("|")]
	packet = Packet.new(init_pos)
	packet.move(network) until packet.stopped
	puts "part1 => #{packet.path}"
	puts "part2 => #{packet.steps}"
end

network = gen_network(input)
walk(network)
