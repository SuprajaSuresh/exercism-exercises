defmodule DNA do
  def to_rna(cs) do
    lc c inlist cs, do: (if c == 'T' do 'U' else c end)
  end
end