=begin
0, 1, 2, 3, 2, 1
0, 1, 2, 3, 4, 5



=end
input = File.open("data").read.strip
# input = "
# 0: 3
# 1: 2
# 4: 4
# 6: 4
# ".strip

class Firewall
	def initialize
		@layers = {}
		@max_depth = 0
	end

	def add_layer(depth, range)
		@layers[depth] = [*0...range] + [*1...range-1].reverse
		@max_depth = [@max_depth, depth].max
	end

	def scanner_pos(depth, picosecond)
		layer = layers[depth]
		return -1 if layer == nil
		pos = layer[picosecond % layer.size]
		range = (layer.size + 2 ) / 2
		return pos, range
	end

	attr_reader :layers, :max_depth
end

def get_Firewall(layer_data)
	f = Firewall.new

	layer_data.each_line { |line|
		f.add_layer(*line.split(": ").map(&:to_i))
	}

	return f
end

def trip_severity(fw)
	s = 0
	picosecond = 0
	depth = 0
	while depth <= fw.max_depth
		pos, rng = fw.scanner_pos(depth, picosecond)
		s += rng * depth if pos == 0
		picosecond, depth = picosecond+1, depth+1
	end
	return s
end

def escape(fw)
	delay = 0
	loop do
		caught = false
		picosecond = delay
		depth = 0
		while depth <= fw.max_depth
			pos, _ = fw.scanner_pos(depth, picosecond)
			if pos == 0
				caught = true
				break
			end
			picosecond, depth = picosecond+1, depth+1
		end
		return delay if caught == false

		delay += 1
		# puts delay if delay % 1000 == 0
	end
end


fw = get_Firewall(input)
start = Time.now.to_f
p1 = trip_severity(fw)
part1_t = Time.now.to_f
puts "part1 => #{p1}; takes #{(part1_t - start).round(2)}"
p2 = escape(fw)
part2_t = Time.now.to_f
puts "part2 => #{p2}; takes #{(part2_t - part1_t).round(2)}"
