defmodule AdventOfCode.Day10 do
  defstruct  day: "10"

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
    trail_map = input
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(fn row -> row
                          |> Enum.map(fn c -> c - ?0 end)
    end)
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
    |> IO.inspect()

    trail_map
    |> find_trail_heads()
    |> Enum.map(&score_trail_head(&1, trail_map))
    |> IO.inspect()
    |> Enum.sum()

  end

  def score_trail_head(trail_head, trail_map) do
    score_trail_head_impl(
      trail_head,
      trail_map,
      tuple_size(trail_map),
      tuple_size(elem(trail_map,0)),
      MapSet.new()
    )
    |> MapSet.new()
    |> MapSet.size()
  end

  def score_trail_head_impl({r, c}, trail_map, num_rows, num_cols, visited) do
    if MapSet.member?(visited, {r, c}) do
      []
    else
      visited = MapSet.put(visited, {r,c})
      height = index(trail_map, r, c)
      if height == 9 do
        [{r, c}]
      else
        [
          {r + 0, c + 1},
          {r + 0, c - 1},
          {r + 1, c + 0},
          {r - 1, c + 0},
        ]
        |> Enum.filter(fn {new_r, new_c} ->
              new_r >= 0 and new_r < num_rows
          and new_c >= 0 and new_c < num_cols
        end)
        |> Enum.filter(fn {new_r, new_c} ->
          new_height = index(trail_map, new_r, new_c)
          height == new_height - 1
        end)
        |> Enum.map(fn {new_r, new_c} ->
          score_trail_head_impl({new_r, new_c}, trail_map, num_rows, num_cols, visited)
        end)
        |> Enum.concat()
      end
    end
  end

  def find_trail_heads(trail_map) do
    num_rows = tuple_size(trail_map)
    num_cols = tuple_size(elem(trail_map, 0))
    for r <- 0..num_rows-1 do
      for c <- 0..num_cols-1 do
        obj = index(trail_map, r, c)
        if obj == 0 do
          {r,c}
        else
          {-1,-1}
        end
      end
      |> Enum.filter(fn {a,_} -> a >= 0 end)
    end
    |> List.flatten()
  end


  def index(arr, row, col) do
    elem(elem(arr, row), col)
  end

  def part2(input) do
    trail_map = input
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(fn row -> row
                          |> Enum.map(fn c -> c - ?0 end)
    end)
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
    |> IO.inspect()

    trail_map
    |> find_trail_heads()
    |> Enum.map(&score_trail_head_p2(&1, trail_map))
    |> IO.inspect()
    |> Enum.sum()
  end

  def score_trail_head_p2(trail_head, trail_map) do
    score_trail_head_p2_impl(
      trail_head,
      trail_map,
      tuple_size(trail_map),
      tuple_size(elem(trail_map,0)),
      MapSet.new()
    )
  end

  def score_trail_head_p2_impl({r, c}, trail_map, num_rows, num_cols, visited) do
    if MapSet.member?(visited, {r, c}) do
      0
    else
      visited = MapSet.put(visited, {r,c})
      height = index(trail_map, r, c)
      if height == 9 do
        1
      else
        [
          {r + 0, c + 1},
          {r + 0, c - 1},
          {r + 1, c + 0},
          {r - 1, c + 0},
        ]
        |> Enum.filter(fn {new_r, new_c} ->
              new_r >= 0 and new_r < num_rows
          and new_c >= 0 and new_c < num_cols
        end)
        |> Enum.filter(fn {new_r, new_c} ->
          new_height = index(trail_map, new_r, new_c)
          height == new_height - 1
        end)
        |> Enum.map(fn {new_r, new_c} ->
          score_trail_head_p2_impl({new_r, new_c}, trail_map, num_rows, num_cols, visited)
        end)
        |> Enum.sum()
      end
    end
  end
end
