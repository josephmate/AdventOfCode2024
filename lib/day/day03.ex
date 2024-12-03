defmodule AdventOfCode.Day03 do
  defstruct  day: "03"

  defimpl AdventOfCode.DaySolution do
    def sample_part1_files(value) do
      %{
        "day#{value.day}_sample.txt" => "day#{value.day}_sample_part1_result.txt"
      }
    end

    @fallback_to_any true
    def sample_part2_files(value) do
      %{
        "day#{value.day}_sample.txt" => "day#{value.day}_sample_part2_result.txt"
      }
    end
  end

    # |> Stream.each(&IO.inspect/1)
  def part1(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.split()/1)
  end

  def part2(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.split()/1)
  end

end
