defmodule AOCDay1 do
  def run(file_contents) do
    lines = String.split(file_contents)
    instructions = Enum.map(lines, &parse_instruction/1)
    {password, dial_pos} = do_instructions(instructions, 50, 0)
    IO.puts("The password is #{password}")
  end

  # Parse a dial instruction from the given line
  @spec parse_instruction(String.t()) :: {String.t(), String.t()}
  def parse_instruction(instruction) do
    # Capture the letter and the turn amount number (e.g. L25 -> [["L"], ["2", "5"]])
    {letter, digit} =
      instruction
      |> String.graphemes()
      |> Enum.split_while(&(&1 =~ ~r/[A-Z]/))

    # Join them together (e.g. [["L"], ["2", "5"]] -> ["L", "25"])
    {Enum.join(letter), Enum.join(digit)}
  end

  # Do the instructions sequentially
  @spec do_instructions([{String.t(), String.t()}], integer, integer) ::
          {integer, integer}
  def do_instructions([], dial_state, password), do: {password, dial_state}

  def do_instructions([{instruction, amount} | rest], dial_state, password) do
    {amt, ""} = Integer.parse(amount)
    IO.puts(instruction)

    {next_dial_state, next_password} =
      case instruction do
        "L" -> rotate_dial(amt, -1, dial_state, password)
        "R" -> rotate_dial(amt, 1, dial_state, password)
      end

    IO.puts("password: #{password} dial_state: #{dial_state}")
    do_instructions(rest, next_dial_state, next_password)
  end

  def rotate_dial(0, dir, dial_state, password), do: {dial_state, password}

  def rotate_dial(amount, dir, dial_state, password) when amount > 0 do
    next_dial_state = dial_state + dir
    next_password = if rem(dial_state, 100) == 0, do: password + 1, else: password
    rotate_dial(amount - 1, dir, next_dial_state, next_password)
  end
end

{:ok, file} = File.read("aoc1.txt")
AOCDay1.run(file)
