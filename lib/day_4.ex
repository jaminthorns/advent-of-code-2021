defmodule Day4 do
  @behaviour Solution

  @test_input """
  7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

  22 13 17 11  0
   8  2 23  4 24
  21  9 14 16  7
   6 10  3 18  5
   1 12 20 15 19

   3 15  0  2 22
   9 18 13 17  5
  19  8  7 25 23
  20 11 10 24  4
  14 21 16 12  6

  14 21 17 24  4
  10 16 15  9 19
  18  8 23 26 20
  22 11 13  6  5
   2  0 12  3  7
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  4512
  """
  def solve_part_1(input) do
    {numbers, boards} = bingo(input)

    numbers
    |> winner_scores(boards)
    |> Enum.at(0)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  1924
  """
  def solve_part_2(input) do
    {numbers, boards} = bingo(input)

    numbers
    |> winner_scores(boards)
    |> Enum.to_list()
    |> Enum.at(-1)
  end

  defp bingo(input) do
    [numbers_input | board_inputs] = String.split(input, "\n\n")

    numbers = numbers_input |> String.split(",") |> Enum.map(&String.to_integer/1)
    boards = Enum.map(board_inputs, &board/1)

    {numbers, boards}
  end

  defp board(input) do
    for {row, y} <-
          input
          |> String.split("\n")
          |> Enum.with_index(),
        {number, x} <-
          row
          |> String.split()
          |> Enum.map(&String.to_integer/1)
          |> Enum.with_index(),
        into: Map.new() do
      {{x, y}, %{number: number, marked: false}}
    end
  end

  defp winner_scores(numbers, boards) do
    Stream.resource(
      fn -> {numbers, boards} end,
      fn
        {_numbers, []} ->
          {:halt, nil}

        {[number | numbers], boards} ->
          boards = Enum.map(boards, &mark(&1, number))
          {winners, boards} = Enum.split_with(boards, &winner?/1)
          scores = Enum.map(winners, &score(&1, number))

          {scores, {numbers, boards}}
      end,
      fn _ -> nil end
    )
  end

  defp mark(board, number) do
    Map.map(board, fn
      {_, %{number: ^number} = position} -> %{position | marked: true}
      {_, position} -> position
    end)
  end

  defp winner?(board) do
    increasing = 0..4

    columns = Enum.map(increasing, fn x -> Enum.map(increasing, &{x, &1}) end)
    rows = Enum.map(increasing, fn y -> Enum.map(increasing, &{&1, y}) end)
    wins = Enum.concat(columns, rows)

    Enum.any?(wins, fn positions -> Enum.all?(positions, &board[&1].marked) end)
  end

  defp score(board, number) do
    board
    |> Map.values()
    |> Enum.reject(& &1.marked)
    |> Enum.map(& &1.number)
    |> Enum.sum()
    |> Kernel.*(number)
  end
end
