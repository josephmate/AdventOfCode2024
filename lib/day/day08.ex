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
    |> IO.inspect()

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
    |> IO.inspect()
    |> Enum.reduce(%{}, fn {obj, r, c}, acc ->
      Map.update(acc, obj, [{r,c}], fn existing_values ->
        [{r,c} | existing_values]
      end)
    end)
    |> IO.inspect()
    |> Enum.map(&find_antinodes/1)
    |> List.flatten()
    |> IO.inspect()
    |> Enum.filter(fn {r,c} ->
      r >= 0 and r < num_rows
      and c >= 0 and c < num_rows
    end)
    |> IO.inspect()
    |> MapSet.new()
    |> IO.inspect()
    |> MapSet.size()
  end

  def find_antinodes({k,v}) do
    v = List.to_tuple(v)
    num_vals = tuple_size(v)

    for i <- 0..num_vals-1 do
      for j <- 0..num_vals-1, i<j do
        {elem(v, i), elem(v,j)}
      end
    end
    |> List.flatten()
    |> IO.inspect()
    |> Enum.map(&create_antinodes/1)
    |> IO.inspect()
    |> List.flatten()
    |> IO.inspect()
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
    input
    |> String.split("\n")

    0
  end

end
