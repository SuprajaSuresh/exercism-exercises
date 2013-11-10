defmodule Gigasecond do
  def from(date) do
    days_per_gigasecond = trunc(1.0e9 / 86400)
    :calendar.gregorian_days_to_date(
      :calendar.date_to_gregorian_days(date) + days_per_gigasecond)
  end
end