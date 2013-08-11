# Note that the & special form requires Elixir 0.10.1.
defmodule Words do
  # I find using &inc_word/2 less readable than using a fn inside count/1
  # Including it here for the nitpicker.
  #defp inc_word("", dict) do
  #  dict
  #end
  #defp inc_word(word, dict) do
  #  HashDict.update(dict, word, 1, &(&1 + 1))
  #end
  def count(s) do
    inc_word = fn
      ("", dict) ->
        dict
      (word, dict) ->
        HashDict.update(dict, word, 1, &(&1 + 1))
    end
    List.foldl(
      String.split(String.downcase(s), %r/\W+/),
      HashDict.new([]),
      inc_word)
  end
end