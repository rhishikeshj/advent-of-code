defmodule AOC.Day2 do
  @moduledoc """
  Solution to Day 2 of the Advent of code 2021
  https://adventofcode.com/2021/day/2
  """

  @doc """
  Read the input file
  """
  @spec get_inputs(File) :: [String.t()]
  def get_inputs(f \\ "lib/inputs/day2.txt"),
    do:
      File.read!(f)
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&(String.split(&1, " ") |> then(fn [c, v] -> [c, String.to_integer(v)] end)))

  @doc """
  Given a set of commands in the form [["forward", 5] ["down", 3] ["up", 7]]
  figure out the result of multiplying final horizontal and depth values
  """

  def navigate(commands \\ get_inputs()) do
    commands
    |> Enum.reduce({0, 0}, fn [c, v], {h, d} ->
      case c do
        "forward" -> {h + v, d}
        "up" -> {h, d - v}
        "down" -> {h, d + v}
      end
    end)
    |> then(fn {h, d} -> h * d end)
  end

  @doc """
  Given a set of commands in the form [["forward", 5] ["down", 3] ["up", 7]]
  figure out the result of multiplying final horizontal and depth values. In this version
  the up and down values affect aim of the navigation
  """

  def navigate_with_aims(commands \\ get_inputs()) do
    commands
    |> Enum.reduce({0, 0, 0}, fn [c, v], {h, d, a} ->
      case c do
        "forward" -> {h + v, d + a * v, a}
        "up" -> {h, d, a - v}
        "down" -> {h, d, a + v}
      end
    end)
    |> then(fn {h, d, _a} -> h * d end)
  end
end
