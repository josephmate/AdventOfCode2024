defmodule AdventOfCode.Day01 do
  defstruct  day: "01"

  defimpl AdventOfCode.DaySolution do
    def sample_part1_files(value) do
      %{
        "day#{value.day}_sample.txt" => "day#{value.day}_sample_part1_result.txt"
      }
    end

    @fallback_to_any true
    def sample_part2_files(value) do
      day_num = AdventOfCode.DaySolution.day(value)
      %{
        "day#{value.day}_sample.txt" => "day#{value.day}_sample_part1_result.txt"
      }
    end
  end

    # |> Stream.each(&IO.inspect/1)
  def part1(input) do
    {first_list, second_list} = input
    |> String.split("\n")
    |> Stream.map(&String.split()/1)
    |> Stream.map(&List.to_tuple()/1)
    |> Stream.map(fn {a, b} -> {String.to_integer(a), String.to_integer(b)} end)
    |> Enum.to_list()
    |> Enum.unzip()

    first_list = Enum.sort(first_list)
    second_list = Enum.sort(second_list)

    Stream.zip([first_list, second_list])
    |> Stream.map(fn {a,b} -> abs(a-b) end)
    |> Enum.to_list()
    |> Enum.sum()
  end

  def part2(input) do
    0
  end

end
