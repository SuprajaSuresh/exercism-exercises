# Note that the & special form requires Elixir 0.10.1.
defmodule Anagram do
  def match(word, possible_anagrams) do
    word_letters = sorted_letters(word)
    Enum.filter(possible_anagrams, &(word_letters == sorted_letters(&1)))
  end
  defp sorted_letters(word) do
    word |> String.codepoints |> Enum.sort
  end
end