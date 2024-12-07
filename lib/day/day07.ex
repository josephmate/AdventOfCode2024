defmodule AdventOfCode.Day07 do
  defstruct  day: "07"

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
    problem = parse_input(input)

    problem
    |> Enum.filter(&is_equal?/1)
    |> Enum.map(fn {expected, _} -> expected end)
    |> Enum.sum()
  end

  defp is_equal?({expected, values}) do
    len = tuple_size(values)
    is_equal_impl?(expected, values, len, elem(values, 0), 1)
  end

  defp is_equal_impl?(expected, values, len, acc, posn) do
    if posn == len do
      expected == acc
    else
      curr = elem(values, posn)
      is_equal_impl?(expected, values, len, acc*curr, posn+1)
      or is_equal_impl?(expected, values, len, acc+curr, posn+1)
    end
  end



  defp to_int_tuple(values) do
    values
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.split(&1, ": "))
    |> Stream.map(fn [test, values] -> {String.to_integer(test), to_int_tuple(values)} end)
    |> Enum.to_list()
  end


  def part2(input) do
    input
    |> String.split("\n")
    0
  end

end
