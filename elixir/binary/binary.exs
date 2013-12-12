defmodule Binary do
  use Bitwise, only_operators: true
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t) :: non_neg_integer
  def to_decimal(string) do
    try do
      Enum.reduce(
        String.codepoints(string),
        0,
        fn (x, acc) ->
          (acc <<< 1) ||| cond do
            x == "0" -> 0
            x == "1" -> 1
            true     -> throw(:invalid_digit)
          end
        end)
    catch
      :invalid_digit -> 0
    end
  end
end
