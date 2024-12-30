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

  def part2(_input) do
    0
  end

end
