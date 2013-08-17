defmodule DNA do
  def count(strand, nucleotide), do: Enum.count(strand, &1 === nucleotide)
  def nucleotide_counts(strand) do
    List.foldl(strand,
               HashDict.new([{?A, 0}, {?C, 0}, {?G, 0}, {?T, 0}]),
               HashDict.update(&2, &1, &(&1 + 1)))
  end
end