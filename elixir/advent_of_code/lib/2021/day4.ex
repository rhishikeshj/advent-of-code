defmodule AOC.Day4 do
  @moduledoc """
  Solution to Day 4 of the Advent of code 2021
  https://adventofcode.com/2021/day/4
  """

  @doc """
  Read the input file
  Returns the data as a tuple with inputs as first element and bingo boards as second
  """
  @spec get_inputs(File) :: [String.t()]
  def get_inputs(f \\ "lib/inputs/day4.txt") do
    File.read!(f)
    |> String.trim()
    |> String.split("\n\n")
    |> then(fn [hd | tail] ->
      {hd,
       tail
       |> Enum.map(
         &(String.split(&1, "\n")
           |> Enum.map(fn s -> String.split(s) end))
       )}
    end)
  end

  @doc """
  Transpose the board. Useful when we need to traverse column wise
  """
  def transpose(board) do
    Enum.reverse(Enum.zip_reduce(board, [], fn e, acc -> [e | acc] end))
  end

  def flatten([head | tail]), do: flatten(head) ++ flatten(tail)
  def flatten([]), do: []
  def flatten(head), do: [head]

  @doc """
  Convert the bingo boards from [[1,2,3] [4,5,6] [7,8,9]...] to
  [[{1, false}, {2, false}, {3, false}] ...]
  """
  def create_boards(inputs) do
    inputs
    |> Enum.map(fn board ->
      for r <- board do
        for n <- r do
          {String.to_integer(n), false}
        end
      end
    end)
  end

  @doc """
  Given a board and a num, mark it as true if the number exists in the board
  """
  def mark_num_on_board(board, num) do
    for row <- board do
      for {n, m?} <- row do
        if n == num, do: {n, true}, else: {n, m?}
      end
    end
  end

  @doc """
  Check if all numbers in a row or column are marked true
  """
  def check_row_col_for_win(rc) do
    Enum.all?(rc, fn {_n, m?} -> m? end)
  end

  @doc """
  Check if the board has won i.e any row or column is completely marked true
  """
  def check_board_for_win(board) do
    if(
      Enum.any?(
        for r <- board do
          check_row_col_for_win(r)
        end
      ) or
        Enum.any?(
          for r <- transpose(board) do
            check_row_col_for_win(r)
          end
        )
    ) do
      board
    else
      nil
    end
  end

  def call_to_win(_boards, []) do
    nil
  end

  @doc """
  Find the first board that wins given the number.
  If not winners are found, repeat with the next input number.
  """
  def call_to_win(boards, [num | tail]) do
    new_boards =
      boards
      |> Stream.map(&mark_num_on_board(&1, num))

    w =
      Enum.find(
        new_boards
        |> Enum.map(&check_board_for_win/1),
        fn x -> x != nil end
      )

    if w != nil, do: {w, num}, else: call_to_win(Enum.to_list(new_boards), tail)
  end

  def call_to_lose(_boards, []) do
    nil
  end

  @doc """
  Find the last board that wins given the number.
  If a board wins, it is removed from the list of boards and process is repeated for next numbers.
  If no boards remain, return the first winner and number
  If no board wins, repeat with the next input number
  """
  def call_to_lose(boards, [num | tail]) do
    new_boards =
      boards
      |> Stream.map(&mark_num_on_board(&1, num))

    winners =
      Enum.filter(
        new_boards
        |> Enum.map(&check_board_for_win/1),
        fn x -> x != nil end
      )

    if winners != nil do
      rem_boards = Enum.to_list(new_boards) -- winners

      if length(rem_boards) == 0,
        do: {hd(winners), num},
        else: call_to_lose(rem_boards, tail)
    else
      call_to_lose(Enum.to_list(new_boards), tail)
    end
  end

  @doc """
  Find the score of a winning board.
  Score is sum of unmarked numbers * number which won the board
  """
  def calculate_score({board, num}) do
    num *
      (for r <- board do
         for {n, m?} <- r do
           if not m?, do: n, else: 0
         end
       end
       |> flatten
       |> Enum.sum())
  end

  @doc """
  To guarantee victory against the giant squid, figure out which board will win first.
  What will your final score be if you choose that board?
  mix run -e "IO.inspect(AOC.Day4.part1)"
  """
  def part1() do
    {i, b} = get_inputs("lib/inputs/day4.txt")
    inputs = String.split(i, ",") |> Enum.map(&String.to_integer/1)

    b |> create_boards |> call_to_win(inputs) |> calculate_score
  end

  @doc """
  Figure out which board will win last. Once it wins, what would its final score be?
  mix run -e "IO.inspect(AOC.Day4.part2)"
  """
  def part2() do
    {i, b} = get_inputs("lib/inputs/day4.txt")
    inputs = String.split(i, ",") |> Enum.map(&String.to_integer/1)

    b |> create_boards |> call_to_lose(inputs) |> calculate_score
  end
end
