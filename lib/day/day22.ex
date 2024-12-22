defmodule AdventOfCode.Day22 do
  defstruct  day: "22"

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
    input
    |> String.split("\n")
    |> Enum.map(fn line -> String.to_integer(line) end)
    |> Enum.map(fn num -> secretNumber(num, 2000) end)
    |> IO.inspect()
    |> Enum.sum()
  end

  def secretNumber(secret, numNewSecrets) do
    if numNewSecrets == 0 do
      secret
    else
      secret
      # Calculate the result of multiplying the secret number by 64.
      # Then, mix this result into the secret number.
      |> mix(secret * 64)
      # Finally, prune the secret number.
      |> prune()
      # Calculate the result of dividing the secret number by 32.
      # Round the result down to the nearest integer.
      # Then, mix this result into the secret number.
      |> (fn secret -> mix(secret, div(secret, 32)) end).()
      # Finally, prune the secret number.
      |> prune()
      # Calculate the result of multiplying the secret number by 2048.
      # Then, mix this result into the secret number.
      |> (fn secret -> mix(secret, secret*2048) end).()
      # Finally, prune the secret number.
      |> prune()
      |> secretNumber(numNewSecrets-1)
      #
    end
  end

  def mix(a, b) do
    # To mix a value into the secret number,
    # calculate the bitwise XOR of the given value and the secret number.
    # Then, the secret number becomes the result of that operation.
    # (If the secret number is 42 and you were to mix 15 into the secret number, the secret number would become 37.)
    Bitwise.bxor(a,b)
  end

  def prune(a) do
    # To prune the secret number, calculate the value of the secret number modulo 16777216.
    # Then, the secret number becomes the result of that operation.
    # (If the secret number is 100000000 and you were to prune the secret number, the secret number would become 16113920.)
    rem(a, 16777216)
  end

  def part2(_input) do
    0
  end

end
