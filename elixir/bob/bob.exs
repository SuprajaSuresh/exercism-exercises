defmodule Teenager do
  def hey(s) do
    cond do
      s === "" ->
        "Fine. Be that way!"
      s === String.upcase(s) ->
        "Woah, chill out!"
      String.ends_with?(s, "?") ->
        "Sure."
      true ->
        "Whatever."
    end 
  end
end