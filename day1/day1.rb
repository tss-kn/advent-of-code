content = File.read("aoc1.txt")

dial_pos = 50
password = 0

# Split to ["L/R", "num"] list, remove whitespace
instructions = content.split(/([0-9]+)/).map(&:strip) 

# Parse and execute instructions
instructions.each_slice(2) do |dir,v|
  amount = Integer(v)

  # stolen from medium because I give up
  amount.times do
    dial_pos += dir == "R" ? 1 : -1 
    password += 1 if dial_pos % 100 == 0
  end
end

puts password