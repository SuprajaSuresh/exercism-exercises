# This exercise has a terrible API. Using atoms would've been a far better
# choice than this combinatorial explosion of exported functions.
# I guess this is really an exercise about metaprogramming and not dates?
defmodule Meetup do
  # This is a much less terrible API
  def meetup_last(year, month, weekday) do
    start_day = :calendar.last_day_of_the_month(year, month) - 6
    meetup_nth(year, month, start_day, weekday)
  end
  def meetup_nth(year, month, start_day, weekday) do
    case weekday - :calendar.day_of_the_week(year, month, start_day) do
       n when n < 0 -> {year, month, start_day + n + 7}
       n            -> {year, month, start_day + n}
    end
  end

  # Here's the awful
  Enum.each([ {1, "mon", "monday"},
              {2, "tues", "tuesday"},
              {3, "wednes", "wednesday"},
              {4, "thurs", "thursday"},
              {5, "fri", "friday"},
              {6, "satur", "saturday"},
              {7, "sun", "sunday"} ],
    fn ({weekday, short, long}) ->
      Enum.each([first: 1, second: 8, third: 15, fourth: 22],
        fn ({ordinal, day}) ->
          def unquote(binary_to_atom("#{ordinal}_#{long}"))(month, year) do
            meetup_nth(year, month, unquote(day), unquote(weekday))
          end
        end)
      def unquote(binary_to_atom("#{short}teenth"))(month, year) do
            meetup_nth(year, month, 13, unquote(weekday))
      end
      def unquote(binary_to_atom("last_#{long}"))(month, year) do
            meetup_last(year, month, unquote(weekday))
      end
    end)
end
