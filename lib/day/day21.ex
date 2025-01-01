defmodule AdventOfCode.Day21 do
  defstruct  day: "21"

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
    IO.puts("029A: <vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A")
    IO.puts("980A: <v<A>>^AAAvA^A<vA<AA>>^AvAA<^A>A<v<A>A>^AAAvA<^A>A<vA>^A<A>A")
    IO.puts("179A: <v<A>>^A<vA<A>>^AAvAA<^A>A<v<A>>^AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A")
    IO.puts("456A: <v<A>>^AA<vA<A>>^AAvAA<^A>A<vA>^A<A>A<vA>^A<A>A<v<A>A>^AAvA<^A>A")
    IO.puts("379A: <v<A>>^AvA^A<vA<AA>>^AAvA<^A>AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A")

    input
    |> String.split("\n")
    |> Enum.map(&{ extract_num(&1), solve_p1(&1)/1})
    |> Enum.map(fn {num, len} -> num*len end)
    |> Enum.sum()
  end

  defp solve_p1(num_string) do
    generate_paths("A" <> num_string)
    |> IO.inspect()

    "<<<"
  end

  # +---+---+---+
  # | 7 | 8 | 9 |
  # +---+---+---+
  # | 4 | 5 | 6 |
  # +---+---+---+
  # | 1 | 2 | 3 |
  # +---+---+---+
  #     | 0 | A |
  #     +---+---+
  def generate_numpad_paths(target_digits) do
    graph = [
      {?A, ?0},
      {?A, ?3},
      {?0, ?2},
      {?0, ?A},
      {?1, ?4},
      {?1, ?2},
      {?2, ?1},
      {?2, ?5},
      {?2, ?3},
      {?2, ?0},
      {?3, ?2},
      {?3, ?6},
      {?3, ?A},
      {?4, ?7},
      {?4, ?5},
      {?4, ?1},
      {?5, ?4},
      {?5, ?8},
      {?5, ?6},
      {?5, ?2},
      {?6, ?5},
      {?6, ?9},
      {?6, ?3},
      {?7, ?8},
      {?7, ?4},
      {?8, ?7},
      {?8, ?9},
      {?8, ?5},
      {?9, ?8},
      {?9, ?6},
    ]
    |> Enum.group_by(fn {a, _b} -> a end)


  end
  # +---+---+---+
  # | 7 | 8 | 9 |
  # +---+---+---+
  # | 4 | 5 | 6 |
  # +---+---+---+
  # | 1 | 2 | 3 |
  # +---+---+---+
  #     | 0 | A |
  #     +---+---+


  defp extract_num(numStr) do
    numStr
    |> String.slice(0..2)
    |> String.to_integer()
  end

  def part2(_input) do
    0
  end

end
