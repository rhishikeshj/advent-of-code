defmodule AOC.Day6 do
  @moduledoc """
  Solution to Day 6 of the Advent of code 2021
  https://adventofcode.com/2021/day/6
  """

  @doc """
  Read the input file
  Returns the data as a tuple with inputs as first element and bingo boards as second
  """
  @spec get_inputs(File) :: [String.t()]
  def get_inputs(f \\ "lib/inputs/day6.txt") do
    File.read!(f)
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
    |> Enum.into(%{0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0})
  end

  @doc """
  Increment the internal timer of lanternfish by a day
  Each day, a 0 becomes a 6 and adds a new 8 to the end of the list,
  while each other number decreases by 1 if it was present at the start of the day.
  """
  def inc_day(ages) do
    ages
    |> Enum.map(fn
      {8, v} -> {8, ages[0]}
      {6, v} -> {6, ages[7] + ages[0]}
      {k, v} -> {k, ages[k + 1]}
    end)
    |> Enum.into(%{})
  end

  def move_a_day(ages, 0), do: ages

  def move_a_day(ages, days) do
    move_a_day(ages |> inc_day, days - 1)
  end

  def part1(file \\ "lib/inputs/day6.txt") do
    file
    |> get_inputs
    |> move_a_day(80)
    |> Map.values()
    |> Enum.sum()
  end

  def part2(file \\ "lib/inputs/day6.txt") do
    file
    |> get_inputs
    |> move_a_day(256)
    |> Map.values()
    |> Enum.sum()
  end
end
