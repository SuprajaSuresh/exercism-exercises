defmodule Teenager do
  @doc "Bob's response to the given fragment of conversation"
  def hey(s) do
    cond do
      # Nothing was said
      s === "" ->
        "Fine. Be that way!"
      # RESPONSE TO YELLING!
      s === String.upcase(s) ->
        "Woah, chill out!"
      # A question?
      String.ends_with?(s, "?") ->
        "Sure."
      # Default response
      true ->
        "Whatever."
    end 
  end
end