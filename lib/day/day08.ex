defmodule AdventOfCode.Day08 do
  defstruct  day: "08"

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
    map = parse_input(input)

    num_rows = tuple_size(map)
    num_cols = tuple_size(elem(map,0))
    for r <- 0..num_rows-1 do
      for c <- 0..num_cols-1 do
        obj = index(map, r,c)
        if (obj >= ?0 and obj <= ?9)
        or (obj >= ?a and obj <= ?z)
        or (obj >= ?A and obj <= ?Z) do
          {obj, r, c}
        else
          {0, r, c}
        end
      end
      |> Enum.filter(fn {obj, _, _} -> obj != 0 end)
    end
    |> List.flatten()
    |> Enum.reduce(%{}, fn {obj, r, c}, acc ->
      Map.update(acc, obj, [{r,c}], fn existing_values ->
        [{r,c} | existing_values]
      end)
    end)
    |> Enum.map(fn v -> find_antinodes(v, false, &create_antinodes/1) end)
    |> List.flatten()
    |> Enum.filter(fn {r,c} ->
      r >= 0 and r < num_rows
      and c >= 0 and c < num_rows
    end)
    |> MapSet.new()
    |> MapSet.size()
  end

  def find_antinodes({_k,v}, add_pairs?, create_antinodes_fcn) do
    v = List.to_tuple(v)
    num_vals = tuple_size(v)

    pairs = for i <- 0..num_vals-1 do
      for j <- 0..num_vals-1, i<j do
        {elem(v, i), elem(v,j)}
      end
    end
    |> List.flatten()

    antinodes = pairs
    |> Enum.map(create_antinodes_fcn)
    |> List.flatten()

    if add_pairs? do
      Tuple.to_list(v) ++ antinodes
    else
      antinodes
    end
  end

  def create_antinodes({{r1,c1}, {r2,c2}}) do
    rv = r2-r1
    cv = c2-c1
    [
      {r2+rv, c2+cv},
      {r1-rv, c1-cv}
    ]
  end

  def index(arr, row, col) do
    elem(elem(arr, row), col)
  end

  defp parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_charlist()/1)
    |> Enum.map(&List.to_tuple()/1)
    |> List.to_tuple()
  end

  def part2(input) do
    map = parse_input(input)

    num_rows = tuple_size(map)
    num_cols = tuple_size(elem(map,0))
    anti_nodes = for r <- 0..num_rows-1 do
      for c <- 0..num_cols-1 do
        obj = index(map, r,c)
        if (obj >= ?0 and obj <= ?9)
        or (obj >= ?a and obj <= ?z)
        or (obj >= ?A and obj <= ?Z) do
          {obj, r, c}
        else
          {0, r, c}
        end
      end
      |> Enum.filter(fn {obj, _, _} -> obj != 0 end)
    end
    |> List.flatten()
    |> Enum.reduce(%{}, fn {obj, r, c}, acc ->
      Map.update(acc, obj, [{r,c}], fn existing_values ->
        [{r,c} | existing_values]
      end)
    end)
    |> Enum.filter(fn {_k,v} -> length(v) > 1 end)
    |> Enum.map(fn v -> find_antinodes(v, true, &create_antinodes_p2(&1, num_rows, num_cols)) end)
    |> List.flatten()
    |> Enum.filter(fn {r,c} ->
      r >= 0 and r < num_rows
      and c >= 0 and c < num_rows
    end)
    |> MapSet.new()

    for r <- 0..num_rows-1 do
      for c <- 0..num_cols-1 do
        if MapSet.member?(anti_nodes, {r,c}) do
          IO.write("#")
        else
          obj = index(map,r,c)
          IO.write(<<obj::utf8>>)
        end
      end
      IO.write("\n")
    end

    anti_nodes
    |> MapSet.size()
  end

  def create_antinodes_p2({{r1,c1}, {r2,c2}}, num_rows, num_cols) do
    rv = r2-r1
    cv = c2-c1
    [
      create_antinodes_p2_impl({r2,c2}, {rv, cv}, num_rows, num_cols, []),
      create_antinodes_p2_impl({r1,c1}, {-rv, -cv}, num_rows, num_cols, []),
    ]
    |> List.flatten()
  end

  def create_antinodes_p2_impl({r,c}, {rv, cv}, num_rows, num_cols, acc) do
    new_r = r+rv
    new_c = c+cv
    if new_r >= 0 and new_r < num_rows
      and new_r >= 0 and new_r < num_cols do
      create_antinodes_p2_impl({new_r,new_c}, {rv,cv}, num_rows, num_cols, [{new_r, new_c}|acc])
    else
      acc
    end
  end
end
