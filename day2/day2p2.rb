input = File.read("input.txt")
ranges = input.split(",")

total = 0

ranges.each do |r|
  min, max = r.split("-").map!(&:to_i)

  (min..max).each do |num|
    s = num.to_s
    len = s.length
    next if len == 1

    found = false

    (1..(len / 2)).each do |slice_size|
      next unless (len % slice_size).zero?

      unit = s[0, slice_size]
      if unit * (len / slice_size) == s
        total += num
        found = true
        break
      end
    end
  end
end

puts total
