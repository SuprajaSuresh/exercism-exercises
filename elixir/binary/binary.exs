defmodule Binary do
  use Bitwise, only_operators: true
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t) :: non_neg_integer
  def to_decimal(string) do
    fold_bit(String.graphemes(string), 0)
  end

  defp fold_bit([d | ds], acc) when d == "0" or d == "1" do
    fold_bit(ds, (acc <<< 1) ||| if d == "1" do 1 else 0 end)
  end
  defp fold_bit([], acc), do: acc
  defp fold_bit(_, _), do: 0

end
