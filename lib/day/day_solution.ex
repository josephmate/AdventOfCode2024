defmodule AdventOfCode.DaySolution do
  @type t :: module()

  @callback sample_part1_files() :: %{
    optional(String.t()) => String.t()
  }

  @callback sample_part2_files() :: %{
    optional(String.t()) => String.t()
  }


  def sample_part1_files(module) do
    day_num = module_to_day_num(module)
    %{
      "day#{day_num}_sample.txt" => "day#{day_num}_sample_part1_result.txt"
    }
  end

  def sample_part2_files(module) do
    day_num = module_to_day_num(module)
    %{
      "day#{day_num}_sample.txt" => "day#{day_num}_sample_part2_result.txt"
    }
  end

  defp module_to_day_num(module) do
    module
    |> Atom.to_string()
    |> String.split(".")
    |> List.last()
    |> String.replace("Day", "")
  end
end
