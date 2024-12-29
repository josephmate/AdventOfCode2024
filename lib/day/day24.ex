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
    |> Map.new()
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

    solve_eqn(initial_state, var_to_input_lookup)
    |> Enum.map(fn {k,v} -> {k,
      if v do
        1
      else
        0
      end
    } end)
    |> Enum.filter(fn {k,_} -> String.starts_with?(k, "z") end)
    |> Enum.sort()
    |> IO.inspect()
    |> Enum.reduce({0, 0}, fn {_, v}, {sum, pow} ->
      {sum + 2**pow * v, pow+1}
    end)
    |> elem(0)
  end

  defp solve_eqn(initial_state, var_to_input_lookup) do
    queue = :queue.new()
    queue = initial_state
    |> Enum.map(fn {k,_} -> k end)
    |> Enum.reduce(queue, fn ele, acc ->
      :queue.in(ele, acc)
    end)

    solve_eqn_impl(var_to_input_lookup, initial_state, queue)
  end

  defp solve_eqn_impl(var_to_input_lookup, state, queue) do
    case :queue.out(queue) do
      {:empty, _} ->
        state

      {{:value, var}, queue} ->
        {vars_changed, state} = Map.get(var_to_input_lookup, var, [])
        # {a,op,b,destination}
        # don't look at variables we already evaluated
        |> Enum.filter(fn {_,_,_,destination} -> !Map.has_key?(state, destination) end)
        # both variables need to evaluated already
        |> Enum.filter(fn {a,_,_,_} -> Map.has_key?(state, a) end)
        |> Enum.filter(fn {_,_,b,_} -> Map.has_key?(state, b) end)
        |> Enum.reduce({[], state}, fn {a,op,b,destination}, {vars_changed_acc, state_acc} ->
          vars_changed_acc = [destination | vars_changed_acc]
          a = Map.get(state, a)
          b = Map.get(state, b)
          result = case op do
            "AND" -> a and b
            "OR" -> a or b
            "XOR" -> (a and !b) or (!a and b)
          end
          state_acc = Map.put(state_acc, destination, result)
          {vars_changed_acc, state_acc}
        end)

        queue = vars_changed
        |> Enum.reduce(queue, fn ele, acc ->
          :queue.in(ele, acc)
        end)

        solve_eqn_impl(var_to_input_lookup, state, queue)
    end
  end

  def part2(_input) do
    0
  end

end
