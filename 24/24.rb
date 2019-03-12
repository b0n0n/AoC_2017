=begin
just a bf solution which is super slow
TODO: improve algorithm
=end
require "set"

input = "\
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10
".strip
# input = File.open("data").read.strip

class Component
	@@id = -1
	def self.get_id
		return @@id += 1
	end

	def initialize(ports)
		@ports = ports
		@id = Component.get_id
	end

	def strength
		return @ports.reduce(0) { |s, v| s += v }
	end

	attr_reader :id, :ports
end

class Bridge
	def initialize(open=0, components=[], strength=0)
		@open_port = open
		@components = Set.new(components)
		@strength = strength
	end

	# returns a new bridge if added a new component
	def add(c)
		c_ports = c.ports.clone

		return nil if @components.include? c.id
		return nil if !c_ports.include? @open_port

		c_ports.delete(@open_port)
		c_ports.size == 0? new_open = @open_port: new_open = c_ports.pop
		cps = @components.clone.add(c.id)
		str = @strength + c.strength

		return Bridge.new(new_open, cps, str)
	end

	def hash
		@components.hash
	end

	attr_reader :components, :strength

end


def init_components(input)
	cps = []
	input.each_line { |line|
		ps = line.split("/").map(&:to_i)
		cps << Component.new(ps)
	}
	return cps
end

def solve(input)
	cps = init_components(input)
	bs = [Bridge.new]
	s = Set.new(bs.map(&:hash))

	loop do
		found_new = false
		bs.clone.each { |b|
			cps.each { |c|
				new_b = b.add(c)
				if new_b != nil && !s.include?(new_b.hash)
					bs << new_b
					s << new_b.hash

					found_new = true
					bs.delete(b)
				end
			}
		}
		break unless found_new
	end

	puts "part1 => #{bs.map(&:strength).max}"

	max_l = bs.map{ |b| b.components.size }.max
	puts "part2 => #{bs.select { |b| b.components.size == max_l}.map(&:strength).max}"
end

solve(input)
