defmodule Accumulate do

  @doc """
  Returns a collection after applying a given function to every element in a provided collection.
  
  Try to do this exercise without using map!
  """
  
  @spec accumulate(Enum.t, (any -> as_boolean(term))) :: list
  def accumulate(collection, function) do
    collection
    |> Enum.reduce([], fn (x, acc) -> [function.(x) | acc] end)
    |> Enum.reduce([], fn (x, acc) -> [x | acc] end)
  end

end