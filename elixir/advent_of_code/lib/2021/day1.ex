defmodule AOC.Day1 do
  @moduledoc """
  Solution to Day 1 of the Advent of code 2021
  https://adventofcode.com/2021/day/1
  """

  @doc """
  Read the input file
  """
  @spec get_inputs(File) :: [String.t()]
  def get_inputs(f \\ "lib/inputs/day1.txt"),
    do: File.read!(f) |> String.trim() |> String.split("\n") |> Enum.map(&String.to_integer/1)

  @doc """
  Count the number of times a given fun returns true for an element and it's predecessor in a list.
  fun is a function which gets the current element as the first arg and prev element as the second arg.
  """
  @spec count_when_prev(list, fun()) :: pos_integer
  def count_when_prev([hd | tail], fun) do
    {count, _a} =
      Enum.reduce(tail, {0, hd}, fn x, {c, prev} ->
        if fun.(x, prev), do: {c + 1, x}, else: {c, x}
      end)

    count
  end

  @doc """
  Count the number of times a number is greater than its predecessor in a list
  """
  @spec count_increases(list) :: pos_integer
  def count_increases(inputs \\ get_inputs()), do: count_when_prev(inputs, &>/2)
end
