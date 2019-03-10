-require "Set"

input = "
../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#
"
input = File.open("data").read

init_pattern = ".#./..#/###"

class Pattern
	@@RULES = nil

	def initialize(pattern, rules=nil)
		@pattern = pattern.split("/").map{ |row| row.split("")}
		@@RULES ||= rules
	end

	def partial_pattern(pos, size)
		res = ""
		x, y = pos

		raise "out of bound pattern!" if (x + size > @pattern[0].size) ||
						 (y + size > @pattern[0].size)
		size.times { |i|
			size.times { |j|
				res << @pattern[x + i][y + j]
			}
			res << "/"
		}
		return res.chop
	end

	def enhance
		size = @pattern[0].size
		new_pattern = []
		part_size = (if size % 2 == 0 then 2 else 3 end)

		(0...size).step(part_size) { |x|
			arr = []

			(0...size).step(part_size) { |y|
				p = partial_pattern([x, y], part_size)
				arr << @@RULES[p].split("/")
			}

			new_pattern += arr.transpose.map{ |row| row.map { |col| col.split("") }.flatten }
		}
		@pattern = new_pattern
	end

	def to_s
		return @pattern.map{ |row| row.join }.join("\n")
	end

	def count(char)
		return to_s.count(char)
	end
end

def pattern2matrix(pattern)
	mapping = {
		"." => 0,
		"#" => 1,
	}

	matrix = []
	pattern.split("/").each { |row|
		matrix << row.chars.map { |pix| mapping[pix] }
	}

	return matrix
end

def matrix2pattern(matrix)
	mapping = {
		0 => ".",
		1 => "#",
	}

	pattern = matrix.map { |row|
		row.map { |pix| mapping[pix] }.join
	}.join("/")

	return pattern
end

def flip(matrix)
	res = []
	# up&down
	res << matrix.reverse
	# left&right
	res << matrix.map { |row| row.reverse }

	return res
end

def rotate(matrix)
	res = []
	# 90
	m_1 = matrix.transpose.map { |row| row.reverse }
	res << m_1
	# 180
	m_2 = m_1.transpose.map { |row| row.reverse }
	res << m_2
	# 270
	m_3 = matrix.map { |row| row.reverse }.transpose
	res << m_3

	return res
end

def mutate_pattern(pattern)
	matrix = pattern2matrix(pattern)
	# rotate
	rotated = rotate(matrix).map { |m| matrix2pattern(m)}
	res = [pattern, *rotated]

	# flip
	res.clone.each { |p|
		matrix = pattern2matrix(p)
		flip(matrix).each { |m| res << matrix2pattern(m) }
	}
	return Set.new(res).to_a
end

def gen_rules(raw)
	rules = {}
	raw.strip.each_line { |line|
		before, after = line.strip.split(" => ")

		mutated = mutate_pattern(before)
		mutated.each { |pattern|
			if rules.include?pattern
				puts "pattern already exist!"
			end
			rules[pattern] = after
		}
	}

	return rules
end

def solve(input, pattern, iterations=2)
	rules = gen_rules(input)
	init_p = Pattern.new(pattern, rules)
	iterations.times {
		init_p.enhance
	}

	return init_p.count("#")
end

puts "part1 => #{solve(input, init_pattern, 5)}"
puts "part2 => #{solve(input, init_pattern, 18)}"
