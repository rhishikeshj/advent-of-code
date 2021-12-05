defmodule AOC.Day5Bad do
  @moduledoc """
  Solution to Day 4 of the Advent of code 2021
  https://adventofcode.com/2021/day/4
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

  def filter_for_straight_lines(segments \\ get_inputs()) do
    segments |> Enum.filter(fn [[sx, sy], [ex, ey]] -> sx == ex || sy == ey end)
  end

  # both lines horizontal, only intersect if ys are same
  def find_intersections([[sp1x, y], [ep1x, y]], [[sp2x, y], [ep2x, y]]) do
    [s1, e1] = Enum.sort([sp1x, ep1x])
    [s2, e2] = Enum.sort([sp2x, ep2x])

    cond do
      s2 < s1 and e1 < e2 -> [[s1, y], [e1, y]]
      s1 < s2 and e2 < e1 -> [[s2, y], [e2, y]]
      s1 < s2 and s2 <= e1 and e1 < e2 -> [[s2, y], [e1, y]]
      s2 < s1 and s1 <= e2 and e2 < e1 -> [[s1, y], [e2, y]]
      true -> nil
    end
  end

  # both lines vertical, only intersect if xs are same
  def find_intersections([[x, sp1y], [x, ep1y]], [[x, sp2y], [x, ep2y]]) do
    [s1, e1] = Enum.sort([sp1y, ep1y])
    [s2, e2] = Enum.sort([sp2y, ep2y])

    cond do
      s2 < s1 and e1 < e2 -> [[x, s1], [x, e1]]
      s1 < s2 and e2 < e1 -> [[x, s2], [x, e2]]
      s1 < s2 and s2 <= e1 and e1 < e2 -> [[x, s2], [x, e1]]
      s2 < s1 and s1 <= e2 and e2 < e1 -> [[x, s1], [x, e2]]
      true -> nil
    end
  end

  # first line vertical, second horizontal
  def find_intersections([[x1, sp1y], [x1, ep1y]], [[sp2x, y2], [ep2x, y2]]) do
    [sy, ey] = Enum.sort([sp1y, ep1y])
    [sx, ex] = Enum.sort([sp2x, ep2x])
    if sy <= y2 and y2 <= ey and sx <= x1 and x1 <= ex, do: [[x1, y2], [x1, y2]]
  end

  def find_intersections(_p1, _p2), do: nil

  def find_all_intersections(lines) do
    for l1 <- lines do
      for l2 <- lines, l1 != l2, do: find_intersections(l1, l2)
    end
  end

  def find_length([[x, y], [x, y]]) do
    1
  end

  def find_length([[x1, y], [x2, y]]) do
    1 + abs(x2 - x1)
  end

  def find_length([[x, y1], [x, y2]]) do
    1 + abs(y2 - y1)
  end

  def run() do
    "lib/inputs/day5.txt"
    |> get_inputs
    |> filter_for_straight_lines
    |> find_all_intersections
    |> Stream.map(fn l -> Enum.filter(l, &(&1 != nil)) end)
    |> Stream.filter(&(length(&1) > 0))
    |> Stream.flat_map(& &1)
    |> Stream.uniq()
    |> Enum.reduce(0, fn x, acc -> acc + find_length(x) end)
  end
end
