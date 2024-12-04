defmodule AdventOfCode.Day04 do
  defstruct  day: "04"

  defimpl AdventOfCode.DaySolution do
    def sample_part1_files(value) do
      %{
        "day#{value.day}_sample.txt" => "day#{value.day}_sample_part1_result.txt"
      }
    end

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
    |> Stream.map(fn row -> Enum.map(row, &String.to_integer()/1) end)
    |> Enum.count()
  end

  def part2(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.split()/1)
    |> Stream.map(fn row -> Enum.map(row, &String.to_integer()/1) end)
    |> Enum.count()
  end

end
