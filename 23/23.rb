=begin
part1

set X Y
sub X Y
mul X Y
jnz X Y, jmp if X != 0

regs: a-h (starts at 0)
============
part2
reg_a starts with 1, what's final v of reg_h?


b = 93
c = 93

b = b*100
b = b + 100000

c = b
c = c + 17000

g = 1 # not 0
# b = 109300, c = 126300

while g != 0 do
f, d= 1, 2

while g != 0 do
e = 2

while g != 0 do
# true if d * e == 109300
g = d
g = g * e
g = g - b
f = 0 if g == 0 # found factor
e = e + 1

g = e # counter, 2..109300
g = g - b
end

d += 1
g = d
g -= b
end

h += 1 if f == 0 # b is not a prime
g = b
g -= c
b += 17
end

how many nums are not prime between 109300..126300(interval = 17)
=end
input = File.open("data").read

class Coprocessor
	def initialize(asm)
		@asm = asm.strip.split("\n").map(&:split)
		@reg = {}
		@reg.default_proc = proc { |h, k| h[k] = 0 }

		@pc = 0

		@mul_time = 0
	end

	def run
		loop do
			op, r, i = @asm[@pc]
			(i.match?(/\d+/)? i = i.to_i: i = @reg[i]) if i != nil
			r.match?(/\d+/)? r_i = r.to_i: r_i = @reg[r]
			@pc += 1
			case op
			when "set"
				@reg[r] = i
			when "sub"
				@reg[r] -= i
			when "mul"
				@reg[r] = r_i * i
				@mul_time += 1
			when "jnz"
				@pc = @pc - 1 + i if r_i != 0
			else
				puts "not supported operation #{op} !"
			end
			break if @pc >= @asm.size || @pc < 0
		end
	end

	attr_accessor :mul_time
end


def part1(input)
	p = Coprocessor.new(input)
	p.run
	puts "part1 => #{p.mul_time}"
end

def part2
	require 'prime'
	h = 0
	(109300..126300).step(17) { |n|
		h += 1 if !n.prime?
	}

	puts "part2 => #{h}"
end

part1(input)
part2
