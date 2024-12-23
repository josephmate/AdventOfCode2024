defmodule AdventOfCode.Day23 do
  defstruct  day: "23"

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

  def part1(input) do
    adjacency_set = input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.map(fn [a, b] ->
      [
        {a, b},
        {b, a}
      ]
    end)
    |> List.flatten()
    |> Enum.reduce(MapSet.new(), fn ele, acc ->
      MapSet.put(acc, ele)
    end)

    adjacency_map = adjacency_set
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.update(acc, k, [v], fn existing_values -> [v | existing_values] end)
    end)

    adjacency_map
    |> Enum.map(fn {k,v} ->
      {k, length(v)}
    end)
    |> IO.inspect()
    |> Enum.map(fn {_,v} -> v end)
    |> Enum.max()
    |> IO.inspect()
    # 13 is max number of connected computers, 13^2 not to bad

    adjacency_map
    |> Enum.map(fn {start, connecteds} -> expand_3_conn(adjacency_set, start, connecteds) end)
    |> List.flatten()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.sort/1)
    |> Enum.reduce(MapSet.new(), fn [a,b,c], acc ->
      MapSet.put(acc, {a,b,c})
    end)
    |> Enum.filter(fn {a,b,c} ->
      String.starts_with?(a, "t")
      or String.starts_with?(b, "t")
      or String.starts_with?(c, "t")
    end)
    |> length()
  end

  def expand_3_conn(adjacency_set, start, connecteds) do
    for a <- connecteds, b <- connecteds, a < b do
      {a, b}
    end
    |> Enum.filter(fn {a,b} -> MapSet.member?(adjacency_set, {a,b}) end)
    |> Enum.map(fn {a,b} -> {a, b, start} end)
  end

  def part2(_input) do
    0
  end

end
