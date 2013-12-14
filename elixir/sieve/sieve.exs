defmodule Sieve do

  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    primes_to(limit, primes())
  end

  defp primes_to(limit, gen) do
    case gen do
      [p | next] when p <= limit -> [p | primes_to(limit, next)]
      [_ | _]                    -> []
      _                          -> primes_to(limit, gen.())
    end
  end

  # We don't need [2, 3] in the accumulator because we're only generating
  # candidates that are not multiples of either.
  def primes(), do: [2, 3 | primes(6, [])]
  def primes(n, acc) do
    primes = lc p inlist [n + 1, n - 1], is_prime?(p, acc), do: p
    Enum.reduce(
      primes,
      fn () -> primes(n + 6, primes ++ acc) end,
      fn (x, acc) -> [x | acc] end)
  end

  @spec is_prime?(non_neg_integer, [non_neg_integer]) :: boolean
  def is_prime?(number, primes) do
    Enum.all?(primes, fn (p) -> rem(number, p) != 0 end)
  end
end