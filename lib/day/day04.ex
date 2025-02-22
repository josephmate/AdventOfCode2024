defmodule AdventOfCode.Day04 do
  defstruct  day: "04"

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
    wordsearch = input
    |> String.split("\n")
    |> Stream.map(&String.to_charlist/1)
    |> Stream.map(&List.to_tuple/1)
    |> Enum.to_list()
    |> List.to_tuple()
    |> IO.inspect()

    num_rows = tuple_size(wordsearch)
    num_cols = tuple_size(elem(wordsearch,0))
    for i <- 0..(num_rows-1) do
      for j <- 0..(num_cols-1) do
        for rdir <- -1..1 do
          for cdir <- -1..1 do
            if (rdir != 0 or cdir != 0)
               and i + 3*rdir >= 0
               and i + 3*rdir < num_rows
               and j + 3*cdir >= 0
               and j + 3*cdir < num_cols
            do
              if    index(wordsearch, i, j) == ?X
                and index(wordsearch, i+1*rdir, j+1*cdir) == ?M
                and index(wordsearch, i+2*rdir, j+2*cdir) == ?A
                and index(wordsearch, i+3*rdir, j+3*cdir) == ?S
              do
                1
              else
                0
              end
            else
              0
            end
          end
          |> Enum.sum()
        end
        |> Enum.sum()
      end
      |> Enum.sum()
    end
    |> Enum.sum()

  end

  def index(wordsearch, row, col) do
    elem(elem(wordsearch, row), col)
  end

  def part2(input) do
    wordsearch = input
    |> String.split("\n")
    |> Stream.map(&String.to_charlist/1)
    |> Stream.map(&List.to_tuple/1)
    |> Enum.to_list()
    |> List.to_tuple()
    |> IO.inspect()

    num_rows = tuple_size(wordsearch)
    num_cols = tuple_size(elem(wordsearch,0))
    for i <- 0..(num_rows-1) do
      for j <- 0..(num_cols-1) do
        if    i - 1 >= 0
          and i + 1 < num_rows
          and j - 1 >= 0
          and j + 1 < num_cols
          and index(wordsearch, i, j) == ?A
        do
          if (
            # Case 1 of 4
            # M S
            #  A
            # M S
            index(wordsearch, i-1, j-1) == ?M
            and index(wordsearch, i+1, j-1) == ?M
            and index(wordsearch, i+1, j+1) == ?S
            and index(wordsearch, i-1, j+1) == ?S
            )
            # Case 2 of 4
            # S S
            #  A
            # M M
            or (
            index(wordsearch, i-1, j-1)     == ?S
            and index(wordsearch, i+1, j-1) == ?M
            and index(wordsearch, i+1, j+1) == ?M
            and index(wordsearch, i-1, j+1) == ?S
            )
            # Case 3 of 4
            # M M
            #  A
            # S S
            or (
            index(wordsearch, i-1, j-1)     == ?M
            and index(wordsearch, i+1, j-1) == ?S
            and index(wordsearch, i+1, j+1) == ?S
            and index(wordsearch, i-1, j+1) == ?M
            )
            # Case 4 of 4
            # S M
            #  A
            # S M
            or (
            index(wordsearch, i-1, j-1)     == ?S
            and index(wordsearch, i+1, j-1) == ?S
            and index(wordsearch, i+1, j+1) == ?M
            and index(wordsearch, i-1, j+1) == ?M
            )
          do
            1
          else
            0
          end

        else
          0
        end
      end
      |> Enum.sum()
    end
    |> Enum.sum()

  end

end
