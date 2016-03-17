defmodule Lights do
  def rock(commands) do
    rock(commands, %{})
  end

  def rock([full_command | commands], on) do
    rock(commands, exec_command(full_command, on))
  end

  def rock([], on) do
    on
  end

  def exec_command( {cmd, x1 , y1, x2, y2 }, on) do
    {x1, _} = Integer.parse(x1)
    {y1, _} = Integer.parse(y1)
    {x2, _} = Integer.parse(x2)
    {y2, _} = Integer.parse(y2)

    Enum.map( x1..x2, fn(x) ->
        Enum.map(y1..y2, fn(y) ->
            {x, y}
        end)
    end)
    |> List.flatten
    |> coord_list_fill(cmd, on)
 end

 def coord_list_fill([coord | other], cmd, on) do
    coord_list_fill(other, cmd, fill_position(cmd, on, coord))
 end

 def coord_list_fill([], _, on), do: on

  def fill_position("toggle", on, coord) do
    { _, map } = Map.get_and_update(on, coord, &(br_add(&1, 2)) )
     map
  end

  def fill_position("turn on", on, coord) do
    { _, map } = Map.get_and_update(on, coord, &(br_add(&1, 1)) )
    map
  end

  def fill_position("turn off", on, coord) do
     { _, map } = Map.get_and_update(on, coord, &(br_add(&1, -1)) )
     map
  end

  def fill_position( _, on, _) do
    on
  end

  def br_add(nil, val) when (val <= 0), do: {nil, 0}
  def br_add(nil, val), do: {nil, val}
  def br_add(b, val) when (b + val <= 0), do: {b, 0}
  def br_add(b, val), do: {b, b + val}
end

parse = fn(s) ->
  s = String.strip(s)
  Regex.run(~r/([\w ]+) (\d+),(\d+) through (\d+),(\d+)/, s, capture: :all_but_first)
  |> List.to_tuple
end

File.stream!("6.input")
|> Enum.map(parse)
|> Lights.rock
|> Map.values
|> Enum.sum
|> IO.puts
