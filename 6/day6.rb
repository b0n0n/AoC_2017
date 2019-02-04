require 'set'

INPUT = File.open("day6").read.split("\t").map(&:to_i)

#INPUT = [0, 2, 7, 0]

# part 1
seen = Set.new
v = INPUT.clone
steps = 0

def next_state(v)
	m = v.max
	m_i = v.index(m)

	v[m_i] = 0
	m.times do
		m_i = (m_i + 1) % v.size
		v[m_i] += 1
	end
end

while not seen.include?(v) do
	seen.add(v)
	next_state v
	steps += 1
end

wanted = v.clone
part2 = 0
begin
	next_state v
	part2 += 1
end while v != wanted

p v
p steps
p part2
