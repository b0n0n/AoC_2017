# coding: utf-8
# input = [3, 4, 1, 5]
# l = [0, 1, 2, 3, 4]

seq = File.open("data").read.strip.split(",").map(&:to_i)
l = [*0..255]

t_r = 0

seq.each_with_index { |r_l, s_l|
	l[0, r_l] = l[0, r_l].reverse
	t_r += r_l+s_l
	l.rotate!(r_l+s_l)
}
l.rotate!(-(t_r%l.size))


puts "part1 => #{l[0]*l[1]}"

# ==== part2 ====
# seq = "1,2,3".bytes

suffix = [17, 31, 73, 47, 23]
seq = File.open("data").read.strip.bytes
seq.push(*suffix)
l = [*0..255]

t_r = 0

seq.cycle(64).each_with_index { |r_l, s_l|
	l[0, r_l] = l[0, r_l].reverse
	t_r += r_l+s_l
	l.rotate!(r_l+s_l)
}
l.rotate!(-(t_r%l.size))

hash = ""
l.each_slice(16) { |i| hash += i.reduce(:^).to_s(16)}

puts "part2 => #{hash}"
