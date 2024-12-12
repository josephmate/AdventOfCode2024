defmodule AdventOfCode.Day12 do
  defstruct  day: "12"

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
    input
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
    |> IO.inspect()
    |> partition_into_regions()
    |> IO.inspect()
    |> Enum.map(fn region -> {perim(region),area(region)} end)
    |> IO.inspect()
    |> Enum.map(fn {perim,area} -> perim*area end)
    |> IO.inspect()
    |> Enum.sum()
  end

  def perim(region) do
    region
    |> Enum.map(fn {r,c} -> [
      {r,c+1},
      {r,c-1},
      {r+1,c},
      {r-1,c}
      ]
    end)
    |> List.flatten()
    |> Enum.filter(fn {r,c} -> !MapSet.member?(region, {r,c}) end)
    |> Enum.count()
  end

  def area(region) do
    MapSet.size(region)
  end

  def partition_into_regions(farm_map) do
    num_rows = tuple_size(farm_map)
    num_cols = tuple_size(elem(farm_map, 0))

    partition_into_regions_impl(
      farm_map,
      num_rows,
      num_cols,
      MapSet.new(),
      0,
      0,
      []
    )
  end

  def partition_into_regions_impl(farm_map,num_rows,num_cols,visited,r,c, so_far) do
    if MapSet.member?(visited, {r,c}) do
      if c+1 < num_cols do
        partition_into_regions_impl(farm_map,num_rows,num_cols,visited,r,c+1, so_far)
      else
        if r+1 < num_rows do
          partition_into_regions_impl(farm_map,num_rows,num_cols,visited,r+1,0, so_far)
        else
          so_far
        end
      end
    else
      plant = index(farm_map, r, c)
      {visited, region} = expand_region(farm_map,num_rows,num_cols,plant, visited,r,c)
      partition_into_regions_impl(farm_map, num_rows, num_cols, visited, r, c, [region | so_far])
    end
  end

  def expand_region(farm_map,num_rows,num_cols,plant, visited,r,c) do
    expand_region_impl(farm_map,num_rows,num_cols,plant, visited, [{r,c}], MapSet.new())
  end

  def expand_region_impl(farm_map,num_rows,num_cols,plant, visited, stack, region) do
    case stack do
      [] -> {visited, region}
      [{r,c} | stack] ->
        if r < 0
          or r >= num_rows
          or c < 0
          or c >= num_cols do
          expand_region_impl(farm_map,num_rows,num_cols,plant, visited, stack, region)
        else
          if MapSet.member?(visited, {r,c}) do
            expand_region_impl(farm_map,num_rows,num_cols,plant, visited, stack, region)
          else
            new_plant = index(farm_map, r, c)
            if new_plant != plant do
              expand_region_impl(farm_map,num_rows,num_cols,plant, visited, stack, region)
            else
              region = MapSet.put(region, {r,c})
              visited = MapSet.put(visited, {r,c})
              stack = [
                {r, c+1},
                {r, c-1},
                {r+1, c},
                {r-1, c}
                | stack
              ]
              expand_region_impl(farm_map,num_rows,num_cols,plant, visited, stack, region)
            end
          end
        end
    end
  end

  def index(arr, row, col) do
    elem(elem(arr, row), col)
  end

  def part2(_input) do
    0
  end
end
