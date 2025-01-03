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
    generate_numpad_paths("A" <> num_string)
    |> IO.inspect()

    0
  end

  def generate_numpad_paths(target_digits) do
    target_digits = String.to_charlist(target_digits)
    # 01234
    # A029A
    [
      generate_numpad_paths_between_points(Enum.at(target_digits, 0), Enum.at(target_digits, 1)),
      generate_numpad_paths_between_points(Enum.at(target_digits, 1), Enum.at(target_digits, 2)),
      generate_numpad_paths_between_points(Enum.at(target_digits, 2), Enum.at(target_digits, 3)),
      generate_numpad_paths_between_points(Enum.at(target_digits, 3), Enum.at(target_digits, 4)),
    ]
  end

  defp generate_numpad_paths_between_points(src, dst) do
    # +---+---+---+
    # | 7 | 8 | 9 |
    # +---+---+---+
    # | 4 | 5 | 6 |
    # +---+---+---+
    # | 1 | 2 | 3 |
    # +---+---+---+
    #     | 0 | A |
    #     +---+---+
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
    |> Enum.group_by(
      fn {a, _b} -> a end,
      fn {_a, b} -> b end
    )
    # +---+---+---+
    # | 7 | 8 | 9 |
    # +---+---+---+
    # | 4 | 5 | 6 |
    # +---+---+---+
    # | 1 | 2 | 3 |
    # +---+---+---+
    #     | 0 | A |
    #     +---+---+

    visited = %{}
              |> Map.put(src, 0)
    queue = :queue.new()
    queue = :queue.in([src], queue)
    generate_numpad_paths_between_points_impl(graph, dst, queue, visited, [])
  end

  defp generate_numpad_paths_between_points_impl(graph, dst, queue, visited, acc) do
    case :queue.out(queue) do
      {:empty, _} ->
        acc

      {{:value, [current_posn | rest]}, rest_queue} ->
        if current_posn == dst do
          acc = [ Enum.reverse([current_posn | rest]) | acc ]
          generate_numpad_paths_between_points_impl(graph, dst, rest_queue, visited, acc)
        else
          current_len = length(rest) + 1
          next_steps = graph
                       |> Map.get(current_posn, [])
                       |> Enum.filter(fn next_step -> current_len + 1 <= Map.get(visited, next_step, 1000) end)

          next_queue = next_steps
                       |> Enum.reduce(rest_queue, fn next_step, acc ->
                         :queue.in( [next_step, current_posn | rest], acc)
                       end)
          next_visited = next_steps
                         |> Enum.reduce(visited, fn next_step, acc ->
                           Map.put(acc, next_step, current_len + 1)
                         end)
          generate_numpad_paths_between_points_impl(graph, dst, next_queue, next_visited, acc)
        end
    end
  end

  defp _generate_direction_pad_moves() do
    #     +---+---+
    #     | ^ | A |
    # +---+---+---+
    # | < | v | > |
    # +---+---+---+
    _graph = [
      {?^, ?A},
      {?^, ?v},
      {?A, ?>},
      {?A, ?^},
      {?<, ?v},
      {?v, ?<},
      {?v, ?^},
      {?v, ?>},
      {?>, ?v},
      {?>, ?A},
    ]
    |> Enum.group_by(fn {a, _b} -> a end)

    0
  end


  defp extract_num(numStr) do
    numStr
    |> String.slice(0..2)
    |> String.to_integer()
  end

  def part2(_input) do
    0
  end

end
