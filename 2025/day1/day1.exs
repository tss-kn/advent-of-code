defmodule AOCDay1 do
  def run(contents) do
    lines = String.split(contents)
    instructions = Enum.map(lines, &parse_instruction/1)
    {password, dial_pos} = do_instructions(instructions, 50, 0)
    IO.puts("The password is #{password}")
  end

  def parse_instruction(instruction) do
    {letter, digit} =
      instruction
      |> String.graphemes()
      |> Enum.split_while(&(&1 =~ ~r/[A-Z]/))

    {Enum.join(letter), Enum.join(digit)}
  end

  def do_instructions([], dial_state, password), do: {password, dial_state}

  def do_instructions([{instruction, amount} | rest], dial_state, password) do
    {amt, ""} = Integer.parse(amount)

    new_d =
      case instruction do
        "L" -> rotate_dial(dial_state, -amt)
        "R" -> rotate_dial(dial_state, amt)
      end

    IO.puts(dial_state)

    if dial_state == 0 do
      do_instructions(rest, new_d, password + 1)
    else
      do_instructions(rest, new_d, password)
    end
  end

  defp rotate_dial(x, amount) do
    x2 = rem(x + amount, 100)
    if x2 < 0, do: x2 + 100, else: x2
  end
end

{:ok, file} = File.read("aoc1.txt")
AOCDay1.run(file)
