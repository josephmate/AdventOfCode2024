defmodule AdventOfCode.Day19 do
  defstruct  day: "19"

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
    [components, targets] = input
    |> String.split("\n\n")

    components = components
    |> String.split(", ")
    |> Enum.join("|")
    {:ok, components} = "^(" <> components <> ")+$"
    |> IO.inspect()
    |> Regex.compile()

    targets
    |> String.split("\n")
    |> Enum.filter(fn target ->
      Regex.match?(components, target)
    end)
    |> Enum.count()
  end

  def part2(input) do
    [components, targets] = input
    |> String.split("\n\n")

    components = components
    |> String.split(", ")

    targets
    |> String.split("\n")
    |> Enum.map(fn target -> count_ways(components, target) end)
    |> Enum.sum()
  end

  defp count_ways(components, target) do
    count_ways_impl(components, target, 0)
    |> IO.inspect()
  end

  defp count_ways_impl(components, target, idx) do
    if idx == String.length(target) do
      1
    else
      components
      |> Enum.filter(fn component ->
        target
        |> String.slice(idx..String.length(target)-1)
        |> String.starts_with?(component)
      end)
      |> Enum.map(fn component ->
        count_ways_impl(components, target, idx + String.length(component))
      end)
      |> Enum.sum()
    end
  end

end
