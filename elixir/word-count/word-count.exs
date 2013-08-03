defmodule Words do
  def count(s) do
    inc_word = fn
      ("", dict) -> dict
      (word, dict) ->
        HashDict.update(dict, word, 1, fn (v) -> 1 + v end)
    end
    List.foldl(
      String.split(String.downcase(s), %r/\W+/),
      HashDict.new([]),
      inc_word)
  end
end