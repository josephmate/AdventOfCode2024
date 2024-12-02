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
    |> Stream.each(&IO.inspect/1)
    |> Stream.map(fn row -> Enum.map(row, &String.to_integer()/1) end)
    |> Stream.each(&IO.inspect/1)
    |> Stream.map(
      fn row ->
        Enum.zip(row, tl(row))
        |> Enum.map(fn {a,b} -> a - b end)
      end)
    |> Stream.each(&IO.inspect/1)
    |> Stream.filter(
      fn row ->
        is_increasing = hd(row) >= 1
        Enum.map(row, &(
          &1 >= -3
          and &1 <= 3
          and &1 != 0
          and (
            (is_increasing and &1 > 0)
            or (!is_increasing and &1 < 0)
            )
          ))
        |> IO.inspect()
        |> Enum.all?(&(&1))
      end
    )
    |> Enum.count()
  end

  def part2(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.split()/1)
    |> Stream.map(fn row -> Enum.map(row, &String.to_integer()/1) end)
    |> Stream.map(
      fn row ->
        Enum.zip(row, tl(row))
        |> Enum.map(fn {a,b} -> a - b end)
      end)
    |> Stream.filter(
      fn row ->
        is_increasing = hd(row) >= 1
        1 >= (row
        |> Enum.map(fn val ->
          (is_increasing and (val < 1 or val > 3))
          or (!is_increasing and (val > -1 or val < -3))
          end)
        |> IO.inspect()
        |> Enum.filter(&(&1))
        |> Enum.count())
      end
    )
    |> Enum.count()
  end

end
