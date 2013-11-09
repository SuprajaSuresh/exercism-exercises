defmodule Grains do
  use Bitwise, only_operators: true
  def square(n), do: 1 <<< (n - 1)
  def total(), do: (1 <<< 64) - 1
end
