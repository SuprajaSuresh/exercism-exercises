defmodule ETL do
  def transform(old) do
    Enum.reduce(old, HashDict.new(), fn ({value, words}, dict) ->
      Enum.reduce(words, dict, fn (word, dict) ->
        # This will intentionally crash when a word is repeated (invalid input)
        HashDict.put_new(dict, String.downcase(word), value)
      end)
    end)
  end
end