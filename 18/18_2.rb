input = "
set a 1
set b 2
snd a
snd b
snd p
rcv a
rcv b
rcv c
rcv d
"
input = File.open("data").read

class Player
	@@prog_id = -1
	@@channels = {}

	def self.get_id
		@@prog_id += 1
		@@channels[@@prog_id] = []

		return @@prog_id
	end

	def initialize(asm)
		@asm = asm.strip.split("\n").map(&:split)
		@id = Player.get_id
		@chan = @@channels[@id]
		@send_cnt = 0

		@reg = {"p"=>@id}
		@reg.default_proc = proc { |h, k| h[k] = 0 }

		@pc = 0
	end

	def run
		loop do
			op, r, i = @asm[@pc]
			(i.match?(/\d+/)? i = i.to_i: i = @reg[i]) if i != nil
			r.match?(/\d+/)? r_i = r.to_i: r_i = @reg[r]
			@pc += 1
			case op
			when "snd"
				send r_i
			when "set"
				@reg[r] = i
			when "add"
				@reg[r] += i
			when "mul"
				@reg[r] = r_i * i
			when "mod"
				@reg[r] = r_i % i
			when "rcv"
				@reg[r] = recv
			when "jgz"
				@pc = @pc - 1 + i if r_i > 0
			else
				puts "not supported operation #{op} !"
			end
			break if @pc >= @asm.size || @pc < 0
		end
	end

	def send(x)
		# more like broadcast
		@@channels.each { |id, chan|
			if id != @id
				chan << x
			end
		}
		@send_cnt += 1

	end

	def recv
		printed = false
		while @chan.size == 0
			if !printed
				puts "prog #{@id} sent #{@send_cnt} msgs"
				printed = true
			end
		end
		return @chan.shift
	end

	attr_accessor :id
end


p1 = Player.new(input)
p2 = Player.new(input)

t1 = Thread.new{p1.run}
t2 = Thread.new{p2.run}

t1.join
t2.join
