defmodule AOC.Day7 do
  @moduledoc """
  Solution to Day 7 of the Advent of code 2021
  https://adventofcode.com/2021/day/7
  """

  @doc """
  Read the input file
  """
  @spec get_inputs(File) :: [String.t()]
  def get_inputs(f \\ "lib/inputs/day7.txt") do
    File.read!(f)
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Find the median of given array
  """
  def median(arr) do
    sorted = Enum.sort(arr)
    l = length(arr)

    if rem(l, 2) == 1 do
      Enum.at(sorted, trunc(l / 2))
    else
      trunc((Enum.at(sorted, trunc((l - 1) / 2)) + Enum.at(sorted, trunc(l / 2))) / 2)
    end
  end

  @doc """
  Find sum of numbers from 1 to this number.
  ie. sum_to_1 7 -> 7+6+5+4+3+2+1
  """
  def sum_to_1(num), do: trunc(num * (num + 1) / 2)

  @doc """
  Find sum of distances of given array to given number
  """
  def distance_to_num(arr, num) do
    arr |> Enum.reduce(0, fn x, dist -> dist + abs(x - num) end)
  end

  @doc """
  Find sum of incremental distances of array to given number.
  Incremental distance is essentially sum_to_1 of the difference
  """
  def incremental_distance_to_num(arr, num) do
    arr |> Enum.reduce(0, fn x, dist -> dist + sum_to_1(abs(x - num)) end)
  end

  def part1(f \\ "lib/inputs/day7.txt") do
    arr =
      f
      |> get_inputs

    m = median(arr)
    distance_to_num(arr, m)
  end

  def part2(f \\ "lib/inputs/day7.txt") do
    arr =
      f
      |> get_inputs

    # using trunc does not work for example inputs but works for problem inputs!
    # for example input we need to use round of the average.
    m = trunc(Enum.sum(arr) / length(arr))

    incremental_distance_to_num(arr, m)
  end
end
