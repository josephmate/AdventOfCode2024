defmodule AdventOfCode.Day19 do
  defstruct  day: "19"

  defimpl AdventOfCode.DaySolution do
    def sample_part1_files(value) do
      %{
        "day#{value.day}_sample.txt" => "day#{value.day}_sample_part1_result.txt",
      }
    end

    def sample_part2_files(value) do
      %{
        "day#{value.day}_sample.txt" => "day#{value.day}_sample_part2_result.txt",
        "day#{value.day}_sample_02.txt" => "day#{value.day}_sample_02_part2_result.txt",
        "day#{value.day}_sample_03.txt" => "day#{value.day}_sample_03_part2_result.txt"
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

  # 11
  # r, rr
  #
  # 1 r
  #   r
  # 2 rr
  #   r r
  #   rr
  # 3 rrr
  #   r
  #     r
  #       r
  #     rr
  #   rr
  #     r
  # 5 rrrr
  #   r 1
  #     r 2
  #       r 3
  #         r 4 *
  #       rr 4 *
  #     rr 3
  #       r 4 *
  #   rr 2
  #       r 3
  #         r 4 *
  #       rr 4 *
  # 8 rrrrr
  #   r 1
  #     r 2
  #       r 3
  #         r 4
  #           r 5 *
  #         rr 5 *
  #       rr 4
  #         r 5 *
  #     rr 3
  #       r 4
  #         r 5 *
  #       rr 5 *
  #   rr 2
  #     r 3
  #       r 4
  #         r 5 *
  #       rr 5 *
  #     rr 4
  #       r 5 *
  #
  # a, b, ab, ba
  # 1 a
  # 2 ab
  #   a 1
  #     b 2 *
  #   ab 2 *
  # 3 aba
  #   a 1
  #     b 2
  #       a 3 *
  #     ba 3 *
  #   ab 2
  #     a 3 *
  # 5 abab
  #   a 1
  #     b 2
  #       a 3
  #         b 4 *
  #       ab 4 *
  #     ba 3
  #       b 4 *
  #   ab 2
  #     a 3
  #       b 4 *
  #     ab 4 *
  def part2(input) do
    [components, targets] = input
    |> String.split("\n\n")

    components = components
    |> String.split(", ")

    targets
    |> String.split("\n")
    |> Enum.map(fn target -> count_ways(components, target) end)
    |> Enum.sum()
    # got 919219286602166 but was too high
    # more debugging needed
  end

  defp count_ways(components, target) do
    count_ways_impl(components, target, 0, %{})
    |> elem(0)
    |> IO.inspect()
  end

  defp count_ways_impl(components, target, idx, memo) do
    if idx == String.length(target) do
      {1, Map.put(memo, idx, 1)}
    else
      if Map.has_key?(memo, idx) do
        {Map.get(memo, idx), memo}
      else
        {new_sum, new_memo} = components
        |> Enum.filter(fn component ->
          target
          |> String.slice(idx..String.length(target)-1)
          |> String.starts_with?(component)
        end)
        |> Enum.reduce({0, memo}, fn component, {sum_acc, memo_acc} ->
          {partial_sum, memo_acc} = count_ways_impl(components, target, idx + String.length(component), memo_acc)
          {sum_acc + partial_sum, memo_acc}
        end)

        new_memo = Map.put(new_memo, idx, new_sum)
        {new_sum, new_memo}
      end
    end
  end

end
