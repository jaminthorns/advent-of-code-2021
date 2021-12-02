defmodule Day2 do
  @behaviour Solution

  @test_input """
  forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  150
  """
  def solve_part_1(input) do
    input
    |> commands()
    |> Enum.reduce({0, 0}, &navigate_1/2)
    |> Tuple.product()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  900
  """
  def solve_part_2(input) do
    input
    |> commands()
    |> Enum.reduce({0, 0, 0}, &navigate_2/2)
    |> Tuple.delete_at(2)
    |> Tuple.product()
  end

  defp commands(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [command, units] -> {command, String.to_integer(units)} end)
  end

  defp navigate_1({"forward", x}, {pos, depth}), do: {pos + x, depth}
  defp navigate_1({"down", x}, {pos, depth}), do: {pos, depth + x}
  defp navigate_1({"up", x}, {pos, depth}), do: {pos, depth - x}

  defp navigate_2({"forward", x}, {pos, depth, aim}), do: {pos + x, depth + aim * x, aim}
  defp navigate_2({"down", x}, {pos, depth, aim}), do: {pos, depth, aim + x}
  defp navigate_2({"up", x}, {pos, depth, aim}), do: {pos, depth, aim - x}
end
