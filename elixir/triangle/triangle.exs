defmodule Triangle do
  def kind(a, b, c) do
    cond do
      (a <= 0) or (b <= 0) or (c <= 0) ->
        { :error, "all side lengths must be positive" }
      (a + b <= c) or (b + c <= a) or (a + c <= b) ->
        { :error, "side lengths violate triangle inequality" }
      (a == b) and (b == c) ->
        { :ok, :equilateral }
      (a == b) or (b == c) or (a == c) ->
        { :ok, :isosceles }
      true ->
        { :ok, :scalene }
    end
  end
end