=begin
- separate components like x/x.

- dfs
a, 0/2
b, 2/4
c, 2/3
d, 4/3

a - b - d
|      /
c ---/

- scan the longest bridge see if can add the separated components into it

part1 => 1695
part2 => 1673
time spent => 0.871

=end

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

input = File.open("data").read.strip

class Components

	class Bridge
		def initialize(path=[], strength=0)
			@path = path
			@strength = strength
		end

		attr_accessor :path, :strength
	end


	def initialize(input)
		@components = []
		input.each_line { |line|
			@components << line.split("/").map(&:to_i)
		}

		@adj_l = {}
		@adj_l.default_proc = proc { |h, k| h[k] = [] }

		@uni_components = []
		@init_components = []

		# find uniport components
		@components.each_with_index { |c, i|
			p1, p2 = c
			@uni_components << i if p1 == p2

			@init_components << i if p1==0 || p2==0
		}

		# build graph
		@components.each_with_index { |c1, i|
			@components.each_with_index { |c2, j|
				next if i == j
				next unless (@uni_components&[i, j]).empty?
				add_edge(i, j) if (c1&c2).size > 0
			}
		}
	end

	def add_edge(c1_idx, c2_idx)
		# don't connect init components
		return if (@init_components&[c1_idx, c2_idx]).size == 2

		@adj_l[c1_idx] << c2_idx unless @adj_l[c1_idx].include? c2_idx
		@adj_l[c2_idx] << c1_idx unless @adj_l[c2_idx].include? c1_idx
	end

	def adj(c_idx, open_port)
		@adj_l[c_idx].select{ |i|
			# adj components which has the same open port
			ports(i).include? open_port
		}.select { |i|
			# and not init component
			!@init_components.include? i
		}
	end

	def strength(c_idx)
		return @components[c_idx].sum
	end

	def ports(c_idx)
		return @components[c_idx]
	end

	def solve
		@bridges = []
		# gen the bridges
		@init_components.each { |v| dfs(v) }

		max_str, max_len = 0, 0

		@bridges.each { |b|
			max_str = [max_str, b.strength].max
			max_len = [max_len, b.path.size].max
		}

		uni_str_sum = @uni_components.map{ |c| strength(c) }.sum

		res_bridges = []
		@bridges.each { |b|
			if b.strength + uni_str_sum > max_str
				enlong(b)
				res_bridges << b
			elsif b.path.size + @uni_components.size >= max_len
				enlong(b)
				res_bridges << b
			end
		}

		p1 = res_bridges.max_by { |b| b.strength }.strength
		p2 = res_bridges.sort_by { |b| [-b.path.size, -b.strength] }.first.strength

		puts "part1 => #{p1}"
		puts "part2 => #{p2}"

	end

	def dfs(v, marked=[], path=[], open_p=0, str=0)
		marked[v] = true
		path << v
		open_p = (ports(v) - [open_p]).first
		str += strength(v)

		leaf = true

		adj(v, open_p).each { |w|
			next if marked[w]
			dfs(w, marked.clone, path.clone, open_p, str)
			leaf = false
		}

		@bridges << Bridge.new(path, str) if leaf
	end

	def enlong(bridge)
		old_path, str = bridge.path, bridge.strength
		new_path = []
		uni_comps = @uni_components.clone

		old_path.each { |i|
			new_path << i
			uni_comps.clone.each { |j|
				next if (ports(j)&ports(i)).empty?

				new_path << j
				str += strength(j)

				uni_comps.delete(j)
			}
		}

		bridge.strength = str
		bridge.path = new_path
	end

	attr_reader :adj_l, :init_components, :uni_components

	public :strength, :adj
	protected :add_edge
end

def solve(input)
	comps = Components.new(input)
	comps.solve
end

s_t = Time.now.to_f
solve(input)
puts "time spent => #{(Time.now.to_f - s_t).round(4)}"
