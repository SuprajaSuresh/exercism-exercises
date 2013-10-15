defmodule Year do
  defp has_factor?(dividend, divisor), do: rem(dividend, divisor) == 0

  def leap_year?(year) do
    has_factor?(year, 400) || (has_factor?(year, 4) && ! has_factor?(year, 100))
  end

end