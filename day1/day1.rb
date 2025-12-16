content = File.read("aoc1.txt")

dial_pos = 50
password = 0

# Split to ["L/R", "num"] list, remove whitespace
instructions = content.split(/([0-9]+)/).map(&:strip) 

# Parse and execute instructions
instructions.each_slice(2) do |i,v|
  case i
  when "L" then dial_pos = (dial_pos - Integer(v)) % 100
  when "R" then dial_pos = (dial_pos + Integer(v)) % 100
  end

  dial_pos += 100 if dial_pos < 0

  puts dial_pos.to_s
  password += 1 if dial_pos == 0
end

puts password.to_s