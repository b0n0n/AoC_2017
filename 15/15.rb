=begin

generate A and B

prev_v * factor

=end

# part 1
factor_A = 16807
factor_B = 48271

pairs = 40000000
total = 0
g = 2147483647

sq1 = 618
sq2 = 814


pairs.times { |i|
	sq1 = ((sq1 * factor_A) % g)
	sq2 = ((sq2 * factor_B) % g)

	total += 1 if sq1 % 0x10000 == sq2  % 0x10000
}

puts "part1=>#{total}"

# part 2

pairs = 5000000
total = 0

sq1 = 618
sq2 = 814

sl1, sl2 = [], []

loop do
	sq1 = (sq1 * factor_A) % g
	sq2 = (sq2 * factor_B) % g

	sl1 << sq1%0x10000 if sq1 % 4 == 0
	sl2 << sq2%0x10000 if sq2 % 8 == 0

	break if [sl1.size, sl2.size].min == pairs
end

pairs.times { |i|
	total += 1 if sl1[i] == sl2[i]
}

puts "part2=>#{total}"
