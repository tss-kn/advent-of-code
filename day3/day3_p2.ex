defmodule Seq do
  def subsequence?([], _), do: true
  def subsequence?(_, []), do: false

  def subsequence?([p | ps], [h | t]) do
    if p == h do
      subsequence?(ps, t)
    else
      subsequence?([p | ps], t)
    end
  end
end

defmodule AOCDay3 do
  def run(file_contents) do
    banks = String.split(file_contents)

    find_largest_joltage(banks)
    |> IO.puts()
  end

  def find_largest_joltage([], total), do: total

  def find_largest_joltage([bank | rest], total \\ 0) do
    joltages =
      String.graphemes(bank)
      |> Enum.map(&String.to_integer/1)
      |> IO.inspect()

    joltage_largest = find_max_number_pair(joltages)

    IO.puts(joltage_largest)

    find_largest_joltage(rest, total + joltage_largest)
  end

  def find_max_number_pair(nums, 0), do: 0

  # TODO: this works but it's super slow, fix it
  def find_max_number_pair(nums, i \\ 999999999999) when i > 0 do
    digits = Integer.digits(i) |> IO.inspect()
    if Seq.subsequence?(digits,nums) do
      i
    else
      find_max_number_pair(nums, i - 1)
    end

  end
end

{:ok, file} = File.read("input.txt")
AOCDay3.run(file)
