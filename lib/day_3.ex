defmodule Day3 do
  @behaviour Solution

  @test_input """
  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  198
  """
  def solve_part_1(input) do
    columns = input |> bits() |> columns()

    gamma_rate = rate(columns, &Enum.max_by/2)
    epsilon_rate = rate(columns, &Enum.min_by/2)

    gamma_rate * epsilon_rate
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  230
  """
  def solve_part_2(input) do
    rows = input |> bits() |> rows()

    oxygen_generator_rating = rating(rows, &Enum.max_by/2, 1)
    co2_scrubber_rating = rating(rows, &Enum.min_by/2, 0)

    oxygen_generator_rating * co2_scrubber_rating
  end

  defp bits(input) do
    for {num, row} <-
          input
          |> String.split()
          |> Enum.with_index(),
        {bit, col} <-
          num
          |> String.graphemes()
          |> Enum.map(&String.to_integer/1)
          |> Enum.with_index() do
      {{row, col}, bit}
    end
  end

  defp rows(bits), do: lines(bits, &elem(&1, 0))
  defp columns(bits), do: lines(bits, &elem(&1, 1))

  defp lines(bits, dimension) do
    bits
    |> Enum.group_by(&(&1 |> elem(0) |> dimension.()), &elem(&1, 1))
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
  end

  defp rate(columns, extreme_by) do
    columns
    |> Enum.map(&common(&1, extreme_by))
    |> Integer.undigits(2)
  end

  defp rating(rows, extreme_by, fallback) do
    last_col = (rows |> List.first() |> length()) - 1

    Enum.reduce_while(0..last_col, rows, fn col, rows ->
      col_bits = rows |> Enum.map(&Enum.at(&1, col))
      common = common(col_bits, extreme_by, fallback)

      case Enum.filter(rows, &(Enum.at(&1, col) == common)) do
        [row] -> {:halt, Integer.undigits(row, 2)}
        rows -> {:cont, rows}
      end
    end)
  end

  defp common(bits, extreme_by, fallback \\ nil) do
    case Enum.frequencies(bits) do
      %{0 => n, 1 => n} -> fallback
      frequencies -> frequencies |> extreme_by.(&elem(&1, 1)) |> elem(0)
    end
  end
end
