defmodule Paper do
  def area([ {l, _ } | [ {w, _ } | [ {h, _ } | _ ]]]) do
    subareas = [l*w, w*h, h*l]
    Enum.reduce(subareas, 0,fn(a, acc) -> 2*a + acc end) + Enum.min(subareas)
   end
end

area = File.stream!("2.input")
|> Enum.map( fn(x) -> (String.split(x, "x") |> Enum.map(&Integer.parse/1) |> Paper.area) end)
|> Enum.sum

IO.puts area
