# Note that the & special form requires Elixir 0.10.1.
defmodule Words do
  def count(s) do
    List.foldl(split_words(normalize(s)), HashDict.new([]), &inc_word/2)
  end

  defp inc_word("", dict) do
    dict
  end
  defp inc_word(word, dict) do
    HashDict.update(dict, word, 1, &(&1 + 1))
  end

  defp normalize(s) do
    String.downcase(s)
  end

  defp split_words(s) do
    String.split(s, %r/\W+/)
  end
end