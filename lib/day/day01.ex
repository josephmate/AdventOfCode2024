defmodule AdventOfCode.Day01 do
  @behaviour AdventOfCode.DaySolution

  @impl AdventOfCode.DaySolution
  def sample_part1_files do
    %{
      "day01_sample01_part01.txt" => "day01_sample01_part01_result.txt",
    }
  end

  @impl AdventOfCode.DaySolution
  def sample_part2_files do
    %{
      "day01_sample01_part02.txt" => "day01_sample01_part02_result.txt",
    }
  end

  def part1(input) do
    input
    |> String.split("\n")
    |> Stream.each(&IO.inspect/1)
    |> Stream.map(&String.graphemes()/1)
    |> Stream.each(&IO.inspect/1)
    |> Stream.map(fn chars ->
      chars
      |> Stream.filter(&(&1 >= "1" and &1 <= "9"))
      |> Stream.map(&String.to_integer()/1)
      |> Enum.to_list()
      end)
    |> Stream.each(&IO.inspect/1)
    |> Stream.map(fn digits -> hd(digits)*10 + List.last(digits) end)
    |> Stream.each(&IO.inspect/1)
    |> Enum.sum()
  end

  def part2(input) do
    0
  end

end
