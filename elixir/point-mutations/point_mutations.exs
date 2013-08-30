defmodule DNA do
  def hamming_distance(as, bs) do
    List.zip([as, bs]) |>
    List.foldl(0, fn ({a, b}, acc) -> acc + if a == b do 0 else 1 end end)
  end
end