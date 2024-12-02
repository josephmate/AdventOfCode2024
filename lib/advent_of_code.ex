defmodule AdventOfCode do

  def main(args) do
    case parse_args(args) do
      {:ok, day, part, type} ->
        run_day(day, part, type)
      {:error, message} ->
        IO.puts(message)
    end
  end

  defp parse_args(args) do
    case args do
      [day, part, type] ->
        with {day_num, _} <- Integer.parse(day),
             {part_num, _} <- Integer.parse(part),
             true <- day_num in 1..25,
             true <- part_num in 1..2,
             type <- String.to_atom(type) do
          case day_num do
            day_num when day_num in 1..9 ->
              {:ok, "0" <> Integer.to_string(day_num), part_num, type}
            day_num when day_num in 10..25 ->
              {:ok, Integer.to_string(day_num), part_num, type}
          end
        else
          _ -> {:error, "Invalid arguments. Use: ./advent_of_code [1-25] [1-2] sample\n"}
        end
      _ ->
        {:error, "Please provide day and part (e.g., 1 1 or 1 1 sample)\n"}
    end
  end

  defp run_day(day, part, type) do
    # Dynamically load the day's module
    module = Module.concat(AdventOfCode, "Day#{day}")
    dynamic = struct(module)

    if type == :sample do
      # Get sample files based on part
      sample_files = case part do
        1 -> AdventOfCode.DaySolution.sample_part1_files(dynamic)
        2 -> AdventOfCode.DaySolution.sample_part2_files(dynamic)
      end

      # Run each sample file
      Enum.each(sample_files, fn {input_path, result_path} ->
        # Read input and result files
        input = AdventOfCode.Utils.read_input(input_path)
        expected_result = AdventOfCode.Utils.read_input(result_path)

        # Solve and compare
        result =
          case part do
            1 -> apply(module, :part1, [input])
            2 -> apply(module, :part2, [input])
          end

        IO.puts("\nExpected Result:\n#{expected_result}")
        IO.puts("\nActual Result:\n#{result}")
      end)
    else
      # Puzzle input handling
      input = AdventOfCode.Utils.read_input("day#{day}.txt")

      result =
        case part do
          1 -> apply(module, :part1, [input])
          2 -> apply(module, :part2, [input])
        end

      IO.puts("Day #{day} Part #{part} Result:\n#{result}")
    end
  end
end
