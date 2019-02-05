require 'set'

INPUT = File.open("day7")

INPUT2 = """\
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
"""

$programs = {}

class Program
	def initialize(name, weight = 0)
		@name = name
		@weight = weight
		@above = []
		@below = []
	end

	def add_above(program_above)
		@above.push(program_above)
		program_above.add_below(self)
	end

	def add_below(program_below)
		@below.push(program_below)
	end

	def is_balanced
		weights = above.map {|prog| prog.combined_weight}
		#p above.map {|x| x.name}, weights, weights.uniq.size, "\n"
		weights.uniq.size <= 1
	end

	def fix_balance
		above.map { |prog| prog.fix_balance }

		weights = above.map {|prog| prog.combined_weight}
		if weights.uniq.size > 1 then
			p weights
			bad_weight = weights.find {|x| weights.count(x) == 1}
			good_weight = weights.find {|x| weights.count(x) > 1}
			puts "bad weight #{bad_weight}, good is #{good_weight}"
			diff = bad_weight - good_weight
			bad_idx = weights.index(bad_weight)
			print "fixing #{above[bad_idx].name}, new weight: "
			puts (above[bad_idx].weight -= diff)

			#p above.map {|prog| prog.combined_weight}
		end
	end

	def combined_weight
		@weight + (above.reduce(0) {|acc,x| acc + x.combined_weight})
	end

	attr_accessor :name, :weight, :below, :above
end

def get_program(name)
	return $programs[name] ||= Program.new(name)
end

INPUT.each_line do |x|
	x = x.strip
	#p x
	name, weight = x.match('([^ ]+) \((\d+)\)')[1..2]
	#puts "#{name} with weight #{weight}"

	program = get_program(name)
	program.weight = weight.to_i

	if x.include?("->") then
		above = x.split(" -> ")[1].split(", ")
		above.each {|above| program.add_above get_program(above)}
	end
end

#must be 1
#p ($programs.values.select {|x| x.below.size == 0}).size

root = $programs.values.find {|x| x.below.size == 0}
puts "part1: #{root.name}"

root.fix_balance
#p root.is_balanced
#puts $programs.map {|name,program| [program.name, program.combined_weight, program.is_balanced]}
print "all fixed: "
puts $programs.all? {|name,x| x.is_balanced }
