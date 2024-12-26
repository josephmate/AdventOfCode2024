defmodule AdventOfCode.Day25 do
  defstruct  day: "25"

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
    input = input
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.map(&parseSchematic/1)

    keys = input
    |> Enum.filter(fn {type,_} -> type == :key end)
    |> Enum.map(fn {_, counts} -> counts end)

    locks = input
    |> Enum.filter(fn {type,_} -> type == :lock end)
    |> Enum.map(fn {_, counts} -> counts end)

    key_fits_index = keys
    |> Enum.map(&generate_all_fit_locks/1)
    |> List.flatten()
    |> Enum.frequencies()

    locks
    |> Enum.map(fn lock -> Map.get(key_fits_index, lock, 0) end)
    |> Enum.sum()
  end

  def generate_all_fit_locks({k1, k2, k3, k4, k5}) do
    for l1 <- 0..(5-k1),
        l2 <- 0..(5-k2),
        l3 <- 0..(5-k3),
        l4 <- 0..(5-k4),
        l5 <- 0..(5-k5)
        do
      {l1, l2, l3, l4, l5}
    end

  end

  def parseSchematic(input) do
    key_sizes = 0..(5-1)
    |> Enum.map(fn col ->
      input
      |> Enum.count(fn row ->
        String.at(row, col) == "#"
      end)
    end)
    |> Enum.map(&(&1 - 1))
    |> List.to_tuple()

    schematic_type = if List.first(input) == "....." do
      :key
    else
      :lock
    end

    {schematic_type,key_sizes}
  end

  def part2(_input) do
    0
  end

end
