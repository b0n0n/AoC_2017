=begin
tape [0, 0, 0...]
cursor
states
=end

class Turing
	def initialize(state=:state_A)
		@state = :state_A
		@tape = {}
		@tape.default_proc = proc { |h, k| h[k] = 0 }
		@cursor = 0
	end

	def run(steps=1000)
		steps.times { @state = send(@state) }
	end

	def checksum
		return @tape.reduce(0) { |s, i| s += i[1] }
	end

	def state_A
		v = read
		case v
		when 0
			write(1)
			move_r
			return :state_B
		when 1
			write(0)
			move_l
			return :state_B
		end
	end

	def state_B
		v = read
		case v
		when 0
			write(1)
			move_l
			return :state_C
		when 1
			write(0)
			move_r
			return :state_E
		end
	end

	def state_C
		v = read
		case v
		when 0
			write(1)
			move_r
			return :state_E
		when 1
			write(0)
			move_l
			return :state_D
		end
	end

	def state_D
		write(1)
		move_l
		return :state_A
	end

	def state_E
		v = read

		case v
		when 0
			write(0)
			move_r
			return :state_A
		when 1
			write(0)
			move_r
			return :state_F
		end
	end

	def state_F
		v = read

		case v
		when 0
			write(1)
			move_r
			return :state_E
		when 1
			write(1)
			move_r
			return :state_A
		end
	end

	def read
		@tape[@cursor]
	end

	def write(n_v)
		@tape[@cursor] = n_v
	end

	def move_r(slot=1)
		@cursor += slot
	end

	def move_l(slot=1)
		@cursor -= slot
	end
end


m = Turing.new
m.run(12683008)
puts "part1 => #{m.checksum}"
