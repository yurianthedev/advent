defmodule Advent.Utils.Reader do
  def read_file!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
  end
end
