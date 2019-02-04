require 'set'
banks = File.open("data").read.strip.split("\t").map(&:to_i)
# banks = [0, 2, 7, 0]

$seen = Set.new

def redistr(banks)
  $seen << banks

  pos = banks.index(banks.max)
  blks, banks[pos] = banks[pos], 0

  begin
    pos = (pos + 1) % banks.size
    banks[pos], blks = banks[pos]+1, blks-1
  end until blks <= 0

  $seen.include? banks
end

steps = 1
steps += 1 until redistr(banks)
puts "part1=> #{steps}"

init = banks.dup
cycles = 0
begin
  cycles += 1
  redistr(banks)
end until banks == init
puts "part2=> #{cycles}"
