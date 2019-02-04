INPUT = File.open("day5").each_line.map(&:to_i)

v = INPUT.clone
pos = 0
steps = 0
while pos >= 0 and pos < v.size do
	v[pos], pos = v[pos] + 1, pos + v[pos]
	steps += 1
end
p steps

# part 2
v = INPUT.clone
pos = 0
steps = 0
while pos >= 0 and pos < v.size do
	v[pos], pos = v[pos] + (if v[pos] >= 3 then -1 else 1 end), pos + v[pos]
	steps += 1
end
p steps