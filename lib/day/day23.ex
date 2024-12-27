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

  def part2(input) do
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

    conn = adjacency_set
    |> Enum.map(fn {a, b} ->
      if a <= b do
        {a, b}
      else
        {b, a}
      end
    end)
    |> MapSet.new()
    |> IO.inspect()

    3..13
    |> Enum.reduce(conn, fn _, acc ->
      expand_connecteds(adjacency_set, adjacency_map, acc)
      |> IO.inspect()
    end)

    0
  end

  def expand_connecteds(adjacency_set, adjacency_map, connecteds) do
    connecteds
    |> Enum.map(&expand_connected(&1, adjacency_set, adjacency_map))
    |> List.flatten()
    |> MapSet.new()
  end

  def expand_connected(connected, adjacency_set, adjacency_map) do
    connected_list = Tuple.to_list(connected)

    first = elem(connected, 0)

    already_in = connected
    |> Tuple.to_list()
    |> MapSet.new()

    Map.get(adjacency_map, first)
    # already got them
    |> Enum.filter(fn potential -> !MapSet.member?(already_in, potential) end)
    |> Enum.filter(fn potential -> all_connected(potential, connected, adjacency_set) end)
    |> Enum.map(fn potential -> [potential | connected_list] end)
    |> Enum.map(fn potential -> Enum.sort(potential) end)
    |> Enum.map(fn potential -> List.to_tuple(potential) end)
    |> MapSet.new()
    |> MapSet.to_list()
  end

  def all_connected(potential, already_connecteds, adjacency_set) do
    already_connecteds
    |> Tuple.to_list()
    |> Enum.map(fn already_connected -> MapSet.member?(adjacency_set, {potential, already_connected}) end)
    |> Enum.all?()
  end

end
