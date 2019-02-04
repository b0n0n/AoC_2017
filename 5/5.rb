data = File.open("data.in").read
# data = "0\n3\n0\n1\n-3"
PART2 = true

maze = []
data.split("\n").each do |instruction|
  maze.push instruction.to_i
end

interrupt = 0
steps = 0

while interrupt < maze.length do
  maze[interrupt], interrupt = maze[interrupt] + (if PART2 && maze[interrupt] >= 3; -1 else 1 end), interrupt + maze[interrupt]
  steps += 1
end

if PART2; puts "part2=>#{steps}" else "part1=>#{steps}" end
