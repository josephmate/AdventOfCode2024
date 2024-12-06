defmodule AdventOfCode.Day06 do
  defstruct  day: "06"

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
    lab_map = input
    |> String.split("\n")
    |> Enum.map(&String.to_charlist()/1)
    |> Enum.map(&List.to_tuple()/1)
    |> List.to_tuple()
    |> IO.inspect()

    num_rows = tuple_size(lab_map)
    num_cols = tuple_size(elem(lab_map, 0))

    [guard_posn] =
      for i <- 0..num_rows-1 do
        for j <- 0..num_rows-1, index(lab_map, i, j) == ?^ do
          {i,j}
        end
      end
      |> List.flatten()
      |> IO.inspect()

    solve_p1(lab_map, num_rows, num_cols, guard_posn)
  end

  def index(arr, row, col) do
    elem(elem(arr, row), col)
  end

  defp solve_p1(lab_map, num_rows, num_cols, guard_posn) do
    visited = MapSet.new()
    visited = solve_p1_impl(lab_map, num_rows, num_cols, guard_posn, visited, :up)

    IO.puts(
      for r <- 0..num_rows-1 do
        for c <- 0..num_cols-1 do
          if MapSet.member?(visited, {r,c}) do
            "X"
          else
            <<index(lab_map, r, c)::utf8>>
          end
        end
        |> Enum.join("")
      end
      |> Enum.join("\n")
    )

    MapSet.size(visited)
  end

  defp solve_p1_impl(lab_map, num_rows, num_cols, guard_posn, visited, direction) do
    vector = case direction do
      :up -> {-1, 0}
      :right -> {0, 1}
      :down -> {1, 0}
      :left -> {0, -1}
    end
    {is_done?, next_posn, new_visited} = travel(lab_map, num_rows, num_cols, vector, guard_posn)
    visited = Enum.reduce(new_visited, visited, fn posn, acc ->
      MapSet.put(acc, posn)
    end)

    if is_done? do
      visited
    else
      next_direction = case direction do
        :up -> :right
        :right -> :down
        :down -> :left
        :left -> :up
      end
      solve_p1_impl(lab_map, num_rows, num_cols, next_posn, visited, next_direction)
    end

  end

  defp travel(lab_map,num_rows, num_cols,  vector, posn) do
    travel_impl(lab_map,num_rows, num_cols,  vector, posn, posn, [])
  end
  defp travel_impl(lab_map,num_rows, num_cols,  {vr, vc}, prev_posn, {r,c}, acc) do
    if r < 0
        or c < 0
        or r >= num_rows
        or c >= num_cols do
      {true, prev_posn, [prev_posn|acc]}
    else
      obstacle = index(lab_map, r, c)
      if obstacle == ?# do
        {false, prev_posn, [prev_posn| acc]}
      else
        travel_impl(lab_map, num_rows, num_cols, {vr, vc}, {r,c}, {r+vr,c+vc}, [prev_posn|acc])
      end
    end

  end

  def part2(input) do
    input
    |> String.split("\n")

    0
  end

end
