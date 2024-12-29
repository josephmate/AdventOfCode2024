defmodule AdventOfCode.Day24 do
  defstruct  day: "24"

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
    [initial_state, wire_connections] = input
    |> String.split("\n\n")

    initial_state = initial_state
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [a, b] -> {
      a,
      if b == "1" do
        true
      else
        false
      end}
    end)
    |> IO.inspect()

    wire_connections = wire_connections
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [a, op, b, _, destination] -> {a,op,b,destination} end)
    |> IO.inspect()

    var_to_input_lookup = wire_connections
    |> Enum.map(fn {a,op,b,destination} ->
      [
        {a, {a,op,b,destination}},
        {b, {a,op,b,destination}}
      ]
    end)
    |> List.flatten()
    |> Enum.group_by(
      fn {k, _} -> k end,
      fn {_, v} -> v end
    )
    |> IO.inspect()

    end_state = solve_eqn(initial_state, var_to_input_lookup)

    0
  end

  defp solve_eqn(initial_state, var_to_input_lookup) do
    0
  end

  def part2(_input) do
    0
  end

end
