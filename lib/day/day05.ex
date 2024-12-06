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
    |> MapSet.new()


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
      |> Enum.all?()
    end
    |> Enum.all?()
  end

  defp get_middle(pages) do
    n = tuple_size(pages)
    elem(pages,div(n,2))
  end

  def part2(input) do
    [page_order_desc, page_production_desc] = input
    |> String.split("\n\n")


    page_order_before_to_after = page_order_desc
    |> String.split("\n")
    |> Stream.map(&String.split(&1, "|"))
    |> Stream.map(fn [a,b] -> {String.to_integer(a), String.to_integer(b)} end)
    |> Enum.to_list()
    #|> Enum.reduce(%{}, fn {key, value}, acc ->
    #    Map.update(acc, key, [value], fn existing_values -> [value | existing_values] end)
    #end)
    |> MapSet.new()

    page_production_desc
    |> String.split("\n")
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(fn row -> Enum.map(row, &String.to_integer()/1) end)
    |> Stream.map(&List.to_tuple(&1))
    |> Stream.filter(fn pages -> !(are_pages_in_right_order?(pages, page_order_before_to_after)) end)
    |> Stream.map(&reorder(&1, page_order_before_to_after))
    |> Stream.map(&get_middle(&1))
    |> Enum.sum()

  end

  defp _total_order(page_order_before_to_after) do
    all_nums = page_order_before_to_after
    |> Stream.map(&Tuple.to_list/1)
    |> Enum.to_list()
    |> List.flatten()
    |> MapSet.new()
    |> IO.inspect()

    all_befores = page_order_before_to_after
    |> Stream.map(fn {before, _after} -> before end)
    |> Enum.to_list()
    |> MapSet.new()
    |> IO.inspect()

    all_afters = page_order_before_to_after
    |> Stream.map(fn {_before, aafter} -> aafter end)
    |> Enum.to_list()
    |> MapSet.new()
    |> IO.inspect()

  end

  defp reorder(pages, page_order_before_to_after) do
    pages_set = MapSet.new(Tuple.to_list(pages))


    IO.puts("reduced_page_order")
    reduced_page_order = MapSet.to_list(page_order_before_to_after)
    |> Enum.filter(fn {a,b} -> MapSet.member?(pages_set, a) and MapSet.member?(pages_set, b) end)
    |> MapSet.new()
    |> IO.inspect()

    empty_map = pages_set
    |> Enum.reduce(%{}, fn val, acc ->
        Map.update(acc, val, 0, fn _ -> 0 end)
    end)

    page_to_number_bigger_than = reduced_page_order
    |> Enum.reduce(empty_map, fn {_before, aafter}, acc ->
        Map.update(acc, aafter, 1, fn existing_value -> existing_value + 1 end)
    end)
    |> IO.inspect()

    index_to_page = Enum.reduce(page_to_number_bigger_than, %{}, fn {key, value}, acc ->
      Map.put(acc, value, key)
    end)
    |> IO.inspect()

    0..(tuple_size(pages)-1)
    |> Enum.reduce([], fn idx, acc ->
      [Map.get(index_to_page, idx) | acc]
    end)
    |> Enum.reverse()
    |> List.to_tuple()
    |> IO.inspect()
  end

end
