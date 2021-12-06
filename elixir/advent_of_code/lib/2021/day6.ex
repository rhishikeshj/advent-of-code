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
  end

  def inc_day(ages) do
    ages |> Stream.map(&(&1 - 1))
  end

  def spawn_new_fish(ages) do
    new_fish =
      ages
      |> Enum.count(&(&1 == -1))

    ages
    |> Stream.map(&if &1 == -1, do: 6, else: &1)
    |> then(
      &if new_fish > 0 do
        Stream.concat(
          &1,
          for _i <- 0..(new_fish - 1) do
            8
          end
        )
      else
        &1
      end
    )
  end

  def move_a_day(ages, 0), do: ages

  def move_a_day(ages, days) do
    move_a_day(ages |> inc_day |> spawn_new_fish, days - 1)
  end

  def part1(file \\ "lib/inputs/day6.txt") do
    file
    |> get_inputs
    |> move_a_day(80)
    |> Enum.to_list()
    |> length
  end
end
