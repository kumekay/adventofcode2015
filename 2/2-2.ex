defmodule Ribbon do
  def length([ {l, _ } | [ {w, _ } | [ {h, _ } | _ ]]]) do
    perimeters = [2*(l+w), 2*(w+h), 2*(h+l)]
    l*w*h + Enum.min(perimeters)
   end
end

len = File.stream!("2.input")
|> Enum.map( fn(x) -> (String.split(x, "x") |> Enum.map(&Integer.parse/1) |> Ribbon.length) end)
|> Enum.sum

IO.puts len
