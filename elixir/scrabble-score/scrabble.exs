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

  # Enumerable protocol isn't implemented for binary (for good reason)
  defp byte_reduce(<<>>, acc, _fun), do: acc
  defp byte_reduce(<<byte, bytes :: binary>>, acc, fun) do
    byte_reduce(bytes, fun.(byte, acc), fun)
  end

  @spec score(String.t) :: non_neg_integer
  def score(word) do
    # Takes advantage of UTF-8 encoding, looks at one byte at a time.
    # All characters in the table are < 128, which are encoded as-is in UTF-8.
    # Anything else, including multi-byte code point sequences, will map
    # to zero in the table.
    byte_reduce(word, 0, fn(byte, acc) -> acc + elem(@table, byte) end)
  end
end
