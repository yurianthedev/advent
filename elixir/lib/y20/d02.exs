defmodule Advent.Y20.D02 do
  alias Advent.Utils.Reader

  @input_path "inputs/day_02_input.txt"

  def count_valid_passwords(path \\ @input_path, part \\ :fp)

  def count_valid_passwords(path, :fp) do
    Reader.read_file!(path)
    |> Stream.map(&parse_line/1)
    |> Enum.count(&pwd_is_valid?/1)
    |> IO.puts()
  end

  def count_valid_passwords(path, :sp) do
    Reader.read_file!(path)
    |> Stream.map(&parse_line/1)
    |> Enum.count(&pwd_is_valid_sp?/1)
  end

  defp parse_line(line) do
    [str_range, str_letter, pwd] = String.split(line, " ")
    list_range = String.split(str_range, "-")

    range =
      Range.new(
        String.to_integer(Enum.at(list_range, 0)),
        String.to_integer(Enum.at(list_range, 1))
      )

    {String.trim_trailing(str_letter, ":"), range, pwd}
  end

  defp pwd_is_valid?({letter, range, pwd}) do
    count = Enum.count(String.graphemes(pwd), &(letter == &1))
    count in range
  end

  defp pwd_is_valid_sp?({letter, first..last, pwd}) do
    fp = String.at(pwd, first - 1) == letter
    lp = String.at(pwd, last - 1) == letter
    (fp and not lp) or (not fp and lp)
  end
end

Advent.Y20.D02.count_valid_passwords()
