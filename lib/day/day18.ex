defmodule AdventOfCode.Day18 do
  defstruct  day: "18"

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
    IO.puts("22")
    IO.puts("actual")
    solve_part1(
      Path.join([File.cwd!(), "inputs", "day18_sample.txt"])
      |> File.read!(),
      6,
      12
    )
    |> IO.inspect()

    IO.puts("real")
    solve_part1(
      Path.join([File.cwd!(), "inputs", "day18.txt"])
      |> File.read!(),
      70,
      1024
    )
    |> IO.inspect()

    0
  end

  def solve_part1(input, max_val, steps) do
    memory_map = input
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, ",") end)
    |> Enum.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
    |> Enum.take(steps)
    |> Enum.reduce(%{}, fn {x, y}, acc ->
      Map.put(acc, {x, y}, ?#)
    end)

    find_shortest_path_len(memory_map, max_val, {0,0}, {max_val, max_val})
  end

  def find_shortest_path_len(memory_map, max_val, {startx,starty}, {endx, endy}) do
    queue = :queue.new()
    queue = :queue.in({startx, starty, 0}, queue)
    visited = find_shortest_path_len_impl(memory_map, max_val, queue, %{})
    Map.get(visited, {endx, endy})
  end

  def find_shortest_path_len_impl(memory_map, max_val, queue, visited) do
    if :queue.is_empty(queue) do
      # no moves left
      visited
    else
      {{:value, {x, y, moves}}, queue} = :queue.out(queue)
      if (x > max_val or x < 0
        or y > max_val or y < 0)
        or (Map.has_key?(visited, {x,y}) and moves >= Map.get(visited, {x,y}))
        or (Map.has_key?(memory_map, {x, y}) and Map.get(memory_map, {x, y}) == ?#) do
        # not a valid move, drop it
        find_shortest_path_len_impl(memory_map, max_val, queue, visited)
      else
        visited = Map.put(visited, {x,y}, moves)
        queue = [
          {x + 0, y + 1, moves + 1},
          {x + 0, y - 1, moves + 1},
          {x + 1, y + 0, moves + 1},
          {x - 1, y + 0, moves + 1},
        ]
        #|> Enum.filter(fn {x, y, moves} ->
        #   (x <= max_val and x >= 0
        #          or y <= max_val and y >= 0)
        #         and (!Map.has_key?(visited, {x,y}) or moves < Map.get(visited, {x,y}))
        #         and (!Map.has_key?(memory_map, {x, y}) or Map.get(memory_map, {x, y}) != ?#)
        #end)
        |> Enum.reduce(queue, fn element, acc ->
          :queue.in(element, acc)
        end)
        find_shortest_path_len_impl(memory_map, max_val, queue, visited)
      end
    end
  end

  def part2(_input) do
    IO.puts("expected")
    IO.puts("6,1")
    IO.puts("actual")
    solve_part2(
      Path.join([File.cwd!(), "inputs", "day18_sample.txt"])
      |> File.read!(),
      6
    )
    |> IO.inspect()

    IO.puts("real")
    solve_part2(
      Path.join([File.cwd!(), "inputs", "day18.txt"])
      |> File.read!(),
      70
    )
    |> IO.inspect()

    0
  end

  def solve_part2(input, max_val) do
    posns = input
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, ",") end)
    |> Enum.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)

    lastGoodPoint = find_first_blocker(posns, max_val, 0, length(posns)-1, nil)
    Enum.at(posns, lastGoodPoint + 1)
  end

  def find_first_blocker(posns, max_val, startRange, endRange, lastGoodPoint) do
    if (startRange > endRange) do
      lastGoodPoint
    else
      # 0
      # ^
      # 0 1
      # ^
      # 0 1 2
      #   ^
      # 0 1 2 3
      #   ^
      # 0 1 2 3 4
      #     ^
      midPoint = div(startRange + endRange, 2)
      memory_map = to_map(Enum.slice(posns, 0, midPoint+1))
      path_len = find_shortest_path_len(memory_map, max_val, {0,0}, {max_val, max_val})
      if path_len == nil do
        find_first_blocker(posns, max_val, startRange, midPoint-1, lastGoodPoint)
      else
        lastGoodPoint = midPoint
        find_first_blocker(posns, max_val, midPoint+1, endRange, lastGoodPoint)
      end
    end
  end

  def to_map(posns) do
    posns
    |> Enum.reduce(%{}, fn {x, y}, acc ->
      Map.put(acc, {x, y}, ?#)
    end)
  end

end
