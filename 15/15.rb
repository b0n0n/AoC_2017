=begin

generate A and B

prev_v * factor

=end

# part 1
factor_A = 16807
factor_B = 48271

pairs = 40000000
g = 2147483647

sq1 = 618
sq2 = 814

sq1 = 65
sq2 = 8921

total = 0

pairs.times { |i|
	sq1 = ((sq1 * factor_A) % g)
	sq2 = ((sq2 * factor_B) % g)

	total += 1 if sq1 % 0x10000 == sq2  % 0x10000
}

puts "part1=>#{total}"

# part 2

pairs = 5000000
pairs = 1060
total = 0

sq1 = 65
sq2 = 8921

sl1, sl2 = [], []

pairs.times { |i|
	sq1 = (sq1 * factor_A) % g
	sq2 = (sq2 * factor_B) % g

	sl1 << sq1%0x100 if sq1 % 4 == 0
	sl2 << sq2%0x100 if sq2 % 4 == 0
}

[sl1.size, sl2.size].min.times { |i|
	total += 1 if sl1[i] == sl2[i]
}
p sl1[-3..], sl2[-3..]
puts "part2=>#{total}"
