defmodule Day7 do
  @behaviour Solution

  @test_input "16,1,2,0,4,2,7,1,2,14"

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  37
  """
  def solve_part_1(input) do
    input
    |> positions()
    |> fuel_costs(&distance/2)
    |> Enum.min()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  168
  """
  def solve_part_2(input) do
    input
    |> positions()
    |> fuel_costs(&triangle/2)
    |> Enum.min()
  end

  defp positions(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp fuel_costs(positions, calculate_cost) do
    destinations = Enum.min(positions)..Enum.max(positions)

    Enum.map(destinations, fn destination ->
      positions
      |> Enum.map(&calculate_cost.(&1, destination))
      |> Enum.sum()
    end)
  end

  defp distance(position, destination), do: abs(position - destination)

  defp triangle(position, destination) do
    distance = distance(position, destination)
    div(distance * (distance + 1), 2)
  end
end
