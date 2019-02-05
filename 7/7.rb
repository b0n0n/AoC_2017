# coding: utf-8
=begin
comment test
test
=end

# lines = File.open("data").read.split("\n")
input = "
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
"
input = File.open("data").read.strip
lines = input.strip.split("\n")

class Program
	attr_accessor :name, :weight, :children,
		      :parent

	def initialize(n, w)
		@name = n
		@weight = w

		@children = []
	end

	def add_child(child)
		children << child
		child.parent = @name
	end

	def total_weight
		return weight if children.size == 0
		c_ws = children.map{ |c| c.total_weight }
		# find the unblanced one
		comm = c_ws.max_by { |i| c_ws.count(i) }
		prob_c = children.select{ |c| c.total_weight != comm}[0]
		if prob_c != nil
			fixed_weight = prob_c.weight+(comm-prob_c.total_weight)
			puts "part2: #{prob_c.name} from #{prob_c.weight}=>#{fixed_weight}"
			#  fixed it
			prob_c.weight = fixed_weight
		end

		# fix it
		return weight + children.reduce(0){ |sum, child| sum + child.total_weight}
	end

	def is_root
		parent == nil
	end

	def to_s
		"#{name}:#{weight}"
	end
end

rel = {}
progs = {}

lines.each { |line|
	matched = /(?<name>\w*) \((?<weight>\d+)\)( -> (?<children>[\w\,\ ]*))?/.match(line).named_captures
	name, weight, children = matched["name"], matched["weight"].to_i, matched["children"]
	progs[name] = Program.new(name, weight)
	rel[name] = children.split(", ") if children != nil
}

rel.each { |prog, children|
	children.each { |c| progs[prog].add_child(progs[c])}
}

root = progs.values.select { |p| p.is_root }[0]

root.total_weight
