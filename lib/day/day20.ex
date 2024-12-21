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

    [start_posn | _ ] = map
    |> Enum.filter(fn {{_,_},val} -> val == ?S end)
    |> Enum.map(fn {{r,c},_} -> {r,c} end)

    [end_posn | _ ] = map
    |> Enum.filter(fn {{_,_},val} -> val == ?E end)
    |> Enum.map(fn {{r,c},_} -> {r,c} end)

    no_cheat_path = map
    |> bfs(start_posn, end_posn)
    |> IO.inspect()
  end

  def bfs(map, {r,c}, end_posn) do
    queue = :queue.new()
    queue = :queue.in({r,c , 0, []}, queue)
    visited = %{}
    visited = Map.put(visited, {r,c}, 0)
    bfs_impl(map, end_posn, queue, visited)
  end

  def bfs_impl(map, end_posn, queue, visited) do
    IO.puts("bfs_impl")
    IO.inspect(end_posn)
    IO.inspect(queue)
    IO.inspect(visited)
    if :queue.is_empty(queue) do
      # no moves left
      # expected to read the end
      nil
    else
      {{:value, {r, c, moves, path}}, queue} = :queue.out(queue)
      if {r, c} == end_posn do
        [{r,c, moves} | path]
        |> Enum.reverse()
      else
        IO.puts("inspecting move")
        IO.inspect(!Map.has_key?(map, {r,c}))
        IO.inspect(<<Map.get(map, {r,c})>>)
        IO.inspect(moves)
        IO.inspect(Map.get(map, {r,c}, 99999999999))
        path = [{r,c, moves} | path]
        visited = Map.put(visited, {r,c}, moves)
        moves = [
          {r + 0, c + 1, moves + 1, path},
          {r + 0, c - 1, moves + 1, path},
          {r + 1, c + 0, moves + 1, path},
          {r - 1, c + 0, moves + 1, path},
        ]
        |> Enum.filter(fn {r,c,moves,_} ->
          Map.has_key?(map, {r,c})
          and (Map.get(map, {r,c}) == ?. or Map.get(map, {r,c}) == ?S)
          and moves < Map.get(map, {r,c}, 99999999999)
        end)

        queue = moves
        |> Enum.reduce(queue, fn element, acc ->
          :queue.in(element, acc)
        end)

        visited = moves
        |> Enum.reduce(visited, fn {r,c, moves, _}, acc ->
          Map.put(acc, {r,c}, moves)
        end)

        bfs_impl(map, end_posn, queue, visited)
      end
    end
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
