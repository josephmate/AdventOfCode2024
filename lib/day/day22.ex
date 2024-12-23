defmodule AdventOfCode.Day22 do
  defstruct  day: "22"

  defimpl AdventOfCode.DaySolution do
    def sample_part1_files(value) do
      %{
        "day#{value.day}_sample_part1.txt" => "day#{value.day}_sample_part1_result.txt"
      }
    end

    def sample_part2_files(value) do
      %{
        "day#{value.day}_sample_part2.txt" => "day#{value.day}_sample_part2_result.txt"
      }
    end
  end

  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line -> String.to_integer(line) end)
    |> Enum.map(fn num -> secretNumber(num, 2000) end)
    |> Enum.map(&List.last()/1)
    |> IO.inspect()
    |> Enum.sum()
  end

  def secretNumber(secret, numNewSecrets) do
    secretNumberImpl(secret, numNewSecrets, [secret])
  end

  def secretNumberImpl(secret, numNewSecrets, acc) do
    if numNewSecrets == 0 do
      acc
      |> Enum.reverse()
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
      |> (fn secret ->
        secretNumberImpl(secret, numNewSecrets-1, [secret | acc])
      end).()
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

  def part2(input) do
    prices = input
    |> String.split("\n")
    |> Enum.map(fn line -> String.to_integer(line) end)
    |> Enum.map(fn num -> secretNumber(num, 2000) end)
    |> Enum.map(fn secrets ->
      secrets
      |> Enum.map(fn secret -> rem(secret, 10) end)
    end)

    deltas = prices
    |> Enum.map(fn list ->
      list
      |> Enum.zip(tl(list))
      |> Enum.map(fn {a, b} -> b - a end)
    end)

    uniq4Tuples = deltas
    |> Enum.map(fn changes ->
      changes
      |> Enum.chunk_every(4, 1, :discard)
    end)
    |> Enum.flat_map(fn sublist ->
      sublist
    end)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.reduce(MapSet.new(), fn tuple, acc ->
      MapSet.put(acc, tuple)
    end)
    # only 40951 unique options for 4 consectutive price changes
    # not that bad. could also do 18^4 = 104,976. still not to bad

    # build a map of {4-tuple} to price for each row
    # iterate over unique 4 tuples and see which is best
    # use the map to quickly calculate the sum of the 4 tuple
    maps = prices
    |> Enum.map(&buildMapToPrice/1)

    uniq4Tuples
    |> Enum.map(fn uniqTuple ->
      maps
      |> Enum.map(fn map ->
        Map.get(map, uniqTuple, 0)
      end)
      |> Enum.sum()
    end)
    |> Enum.max()


  end

  def buildMapToPrice(prices) do
    [p1, p2, p3, p4, p5 | prices] = prices
    buildMapToPriceImpl(
      p2-p1,
      p3-p2,
      p4-p3,
      p5-p4,
      p5,
      prices,
      %{}
    )
  end

  def buildMapToPriceImpl(d1,d2,d3,d4,price,prices,map) do
    map = if !Map.has_key?(map, {d1,d2,d3,d4}) do
      Map.put(map, {d1,d2,d3,d4}, price)
    else
      map
    end

    case prices do
      [] -> map
      [next_price | new_prices] ->
        buildMapToPriceImpl(d2,d3,d4,next_price-price,next_price, new_prices, map)
    end
  end

end
