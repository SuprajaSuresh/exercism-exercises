defmodule DNA do
  def hamming_distance(as, bs) do
    Enum.count(List.zip([as, bs]), fn ({a, b}) -> a != b end)
  end
end