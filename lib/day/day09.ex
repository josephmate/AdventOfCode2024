defmodule AdventOfCode.Day09 do
  defstruct  day: "09"

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
    input
    |> to_charlist()
    |> Enum.map(&(&1 - ?0))
    |> Enum.reduce({false, 0, []}, &expand_and_append_block/2)
    |> elem(2)
    |> Enum.reverse()
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {val, idx}, acc -> Map.put(acc, idx, val) end)
    |> fill_empty_blocks()
    |> Enum.filter(fn {_, val} -> val >= 0 end)
    |> Enum.map(fn {idx, val} -> idx * val end)
    |> Enum.sum()
  end

  def fill_empty_blocks(block_map) do
    fill_empty_blocks_impl(block_map, 0, map_size(block_map)-1)
  end

  def fill_empty_blocks_impl(block_map, blocks_left_idx, blocks_right_idx) do
    if blocks_left_idx >= blocks_right_idx do
      block_map
    else
      left = Map.get(block_map, blocks_left_idx)
      right = Map.get(block_map, blocks_right_idx)
      case {left, right} do
        # don't need to move empty block
        {_, -1}              -> fill_empty_blocks_impl(block_map, blocks_left_idx, blocks_right_idx-1)
        # can't move into an non-empty block
        {a, _} when a >= 0   -> fill_empty_blocks_impl(block_map, blocks_left_idx+1, blocks_right_idx)
        {a, b} when a < 0    -> fill_empty_blocks_impl(
            block_map
            |> Map.put(blocks_left_idx, b)
            |> Map.put(blocks_right_idx, -1),
            blocks_left_idx+1,
            blocks_right_idx-1
          )
      end
    end
  end

  def _print_block_map(block_map) do
    for i <- 0..map_size(block_map)-1 do
      digit = Map.get(block_map, i)
      if digit == -1 do
        IO.write(".")
      else
        IO.write(Integer.to_string(digit))
      end
    end
    IO.write("\n")
    block_map
  end

  def expand_and_append_block(digit, {is_empty_block?, id, blocks_so_far}) do
    if is_empty_block? do
      {false, id, [expand_block(-1, digit) | blocks_so_far]}
    else
      {true, id+1, [expand_block(id, digit) | blocks_so_far]}
    end

  end

  def expand_block(id, num_blocks) do
    List.duplicate(id, num_blocks)
  end

  def part2(_input) do
    0
  end
end
