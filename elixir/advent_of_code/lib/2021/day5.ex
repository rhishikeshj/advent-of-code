defmodule AOC.Day5 do
  @moduledoc """
  Solution to Day 5 of the Advent of code 2021
  https://adventofcode.com/2021/day/5
  """

  @doc """
  Read the input file
  Returns the data as a tuple with inputs as first element and bingo boards as second
  """
  @spec get_inputs(File) :: [String.t()]
  def get_inputs(f \\ "lib/inputs/day5.txt") do
    File.read!(f)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn s ->
      String.split(s, "->")
      |> Enum.map(&String.trim/1)
      |> Enum.map(fn s -> String.split(s, ",") |> Enum.map(&String.to_integer/1) end)
    end)
  end

  @doc """
  Keep only straight lines from the given segments
  """
  def filter_for_straight_lines(segments \\ get_inputs()) do
    segments |> Enum.filter(fn [[sx, sy], [ex, ey]] -> sx == ex || sy == ey end)
  end

  @doc """
  For vertical lines, return list of all intermediate points.
  i.e 0,7 -> 0,10 = [{0,7}, {0,8}, {0,9}, {0,10}]
    For horizontal lines, return list of all intermediate points.
  i.e 7,0 -> 10,0 = [{7,0}, {8,0}, {9,0}, {10,0}]
  For diagonals, return points at 45 degrees. i.e points we get by incrementing x and y by 1
  """
  def explode_segment([[x, y1], [x, y2]]), do: for(i <- y1..y2, do: {x, i})

  def explode_segment([[x1, y], [x2, y]]), do: for(i <- x1..x2, do: {i, y})

  def explode_segment([[x1, y1], [x2, y2]]),
    do: Enum.zip(Enum.to_list(x1..x2), Enum.to_list(y1..y2))

  @doc """
  To avoid the most dangerous areas, you need to determine the number of points where at least two lines overlap.
  In the above example, this is anywhere in the diagram with a 2 or larger - a total of 5 points.

  Consider only horizontal and vertical lines. At how many points do at least two lines overlap?
  """
  def part1() do
    "lib/inputs/day5.txt"
    |> get_inputs
    |> filter_for_straight_lines
    |> Enum.map(&explode_segment/1)
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.filter(fn {_, c} -> c >= 2 end)
    |> Enum.count()
  end

  @doc """
  Consider all of the lines. At how many points do at least two lines overlap?
  """
  def part2() do
    "lib/inputs/day5.txt"
    |> get_inputs
    |> Enum.map(&explode_segment/1)
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.filter(fn {_, c} -> c >= 2 end)
    |> Enum.count()
  end
end
