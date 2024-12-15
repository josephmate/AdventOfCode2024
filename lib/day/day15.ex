defmodule AdventOfCode.Day15 do
  defstruct  day: "15"

  defimpl AdventOfCode.DaySolution do
    def sample_part1_files(value) do
      %{
        "day#{value.day}_sample_small.txt" => "day#{value.day}_sample_small_part1_result.txt",
        "day#{value.day}_sample_big.txt" => "day#{value.day}_sample_big_part1_result.txt"
      }
    end

    def sample_part2_files(value) do
      %{
        "day#{value.day}_sample.txt" => "day#{value.day}_sample_part2_result.txt"
      }
    end
  end

  def part1(input) do
    [map, movements_list] = input
    |> String.split("\n\n")

    map = map
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
    |> array_to_indexes()
    |> List.flatten()
    |> Enum.reduce(%{}, fn {r, c, element}, acc ->
      Map.put(acc, {r,c}, element)
    end)
    #|>IO.inspect()

    {max_row, max_col} = size_2d(map)

    robot_start = find_2d(map, ?@, max_row, max_col)
    #|>IO.inspect()

    movements_list
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
    |> List.flatten()
    |> Enum.reduce({robot_start, map}, fn move, acc ->
      apply_move(acc, move)
    end)
    #|>IO.inspect()
    |> elem(1)
    |> score_map()
  end

  def score_map(map) do
    map
    |> Enum.filter(fn {{_,_}, element} -> element == ?O end)
    |> Enum.map(fn {{r,c}, _} -> r*100 + c end)
    |> Enum.sum()
  end

  def apply_move({{r, c}, map}, move) do
    #IO.puts("#{<<move>>} #{r},#{c}")
    case move do
      ?< -> apply_move_impl(map,r,c,  0, -1)
      ?> -> apply_move_impl(map,r,c,  0,  1)
      ?^ -> apply_move_impl(map,r,c, -1,  0)
      ?v -> apply_move_impl(map,r,c,  1,  0)
    end
    #|> print_map()
  end

  def _print_map({robot_posn, map}) do
    {max_row, max_col} = size_2d(map)
    for r <- 0..max_row do
      for c <- 0..max_col do
        element = Map.get(map, {r,c})
        IO.write(<<element>>)
      end
      IO.write("\n")
    end
    {robot_posn, map}
  end

  def apply_move_impl(map,r,c, rv, cv) do
    new_r = r + rv
    new_c = c + cv
    element = Map.get(map, {new_r, new_c})
    #IO.puts("#{r},#{c}   #{rv},#{cv}   #{element}   #{<<element>>}")
    case element do
      # no change since we cannot move a wall
      ?# -> {{r,c}, map}
      # no problem moving into empty position
      ?. ->
        updated_map = map
        |> Map.put({r,c}, ?.)
        |> Map.put({new_r,new_c}, ?@)
        {{new_r,new_c}, updated_map}
      ?O ->
        {has_empty?, empty_r, empty_c} = find_empty(map, new_r, new_c, rv, cv)
        if has_empty? do
          # move the O from the front to the back of the movement
          updated_map = map
          |> Map.put({r,c}, ?.)
          |> Map.put({new_r,new_c}, ?@)
          |> Map.put({empty_r,empty_c}, ?O)
          {{new_r, new_c}, updated_map}
        else
          # no change since we cannot move any of the boxes
          {{r,c}, map}
        end
    end
  end

  def find_empty(map, r, c, rv, cv) do
    element = Map.get(map, {r, c})
    #IO.puts("find_empty #{r},#{c}  #{rv},#{cv} #{element} #{<<element>>}")
    #print_map({{-1,-1}, map})
    case element do
      ?# -> {false, -1, -1}
      ?O -> find_empty(map, r+rv, c+cv, rv, cv)
      ?. -> {true, r, c}
    end
  end


  def find_2d(map, char, max_row, max_col) do
    find_2d_impl(map, char, max_row, max_col, 0, 0)
  end

  def find_2d_impl(map, char, max_row, max_col, r, c) do
    case {r, c} do
      {r, _} when r > max_row ->
        #IO.puts("not found all level r,c=#{r},#{c}, max r,c=#{max_row},#{max_col}")
        nil
      {_, c} when c > max_col ->
        #IO.puts("not found row level r,c=#{r},#{c}, max r,c=#{max_row},#{max_col}")
        find_2d_impl(map, char, max_row, max_col, r+1, 0)
      {r, c} ->
        if Map.get(map, {r, c}) == char do
          #IO.puts("found r,c=#{r},#{c}, max r,c=#{max_row},#{max_col}")
          {r, c}
        else
          #IO.puts("not found col level r,c=#{r},#{c}, max r,c=#{max_row},#{max_col}")
          find_2d_impl(map, char, max_row, max_col, r, c+1)
        end
    end
  end

  def size_2d(map) do
    {
      map
      |> Enum.map(fn {k,_} -> k end)
      |> Enum.map(fn {r,_} -> r end)
      |> Enum.max(),
      map
      |> Enum.map(fn {k,_} -> k end)
      |> Enum.map(fn {_,c} -> c end)
      |> Enum.max(),
    }
  end

  def array_to_indexes(array) do
    num_rows = tuple_size(array)
    num_cols = tuple_size(elem(array,0))

    for r <- 0..num_rows-1 do
      for c <- 0..num_cols-1 do
        element = index(array, r, c)
        {r, c, element}
      end
    end
  end

  def index(arr, row, col) do
    elem(elem(arr, row), col)
  end

  def part2(_input) do
    0
  end

end
