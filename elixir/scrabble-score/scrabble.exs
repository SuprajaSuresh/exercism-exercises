defmodule Scrabble do
  @doc """
  Calculate the scrabble score for the word.
  """
  # Build a constant time lookup tuple for all 0..255 possible bytes.
  # Conveniently, UTF-8 encoding will let us keep the table this small
  # and not have to do any conversions at runtime.
  @table (lc {score, str} inlist [{1, "AEIOULNRST"},
                                  {2, "DG"},
                                  {3, "BCMP"},
                                  {4, "FHVWY"},
                                  {5, "K"},
                                  {8, "JX"},
                                  {10, "QZ"}],
             norm inlist [String.upcase(str), String.downcase(str)],
             char inlist bitstring_to_list(norm),
             do: {char, score}) |>
         Enum.reduce(Tuple.duplicate(0, 256),
                     fn({char, score}, acc) -> set_elem(acc, char, score) end)

  @spec score(String.t) :: non_neg_integer
  def score(word) do
    bitstring_to_list(word) |>
    Enum.reduce(0, fn(char, acc) -> acc + elem(@table, char) end)
  end
end
