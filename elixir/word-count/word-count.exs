# Note that the & special form requires Elixir 0.10.1.
defmodule Words do
  def count(s) do
    s |> String.downcase
      |> String.split(%r/\W+/)
      |> List.foldl(HashDict.new([]), &inc_word/2)
  end

  defp inc_word("", dict) do
    dict
  end
  defp inc_word(word, dict) do
    HashDict.update(dict, word, 1, &(&1 + 1))
  end
end