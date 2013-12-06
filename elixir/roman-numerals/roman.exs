defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """
  @places [ {1000, "M"}, {900, "CM"},
            { 500, "D"}, {400, "CD"},
            { 100, "C"}, { 90, "XC"},
            {  50, "L"}, { 40, "XL"},
            {  10, "X"}, {  9, "IX"},
            {   5, "V"}, {  4, "IV"},
            {   1, "I"} ]
  @spec numerals(pos_integer) :: String.t
  def numerals(number) do
    Enum.reduce(@places, {number, ""}, fn({n, digit}, {num, res}) ->
         {rem(num, n), res <> String.duplicate(digit, div(num, n))}
      end)
      |> elem(1)
  end
end
