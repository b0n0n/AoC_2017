STEPS = 363
ROUNDS = 2018

=begin
0
0 1
0 2 1
0 2 3 1
0 2 4 3 1
0 5 2 4 3 1
0 5 2 4 3 6 1

s = 3
0 v0 = 0
1 v1 = (s+v0 % 1) + 1 = 1
1 v2 = (s+v1 % 2) + 1 = 1
2 v3 = (s+v2 % 3) + 1 = 2
2 v4 = (s+v3 % 4) + 1 = 2
1 v5 = (s+v4 % 5) + 1 = 1
5 v6 = (s+v5 % 6) + 1 = 5
=end

class Node
	def initialize(value)
		@value = value
		@next = nil
	end

	attr_accessor :next, :value
end

class Spinlock
	def initialize
		@head = nil
		@ptr = nil
	end

	def insert_after(node)
		if @head == nil
			@head = node
			node.next = @head
			@ptr = @head

			@ptr1 = @head
		else
			node.next = @ptr.next
			@ptr.next = node
			@ptr = @ptr.next
		end
	end

	def forward(steps)
		return if @head == nil
		steps.times { |_|
			@ptr = @ptr.next
		}
	end

	def current
		return @ptr.value
	end

	def after_zero
		 @ptr1.next.value
	end

	def reset
		@head = nil
		@ptr = nil
	end
end

s = Spinlock.new()

ROUNDS.times{ |i|
	s.forward(STEPS)
	s.insert_after(Node.new(i))
}
s.forward 1
puts "part1=>#{s.current}"

pos = nil
after_zero = 0

50000000.times { |i|
	if i == 0
		pos = i
		next
	end

	pos = (STEPS + pos) % i + 1

	after_zero = i if pos == 1
}

puts "part2=>#{after_zero}"
