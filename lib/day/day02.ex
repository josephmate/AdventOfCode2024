defmodule AdventOfCode.Day02 do
  defstruct  day: "02"

  defimpl AdventOfCode.DaySolution do
    def sample_part1_files(value) do
      %{
        "day#{value.day}_sample.txt" => "day#{value.day}_sample_part1_result.txt"
      }
    end

    @fallback_to_any true
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
    |> Stream.map(&String.split()/1)
    |> Stream.map(fn row -> Enum.map(row, &String.to_integer()/1) end)
    |> Stream.filter(&is_safe?/1)
    |> Enum.count()
  end

  def part2(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.split()/1)
    |> Stream.map(fn row -> Enum.map(row, &String.to_integer()/1) end)
    |> Stream.filter(&is_safe_with_dampener?/1)
    |> Enum.count()
  end

  defp is_safe?(row) do
    deltas = Enum.zip(row, tl(row))
    |> Enum.map(fn {a,b} -> a - b end)

    are_deltas_safe?(deltas)
  end

  defp are_deltas_safe?(deltas) do
    is_increasing = hd(deltas) >= 1
    Enum.map(deltas, &(
      &1 >= -3
      and &1 <= 3
      and &1 != 0
      and (
        (is_increasing and &1 > 0)
        or (!is_increasing and &1 < 0)
        )
      ))
    |> Enum.all?(&(&1))
  end

  defp is_safe_with_dampener?(row) do
    IO.inspect(row)
    0..length(row)
    |> Stream.map(fn idx -> List.delete_at(row, idx) end)
    |> Stream.each(&IO.inspect()/1)
    |> Stream.filter(&is_safe?/1)
    |> Enum.count()
    >= 1
  end
end
