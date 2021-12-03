defmodule AOC.Day3 do
  @moduledoc """
  Solution to Day 3 of the Advent of code 2021
  https://adventofcode.com/2021/day/3
  """

  @doc """
  Read the input file
  Return the result as an array of arrays
  [[0,1,0,1], [1,1,1,1]]
  """
  @spec get_inputs(File) :: [String.t()]
  def get_inputs(f \\ "lib/inputs/day3.txt") do
    input =
      File.read!(f)
      |> String.trim()
      |> String.split("\n")

    input
    |> Enum.map(&(String.codepoints(&1) |> Enum.map(fn s -> String.to_integer(s) end)))
  end

  @doc """
  Count the sum of bits in each position
  """
  def count_bits(arr \\ get_inputs()) do
    Enum.reduce(arr, fn b, counts ->
      Enum.with_index(counts) |> Enum.map(fn {v, i} -> v + Enum.at(b, i) end)
    end)
  end

  @doc """
  Find the most common bit given the count and number of entries.
  Expects output of count_bits as the first arg and length of inputs as second arg.
  Since only 0s and 1s are allowed, if the sum of bits in a position are greater than half
  the count, most common bit is 1, else 0
  """
  def most_common_bit(arr, c) do
    arr |> Enum.map(&if &1 >= c / 2, do: 1, else: 0)
  end

  @doc """
  Find the least common bit given the count and number of entries.
  Expects output of count_bits as the first arg and length of inputs as second arg.
  Since only 0s and 1s are allowed, if the sum of bits in a position are greater than half
  the count, least common bit is 1, else 0
  """
  def least_common_bit(arr, c) do
    arr |> Enum.map(&if &1 < c / 2, do: 1, else: 0)
  end

  @doc """
  Convert an array like [1,0,0,1] into an integer 9
  """
  def bit_arr_to_int(arr) do
    {i, _s} = arr |> Enum.join() |> Integer.parse(2)
    i
  end

  @doc """
  Use the binary numbers in your diagnostic report to calculate the gamma rate
  and epsilon rate, then multiply them together. What is the power consumption of the submarine?
  """
  def part1(f \\ "lib/inputs/day3.txt") do
    counts =
      f
      |> get_inputs()

    cnt = length(counts)
    counts = count_bits(counts)

    bit_arr_to_int(most_common_bit(counts, cnt)) * bit_arr_to_int(least_common_bit(counts, cnt))
  end

  @doc """
  Given an array of bit inputs (as returned by get_inputs/1) and a criteria function to determine
  which elements to select, return the winning element from the inputs.
  crfn can be either most_common_bit or least_common_bit
  """
  def rating(_a, _b, _c)

  def rating([], _crfn, _i), do: :fail

  def rating([a], _crfn, _i) do
    a
  end

  def rating(arr, crfn, i) do
    criteria = arr |> count_bits |> crfn.(length(arr))

    rating(
      arr
      |> Enum.filter(&(Enum.at(&1, i) == Enum.at(criteria, i))),
      crfn,
      i + 1
    )
  end

  @doc """
  To find oxygen generator rating, determine the most common value (0 or 1) in the current bit position,
  and keep only numbers with that bit in that position. If 0 and 1 are equally common,
  keep values with a 1 in the position being considered.
  """
  def o2_rating(arr) do
    rating(arr, &most_common_bit/2, 0)
  end

  @doc """
  To find CO2 scrubber rating, determine the least common value (0 or 1) in the current bit position,
  and keep only numbers with that bit in that position. If 0 and 1 are equally common,
  keep values with a 0 in the position being considered.
  """
  def co2_rating(arr) do
    rating(arr, &least_common_bit/2, 0)
  end

  @doc """
  Use the binary numbers in your diagnostic report to calculate the oxygen generator rating and CO2 scrubber rating,
  then multiply them together. What is the life support rating of the submarine?
  """
  def part2(f \\ "lib/inputs/day3.txt") do
    inputs = get_inputs(f)
    bit_arr_to_int(co2_rating(inputs)) * bit_arr_to_int(o2_rating(inputs))
  end
end
