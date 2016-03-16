moves = to_char_list File.read!('3.input')

defmodule Position do
  def calc(94, x, y), do: {x, y + 1}  # ^
  def calc(62, x, y), do: {x + 1, y} # >
  def calc(118, x, y), do: {x, y - 1} # v
  def calc(60, x, y), do: {x - 1, y} # <
  def calc(_, x, y), do: {x, y}

  def parse(moves) do
    visits = MapSet.new([{0, 0}])
    parse(moves, visits, {0, 0})
  end

  def parse([direction | tail], visits, {x, y}) do
    new_position = calc(direction, x, y)
    visits = MapSet.put(visits, new_position)
    parse(tail, visits, new_position)
  end

  def parse([], visits, _ ) do
    visits
  end
end

IO.puts MapSet.size(
  Position.parse(Enum.take_every(moves, 2),
                 Position.parse(Enum.take_every(tl(moves), 2)),
                 {0, 0})
)
