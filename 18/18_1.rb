=begin
snd X
rcv X
=end

input = "
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
"
input = File.open("data").read

class Player
	def initialize(asm)
		@asm = asm.strip.split("\n").map(&:split)

		@reg = {}
		# like defaultdict in python
		@reg.default_proc = proc { |h, k| h[k] = 0 }

		@pc = 0
	end

	def run
		loop do
			op, r, i = @asm[@pc]
			(i.match?(/\d+/)? i = i.to_i: i = @reg[i]) if i != nil
			@pc += 1

			case op
			when "snd"
				@freq = @reg[r]
			when "set"
				@reg[r] = i
			when "add"
				@reg[r] += i
			when "mul"
				@reg[r] = @reg[r] * i
			when "mod"
				@reg[r] = @reg[r] % i
			when "rcv"
				if @reg[r] != 0
					@reg[r] = @freq
					break
				end
			when "jgz"
				@pc = @pc - 1 + i if @reg[r] > 0
			else
				puts "not supported operation #{op} !"
			end

			break if @pc >= @asm.size || @pc < 0
		end

	end

	attr_accessor :freq
end


p = Player.new(input)

p.run

puts "part1 => #{p.freq}"
