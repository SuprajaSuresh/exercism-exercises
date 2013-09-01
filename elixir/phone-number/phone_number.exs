defmodule Phone do
  def number(raw) do
    case bc <<c>> inbits raw, c >= ?0 && c <= ?9, do: <<c>> do
      <<?1, digits :: [binary, size(10)] >> -> digits
      <<digits :: [binary, size(10)] >> -> digits
      _ -> "0000000000"
    end
  end

  def area_code(raw), do: binary_part(number(raw), 0, 3)

  def pretty(raw) do
    <<area :: [binary, size(3)],
      exchange :: [binary, size(3)],
      subscriber :: [binary, size(4)]>> = number(raw)
    <<"(", area :: binary, ") ",
      exchange :: binary, "-",
      subscriber :: binary>>
  end
end