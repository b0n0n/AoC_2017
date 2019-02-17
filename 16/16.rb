class Dance

	@@dancers = [*"a".."p"]
	# @@dancers = [*"a".."e"]

	def initialize(moves)
		@dancers = @@dancers.clone
		@moves = moves.strip.split(",")
		@move_idx = 0
	end

	def dance
		loop do
			move = @moves[@move_idx]
			break if move == nil
			case move[0]
			when "s"
				spin(move[1..].to_i)
			when "x"
				pos1, pos2 = move[1..].split("/").map(&:to_i)
				exchange(pos1, pos2)
			when "p"
				prog1, prog2 = move[1..].split("/")
				partner(prog1, prog2)
			end
			@move_idx+=1
		end
	end

	def crazy_dance(times)
		times.times { |i|
			dance
			@move_idx = 0
		}
	end

	def find_T
		t = 0
		until @dancers == @@dancers && t != 0 do
			dance
			t += 1
			@move_idx = 0
		end

		return t
	end

	def reset
		@dancers = @@dancers.clone
		@move_idx = 0
	end

	def spin(x)
		@dancers.rotate!(-x)
	end

	def exchange(pos1, pos2)
		@dancers[pos1], @dancers[pos2] = @dancers[pos2], @dancers[pos1]
	end

	def partner(prog1, prog2)
		# do slow way first
		pos1, pos2 = find_prog(prog1), find_prog(prog2)
		exchange(pos1, pos2)
	end

	def find_prog(prog)
		return @dancers.index prog
	end

	protected :spin, :exchange, :partner
	private :find_prog

	attr_reader :dancers
end

input = File.open("data").read
# input = "
# s1,x3/4,pe/b
# "

def dance(input)
	d = Dance.new(input)
	d.dance
	d.dancers
end

def crazy_dance(input, times)
	d = Dance.new(input)
	t = d.find_T
	times = times % t
	d.reset
	d.crazy_dance(times)
	d.dancers
end

p "part1=>#{dance(input).join}"
p crazy_dance(input, 1000000000).join
