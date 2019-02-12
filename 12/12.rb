input = File.open("data").read.strip
# input = "
# 0 <-> 2
# 1 <-> 1
# 2 <-> 0, 3, 4
# 3 <-> 2, 4
# 4 <-> 2, 3, 6
# 5 <-> 6
# 6 <-> 4, 5
# ".strip

$psz = 0
$id = []
$sz = []
$pairs = []
$gps = $psz

def find(pg)
	pg = $id[pg] until pg == $id[pg]
	return pg
end

def union(pg1, pg2)
	g1 = find(pg1)
	g2 = find(pg2)

	return if g1 == g2

	if $sz[g1] < $sz[g2]
		$id[g1] = $id[g2]
		$sz[g2] += $sz[g1]
	else
		$id[g2] = $id[g1]
		$sz[g1] += $sz[g2]
	end
	$pgs -= 1
end

# parse
input.each_line { |line|
	matched = line.match(/(?<from>\d+) \<\-\> (?<to>[\d\ ,]+)/)
	# get pairs
	from, to = matched[:from].to_i, matched[:to].split(", ").map(&:to_i)
	# total programs
	$psz = [*to, from, $psz].max
	#  generate pairs
	to.each { |dst| $pairs << [from, dst]}
}

# go
$pgs = $psz+1
$pgs.times { |i|
	$id[i] = i
	$sz[i] = 1
}

$pairs.each { |pair|
	union(*pair)
}

puts "part1 => #{$sz[find(0)]}"
puts "part2 => #{$pgs}"
