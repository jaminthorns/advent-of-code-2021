defmodule Day5 do
  @behaviour Solution

  @test_input """
  0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  5
  """
  def solve_part_1(input) do
    input
    |> lines()
    |> Enum.filter(&horizontal_or_vertical?/1)
    |> count_overlaps()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  12
  """
  def solve_part_2(input) do
    input
    |> lines()
    |> count_overlaps()
  end

  defp lines(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.run(~r/(\d+),(\d+) -> (\d+),(\d+)/, &1, capture: :all_but_first))
    |> Enum.map(fn coordinates -> Enum.map(coordinates, &String.to_integer/1) end)
    |> Enum.map(fn [x1, y1, x2, y2] -> {{x1, y1}, {x2, y2}} end)
  end

  defp horizontal_or_vertical?({{x1, y1}, {x2, y2}}), do: x1 == x2 or y1 == y2

  defp count_overlaps(lines) do
    lines
    |> Enum.flat_map(&points/1)
    |> Enum.frequencies()
    |> Enum.count(fn {_, count} -> count >= 2 end)
  end

  defp points({{x, y1}, {x, y2}}), do: Enum.map(y1..y2, &{x, &1})
  defp points({{x1, y}, {x2, y}}), do: Enum.map(x1..x2, &{&1, y})
  defp points({{x1, y1}, {x2, y2}}), do: Enum.zip(x1..x2, y1..y2)
end
