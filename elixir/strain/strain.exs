defmodule Strain do

  @doc """
  Keep all entries in a collection that return true for a given function.

  Using filter would work, but don't use it.
  """
  @spec keep(Enum.t, (any -> as_boolean(term))) :: list
  def keep(collection, f) do
    collection
    |> Enum.reduce([], fn (x, acc) -> if f.(x), do: [x | acc], else: acc end)
    |> Enum.reduce([], fn (x, acc) -> [x | acc] end)
  end
  
  @doc """
  DIscard all entries in a collection that return true for a given function.

  Using reject would work, but don't use it.
  """
  @spec discard(Enum.t, (any -> as_boolean(term))) :: list
  def discard(collection, f) do
    collection
    |> Enum.reduce([], fn (x, acc) -> if !f.(x), do: [x | acc], else: acc end)
    |> Enum.reduce([], fn (x, acc) -> [x | acc] end)
  end

end