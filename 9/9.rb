=begin
{}
<> <gets ignored
! ignore next char
=end

input = File.open("data").read.strip
# input = "
# <!!!>>
# ".strip


class Stream
	def initialize(data)
		@data = data
		@pos = -1

		@state = :GroupState
		@depth = 0
		#part1
		@score = 0
		#part2
		@garbage = 0
	end

	def peek
		@data[@pos+1]
	end

	def next_
		@pos += 2 while peek == "!"
		@data[@pos+=1]
	end

	def backup
		@pos -= @width
	end

	def scan
		@state = send(@state) until @state == nil
	end

	def GroupState
		loop do
			case next_
			when "{"
				@depth += 1
				@score += @depth
			when "}"
				@depth -= 1
			when "<"
				return :GarboState
			when nil
				return nil
			else
				# absorb chars
			end
		end
	end

	def GarboState
		loop do
			case next_
			when ">"
				return :GroupState
			when nil
				return nil
			else
				@garbage += 1
			end
		end
	end

	attr_accessor :score, :garbage
end

s = Stream.new(input)
s.scan
puts "part1=>#{s.score}"
puts "part2=>#{s.garbage}"
