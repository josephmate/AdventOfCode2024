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
    |> Enum.filter(fn {sec, _} -> sec >= 2 end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
    |> IO.inspect()

    IO.puts("real")
    Path.join([File.cwd!(), "inputs", "day20.txt"])
    |> File.read!()
    |> solve_part1()
    |> Enum.filter(fn {sec, _} -> sec >= 100 end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
    |> IO.inspect()

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

    no_cheat_path_map = map
    |> bfs(start_posn, end_posn)
    |> Enum.reduce(%{}, fn {r,c,numMoves}, acc ->
      Map.put(acc, {r,c}, numMoves)
    end)

    no_cheat_path_map
    |> Enum.map(fn {{r,c}, numMoves} ->
      [
        {r + 0, c + 2, numMoves + 2},
        {r + 0, c - 2, numMoves + 2},
        {r + 1, c + 1, numMoves + 2},
        {r + 1, c - 1, numMoves + 2},
        {r - 1, c + 1, numMoves + 2},
        {r - 1, c - 1, numMoves + 2},
        {r + 2, c + 0, numMoves + 2},
        {r - 2, c + 0, numMoves + 2},
      ]
    end)
    |> List.flatten()
    |> Enum.filter(fn {r,c, _} ->
      Map.has_key?(no_cheat_path_map, {r,c})
    end)
    |> Enum.filter(fn {r,c, numMoves} ->
      numMoves < Map.get(no_cheat_path_map, {r,c})
    end)
    |> Enum.map(fn {r,c,numMoves} ->
      {r,c, Map.get(no_cheat_path_map, {r,c}) - numMoves}
    end)
    |> Enum.group_by(
      fn {_,_, numMoves} -> numMoves end,
      fn {r,c, _} -> {r,c} end
    )
    |> Enum.map(fn {k, v} -> {k, length(v)} end)

  end

  def bfs(map, {r,c}, end_posn) do
    queue = :queue.new()
    queue = :queue.in({r,c , 0, [{r,c,0}]}, queue)
    visited = %{}
    visited = Map.put(visited, {r,c}, 0)
    bfs_impl(map, end_posn, queue, visited)

  end

  def bfs_impl(map, end_posn, queue, visited) do
    if :queue.is_empty(queue) do
      # no moves left
      # expected to read the end
      nil
    else
      {{:value, {r, c, numMoves, path}}, queue} = :queue.out(queue)
      if {r, c} == end_posn do #or numMoves == 3 do
        path
        |> Enum.reverse()
      else
        visited = Map.put(visited, {r,c}, numMoves)
        moves = [
          {r + 0, c + 1, numMoves + 1, [{r + 0, c + 1, numMoves + 1} | path]},
          {r + 0, c - 1, numMoves + 1, [{r + 0, c - 1, numMoves + 1} | path]},
          {r + 1, c + 0, numMoves + 1, [{r + 1, c + 0, numMoves + 1} | path]},
          {r - 1, c + 0, numMoves + 1, [{r - 1, c + 0, numMoves + 1} | path]},
        ]
        |> Enum.filter(fn {newr,newc,newNumMoves,_} ->
          Map.has_key?(map, {newr,newc})
          and (Map.get(map, {newr,newc}) == ?.
                or Map.get(map, {newr,newc}) == ?S
                or Map.get(map, {newr,newc}) == ?E
                )
          and newNumMoves < Map.get(visited, {newr,newc}, 99999999999)
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
    IO.puts("expected")
    IO.puts("50 picoseconds or more:")
    IO.puts("There are 32 cheats that save 50 picoseconds.")
    IO.puts("There are 31 cheats that save 52 picoseconds.")
    IO.puts("There are 29 cheats that save 54 picoseconds.")
    IO.puts("There are 39 cheats that save 56 picoseconds.")
    IO.puts("There are 25 cheats that save 58 picoseconds.")
    IO.puts("There are 23 cheats that save 60 picoseconds.")
    IO.puts("There are 20 cheats that save 62 picoseconds.")
    IO.puts("There are 19 cheats that save 64 picoseconds.")
    IO.puts("There are 12 cheats that save 66 picoseconds.")
    IO.puts("There are 14 cheats that save 68 picoseconds.")
    IO.puts("There are 12 cheats that save 70 picoseconds.")
    IO.puts("There are 22 cheats that save 72 picoseconds.")
    IO.puts("There are 4 cheats that save 74 picoseconds.")
    IO.puts("There are 3 cheats that save 76 picoseconds.")
    IO.puts("32 + 31 + 29 + 39 + 25 + 23 + 20 + 19 + 12 + 14 + 12 + 22 + 4 + 3")
    IO.puts("actual")
    Path.join([File.cwd!(), "inputs", "day20_sample.txt"])
    |> File.read!()
    |> solve_part2()
    |> Enum.filter(fn {sec, _} -> sec >= 50 end)
    |> Enum.sort()
    |> IO.inspect()
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
    |> IO.inspect()

    IO.puts("real")
    Path.join([File.cwd!(), "inputs", "day20.txt"])
    |> File.read!()
    |> solve_part2()
    |> Enum.filter(fn {sec, _} -> sec >= 100 end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
    |> IO.inspect()

    0
  end

  def solve_part2(input) do
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

    no_cheat_path_map = map
    |> bfs(start_posn, end_posn)
    |> Enum.reduce(%{}, fn {r,c,numMoves}, acc ->
      Map.put(acc, {r,c}, numMoves)
    end)

    move_vectors = generate_move_vectors(20)

    no_cheat_path_map
    |> Enum.map(fn {{r,c}, numMoves} ->
      generate_moves({r,c}, numMoves, move_vectors)
    end)
    |> List.flatten()
    |> Enum.filter(fn {r,c, _} ->
      Map.has_key?(no_cheat_path_map, {r,c})
    end)
    |> Enum.filter(fn {r,c, numMoves} ->
      numMoves < Map.get(no_cheat_path_map, {r,c})
    end)
    |> Enum.map(fn {r,c,numMoves} ->
      {r,c, Map.get(no_cheat_path_map, {r,c}) - numMoves}
    end)
    |> Enum.group_by(
      fn {_,_, numMoves} -> numMoves end,
      fn {r,c, _} -> {r,c} end
    )
    |> Enum.map(fn {k, v} -> {k, length(v)} end)

  end

  def generate_move_vectors(numMoves) do
    # for 2
    #   {r + 0, c + 2, numMoves + 2},
    #   {r + 0, c - 2, numMoves + 2},
    #   {r + 1, c + 1, numMoves + 2},
    #   {r + 1, c - 1, numMoves + 2},
    #   {r - 1, c + 1, numMoves + 2},
    #   {r - 1, c - 1, numMoves + 2},
    #   {r + 2, c + 0, numMoves + 2},
    #   {r - 2, c + 0, numMoves + 2},


    queue = :queue.new()
    queue = :queue.in({0, 0, 0}, queue)
    visited = Map.new()
    visited = Map.put(visited, {0,0}, 0)
    generate_move_vectors_impl(numMoves, queue, visited)
    |> Enum.filter(fn {{_, _}, numMovesV} -> numMovesV >= 2 end)
    |> Enum.map(fn {{rv,cv}, numMovesV} -> {rv,cv, numMovesV} end)
  end

  def generate_move_vectors_impl(maxMoves, queue, visited) do
    if :queue.is_empty(queue) do
      visited
    else
      {{:value, {rv, cv, numMovesV}}, queue} = :queue.out(queue)

      moves = [
        {rv + 0, cv + 1, numMovesV + 1},
        {rv + 0, cv - 1, numMovesV + 1},
        {rv + 1, cv + 0, numMovesV + 1},
        {rv - 1, cv + 0, numMovesV + 1},
      ]
      |> Enum.filter(fn {newr,newc,newNumMoves} ->
        !Map.has_key?(visited, {newr,newc})
        and newNumMoves <= maxMoves
      end)

      queue = moves
      |> Enum.reduce(queue, fn element, acc ->
        :queue.in(element, acc)
      end)

      visited = moves
      |> Enum.reduce(visited, fn {r,c, moves}, acc ->
        Map.put(acc, {r,c}, moves)
      end)

      generate_move_vectors_impl(maxMoves, queue, visited)
    end
  end

  def generate_moves({r,c}, numMoves, move_vectors) do
    move_vectors
    |> Enum.map(fn {rv, cv, numMovesV} ->
      {r+rv, c+cv, numMoves + numMovesV}
    end)
  end

end
