input = File.read("input.txt")
ranges = input.split(",")

total = 0

ranges.each_with_index do |r, i|
  range = r.split("-")
  r_max = Integer(range[1])
  r_min = Integer(range[0])

  
  for current in r_min..r_max

    next if current.to_s.length % 2 != 0 # skip if odd length

    h_len = (current.to_s.length / 2)

    
    lower = current.to_s[0..(h_len-1)]
    upper = current.to_s[h_len..-1]

    puts "range[#{i}]: #{lower}|#{upper}, len: #{h_len}"


    if lower == upper
      total += current
      puts "found pair, #{lower} == #{upper}"
      puts current
    end
  end
end

puts total