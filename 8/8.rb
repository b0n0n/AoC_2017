# coding: utf-8
=begin

reg inc/dec condition
all reg starts at 0

=end

input = "
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
"
input = File.open("data").read
lines = input.strip.split("\n")

regs = lines.map{ |line|
	"$" + line.split(" ")[0]
}.uniq

regs.map { |reg_expr| eval(reg_expr + " = 0")}

max = 0

lines.map { |line|
	n_expr = line.sub("inc", "+=").sub("dec", "-=")
	n_expr = "$"+n_expr.sub("if ", "if $")
	eval(n_expr)

	max = [regs.map { |reg| eval(reg) }.max, max].max
}

puts "part1 => #{regs.map { |reg| eval(reg) }.max}"
puts "part2 => #{max}"
