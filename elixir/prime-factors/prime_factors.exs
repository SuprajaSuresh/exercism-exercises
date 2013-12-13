defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest. 
  """
  @spec for(pos_integer) :: [pos_integer]
  def for(number) do
    factors(number, prime_candidates())
  end

  defp factors(1, _), do: []
  defp factors(number, fs=[factor | _]) when rem(number, factor) == 0 do
    [factor | factors(div(number, factor), fs)]
  end
  defp factors(number, [_ | fs]), do: factors(number, fs)
  defp factors(number, lazyfn), do: factors(number, lazyfn.())

  # At first, it may appear to be insane to (ab)use improper lists, but this is
  # actually a well known and even officially documented technique in Erlang.
  # http://www.erlang.org/documentation/doc-5.8/doc/programming_examples/funs.html#id2259930
  def prime_candidates(), do: [2, 3 | next_candidate(6)]
  def next_candidate(n) do
    [n-1, n+1 | fn () -> next_candidate(n+6) end]
  end
end
