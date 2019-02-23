require "Set"

=begin

d,v,a
3, 2, -1

3+(2-1)
3+(2-1)+(2-1-1) = 4; t = 2
3+(2-1)+(2-1-1)+(2-1-1-1) = 3; t = 3

3 + v*t + a*(1+t)*t/2
=end

input = File.open("data").read
# input = "
# p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
# p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>
# "
# input = "
# p=<-6,0,0>, v=< 3,0,0>, a=< 0,0,0>
# p=<-4,0,0>, v=< 2,0,0>, a=< 0,0,0>
# p=<-2,0,0>, v=< 1,0,0>, a=< 0,0,0>
# p=< 3,0,0>, v=<-1,0,0>, a=< 0,0,0>
# "

class Particle
	def initialize(p, v, a)
		@x, @y, @z = p
		@v_x, @v_y, @v_z = v
		@a_x, @a_y, @a_z = a
	end

	def self.distance(src, dst)
		s_x, s_y, s_z = src
		d_x, d_y, d_z = dst
		return (s_x-d_x).abs + (s_y-d_y).abs + (s_z-d_z).abs
	end

	def pos_after(t)
		new_x = @x + @v_x*t + (@a_x*t*(t+1) / 2)
		new_y = @y + @v_y*t + (@a_y*t*(t+1) / 2)
		new_z = @z + @v_z*t + (@a_z*t*(t+1) / 2)


		return [new_x, new_y, new_z]
	end
end

# p=<-4897,3080,2133>, v=<-58,-15,-78>, a=<17,-7,0>
def gen_particles(data)
	particles = []
	data.strip.each_line { |line|
		x, y, z, v_x, v_y, v_z, a_x, a_y, a_z = line.scan(/([\-\d]+)/).flatten.map(&:to_i)
		particles << Particle.new([x, y, z], [v_x, v_y, v_z], [a_x, a_y, a_z])
	}
	return particles
end


def part1(input)
	ps = gen_particles(input)

	t = 10000		# check result after 10000 seconds
	closest = -1
	min_dist = -10000

	ps.each_with_index { |p, i|
		dist = Particle.distance(p.pos_after(t), [0, 0, 0])
		min_dist = dist if i == 0
		(closest = i) && (min_dist = dist) if dist < min_dist
	}

	return closest
end

def part2(input)
	start_t = Time.now.to_f

	ps = gen_particles(input)
	done = Set.new()
	pos_record = {}
	pos_record.default_proc = proc { |h, k| h[k] = [] }

	t = 1000

	t.times { |tt|
		ps.each { |p|
			pos_record[p.pos_after(tt)] << p
		}
		ps.clear
		pos_record.each { |k, v| ps << v.first if v.size == 1}
		pos_record.clear

	}

	end_t = Time.now.to_f
	puts "taken #{(end_t-start_t).round(4)}"
	return ps.size
end

def part2_2(input)
	start_t = Time.now.to_f

	ps = gen_particles(input)
	done = Set.new()
	pos_record = {}
	pos_record.default_proc = proc { |h, k| h[k] = [] }

	t = 1000

	t.times { |tt|
		ps.size.times { |i|
			next if done.include? i
			pos_record[ps[i].pos_after(tt)] << i
		}
		pos_record.each { |k, v| v.each { |e| done << e } if v.size != 1}
		pos_record.clear
	}

	end_t = Time.now.to_f
	puts "taken #{(end_t-start_t).round(4)}"
	return ps.size - done.size
end



puts "part1 => #{part1(input)}"
puts "part2 => #{part2(input)}"
