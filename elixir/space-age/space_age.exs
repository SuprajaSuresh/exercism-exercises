# This is another example where the API should be smaller.
defmodule SpaceAge_Sane do
  def age_on(planet, seconds), do: seconds / seconds_per_year(planet)

  def seconds_per_year(planet) do
    earth_year = 365.25 * 24 * 60 * 60
    earth_year * case planet do
      :mercury -> 0.2408467
      :venus   -> 0.61519726
      :earth   -> 1
      :mars    -> 1.8808158
      :jupiter -> 11.862615
      :saturn  -> 29.447498
      :uranus  -> 84.016846
      :neptune -> 164.79132
    end
  end
end

defmodule SpaceAge do
  # Here's the awful metaprogramming
  Enum.each([:mercury, :venus, :earth, :mars,
             :jupiter, :saturn, :uranus, :neptune],
    fn (planet) ->
      def unquote(binary_to_atom("#{planet}_years"))(seconds) do
        seconds / unquote(SpaceAge_Sane.seconds_per_year(planet))
      end
    end)

end
