defmodule AdventOfCode.Day03 do
  defstruct  day: "03"

  defimpl AdventOfCode.DaySolution do
    def sample_part1_files(value) do
      %{
        "day#{value.day}_sample.txt" => "day#{value.day}_sample_part1_result.txt"
      }
    end

    def sample_part2_files(value) do
      %{
        "day#{value.day}_sample_part2.txt" => "day#{value.day}_sample_part2_result.txt"
      }
    end
  end

    # |> Stream.each(&IO.inspect/1)
  def part1(input) do
    regex = ~r/mul\((\d+),(\d+)\)/
    Regex.scan(regex, input)
    |> IO.inspect()
    |> Enum.map(fn [a,b,c] ->
      IO.puts("first " <> a  <> " second " <> b <> " third "  <> c)
      [a,b,c]
      end)
    |> Enum.map(fn [_a, b, c] -> {String.to_integer(b), String.to_integer(c)} end)
    |> Enum.map(fn {a,b} -> a * b end)
    |> Enum.sum()
  end

  def part2(input) do
    regex = ~r/(mul\((\d+),(\d+)\))|(do\(\))|(don't\(\))/
    Regex.scan(regex, input)
    |> IO.inspect()
    |> Enum.reduce([true, 0], &reducer/2)
    |> Kernel.then(fn [_doit, acc] -> acc end)
  end

  defp reducer(match, [doit, acc]) do
    case match do
      ["mul" <> _, _, a, b] ->
        if doit do
          [doit, acc + String.to_integer(a) * String.to_integer(b)]
        else
          [doit, acc]
        end


      ["don't()" | _tail] ->
        [false, acc]

      ["do()" | _tail] ->
        [true, acc]

    end
  end
end
