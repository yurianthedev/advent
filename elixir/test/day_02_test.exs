defmodule Day02Test do
  use ExUnit.Case
  doctest Day02

  test "count the number of valid passwords" do
    assert Day02.count_valid_passwords("test/test_inputs/day_02_input.txt") == 2
  end

  test "count the number of valid passwords according with the new policies" do
    assert Day02.count_valid_passwords("test/test_inputs/day_02_input.txt", :sp) == 1
  end
end
