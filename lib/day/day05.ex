defmodule AdventOfCode.Day05 do
  defstruct  day: "05"

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
    [page_order_desc, page_production_desc] = input
    |> String.split("\n\n")


    page_order_before_to_after = page_order_desc
    |> String.split("\n")
    |> Stream.map(&String.split(&1, "|"))
    |> Stream.map(fn [a,b] -> {String.to_integer(a), String.to_integer(b)} end)
    |> Enum.to_list()
    |> IO.inspect()
    #|> Enum.reduce(%{}, fn {key, value}, acc ->
    #    Map.update(acc, key, [value], fn existing_values -> [value | existing_values] end)
    #end)
    #|> IO.inspect()
    |> MapSet.new()
    |> IO.inspect()


    page_production_desc
    |> String.split("\n")
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(fn row -> Enum.map(row, &String.to_integer()/1) end)
    |> Stream.map(&List.to_tuple(&1))
    |> Stream.filter(&are_pages_in_right_order?(&1, page_order_before_to_after))
    |> Stream.map(&get_middle(&1))
    |> Enum.sum()
  end

  defp are_pages_in_right_order?(pages, page_order_before_to_after) do
    for i <- 1..(tuple_size(pages)-1) do
      for j <- 0..(i-1) do
        !MapSet.member?(page_order_before_to_after, {elem(pages,i), elem(pages,j)})
      end
      |> IO.inspect()
      |> Enum.all?()
    end
    |> Enum.all?()
  end

  defp get_middle(pages) do
    n = tuple_size(pages)
    elem(pages,div(n,2))
  end

  def part2(input) do
    input
    |> String.split("\n")

    0
  end

end
