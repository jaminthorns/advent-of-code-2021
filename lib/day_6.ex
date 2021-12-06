defmodule Day6 do
  @behaviour Solution

  @test_input "3,4,3,1,2"

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  5934
  """
  def solve_part_1(input) do
    input
    |> fish()
    |> count(80)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  26984457539
  """
  def solve_part_2(input) do
    input
    |> fish()
    |> count(256)
  end

  defp fish(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  defp tick(fish) do
    parents = Map.get(fish, 0, 0)

    fish
    |> Map.delete(0)
    |> Map.new(fn {days, count} -> {days - 1, count} end)
    |> Map.update(6, parents, &(&1 + parents))
    |> Map.put(8, parents)
  end

  defp count(fish, days) do
    fish
    |> Stream.iterate(&tick/1)
    |> Enum.at(days)
    |> Map.values()
    |> Enum.sum()
  end
end
