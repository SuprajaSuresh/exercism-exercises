defmodule Beer do
  defp bottles(0), do: "no more bottles of beer"
  defp bottles(1), do: "1 bottle of beer"
  defp bottles(n), do: <<integer_to_binary(n) :: binary, " bottles of beer">>

  defp on_the_wall(n) do
    phrase = bottles(n)
    <<String.capitalize(phrase) :: binary,
      " on the wall, ",
      phrase :: binary,
      ".">>
  end

  defp take_down(n) when n >= 0 do
    <<"Take ",
      (if (n == 0) do "it" else "one" end) :: binary,
      " down and pass it around, ",
      bottles(n) :: binary,
      " on the wall.">>
  end
  defp take_down(_) do
    "Go to the store and buy some more, 99 bottles of beer on the wall."
  end

  @doc "Sing the verse of 99 bottles of beer on the wall given n bottles"
  def verse(n) do
    <<on_the_wall(n) :: binary,
      "\n",
      take_down(n - 1) :: binary,
      "\n">>
  end

  @doc "Sing verses from start_verse down to end_verse (inclusive)"
  def sing(start_verse, end_verse // 0) do
    verses = Enum.to_list(start_verse..end_verse)
    bc n inlist verses, do: <<verse(n) :: binary, "\n">>
  end
end