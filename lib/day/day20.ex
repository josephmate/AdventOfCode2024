defmodule AdventOfCode.Day20 do
  defstruct  day: "20"

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

  def part1(_input) do
    IO.puts("expected")
    IO.puts("There are 14 cheats that save 2 picoseconds.")
    IO.puts("There are 14 cheats that save 4 picoseconds.")
    IO.puts("There are 2 cheats that save 6 picoseconds.")
    IO.puts("There are 4 cheats that save 8 picoseconds.")
    IO.puts("There are 2 cheats that save 10 picoseconds.")
    IO.puts("There are 3 cheats that save 12 picoseconds.")
    IO.puts("There is one cheat that saves 20 picoseconds.")
    IO.puts("There is one cheat that saves 36 picoseconds.")
    IO.puts("There is one cheat that saves 38 picoseconds.")
    IO.puts("There is one cheat that saves 40 picoseconds.")
    IO.puts("There is one cheat that saves 64 picoseconds.")
    IO.puts("actual")
    Path.join([File.cwd!(), "inputs", "day20_sample.txt"])
    |> File.read!()
    |> solve_part1()
    |> IO.inspect()

    #IO.puts("real")
    #Path.join([File.cwd!(), "inputs", "day20.txt"])
    #|> File.read!()
    #|> solve_part1()
    #|> IO.inspect()

    0
  end

  def solve_part1(input) do
    map = input
    |> String.split("\n")
    |> Enum.map(&String.to_charlist()/1)
    |> two_dim_list_to_coord_tuples()
    |> Enum.reduce(%{}, fn {r,c,val}, map ->
      Map.put(map, {r,c}, val)
    end)

    start_posn = map
    |> Enum.filter(fn {_,_,val} -> val == ?S end)
    |> Enum.map(fn {r,c,_} -> {r,c} end)
    |> Enum.take(1)

    end_posn = map
    |> Enum.filter(fn {_,_,val} -> val == ?S end)
    |> Enum.map(fn {r,c,_} -> {r,c} end)
    |> Enum.take(1)

    map
    |> bfs(start_posn, end_posn)
  end

  def bfs(map, start_posn, end_posn) do

  end

  def two_dim_list_to_coord_tuples(two_dim_list) do
     for {row, row_index} <- Enum.with_index(two_dim_list),
      {val, col_index} <- Enum.with_index(row),
      do: {row_index, col_index, val}
  end

  def part2(_input) do
    0
  end

end
