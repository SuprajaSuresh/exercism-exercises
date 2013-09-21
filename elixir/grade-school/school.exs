defmodule School do

  def add(d, name, grade) do
    # I don't like that the tests specify a particular data structure for this
    # exercise. It's O(n) to *append* to a list.
    HashDict.update(d, grade, [name], &(&1 ++ [name]))
  end

  def grade(d, grade) do
    HashDict.get(d, grade, [])
  end
  
  def sort(d) do
    HashDict.new(d, fn {k, v} -> {k, Enum.sort(v)} end)
  end

end