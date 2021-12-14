defmodule Day8 do
  @behaviour Solution

  @test_input """
  be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
  edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
  fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
  fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
  aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
  fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
  dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
  bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
  egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
  gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
  """

  @unique_digits %{2 => 1, 3 => 7, 4 => 4, 7 => 8}

  @segments ~w(a b c d e f g)

  @patterns [
    MapSet.new(~w(a b c e f g)),
    MapSet.new(~w(c f)),
    MapSet.new(~w(a c d e g)),
    MapSet.new(~w(a c d f g)),
    MapSet.new(~w(b c d f)),
    MapSet.new(~w(a b d f g)),
    MapSet.new(~w(a b d e f g)),
    MapSet.new(~w(a c f)),
    MapSet.new(~w(a b c d e f g)),
    MapSet.new(~w(a b c d f g))
  ]

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  26
  """
  def solve_part_1(input) do
    input
    |> displays()
    |> Enum.flat_map(& &1.output)
    |> Enum.map(&MapSet.size/1)
    |> Enum.map(&Map.get(@unique_digits, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.count()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  61229
  """
  def solve_part_2(input) do
    decodings = decodings()

    input
    |> displays()
    |> Enum.map(&decode_display(&1, decodings))
    |> Enum.sum()
  end

  defp displays(input) do
    for line <- String.split(input, "\n", trim: true) do
      [patterns, output] = String.split(line, "|")
      %{patterns: segments(patterns), output: segments(output)}
    end
  end

  defp segments(input) do
    input
    |> String.split()
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&MapSet.new/1)
  end

  defp decodings do
    for encoded_segments <- Util.permute(@segments), into: Map.new() do
      segment_encoding = @segments |> Enum.zip(encoded_segments) |> Map.new()
      encoded_patterns = Enum.map(@patterns, &encode(&1, segment_encoding))
      pattern_decoding = encoded_patterns |> Enum.with_index() |> Map.new()

      {MapSet.new(encoded_patterns), pattern_decoding}
    end
  end

  defp encode(segments, encoding), do: MapSet.new(segments, &Map.get(encoding, &1))

  defp decode_display(%{patterns: patterns, output: output}, decodings) do
    decoding = Map.get(decodings, MapSet.new(patterns))

    output
    |> Enum.map(&Map.get(decoding, &1))
    |> Integer.undigits()
  end
end
