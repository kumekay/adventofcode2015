defmodule ElfJson do
  def parse([ 123 | tail ], l ,acc) do
    acc ++ parse(tail, l+1, [])
  end

  def parse([ ?} | _ ], 0, acc) do
    acc
  end

  def parse([ ?} | tail ], l, acc) do
    acc ++ parse(tail, l-1, [])
  end

  def parse([], _, acc ), do: acc

  def parse([ h | t ], l, acc) do
    acc ++ [string([ h | t ], l, [])]
  end

  def string( [], _, st) do
     to_string st
  end

  def string([ 123 | tail ], l, st) do
    [to_string st] ++ parse([ 123 | tail ], l, [])
  end

  def string([ ?} | tail ], l, st) do
    parse([ ?} | tail ], l, [to_string st])
  end

  def string( [h | t], l, st) do
    string(t, l, st ++ [h] )
  end

  def antired([h | t], acc) when is_binary(h) do
    new_acc = if String.contains?(h, "red") do
      acc
    else
      [ h | acc ]
    end
    antired(t, new_acc)
  end

  def antired([h | t], acc) do
    antired(h, antired(t, acc))
  end

  def antired([], acc), do: acc

end

calc = fn (elf_json) ->
  elf_json |>
  String.strip |>
  String.replace(~r/([^:])"red"/,  "\\g{1}") |>
  String.replace(~r/[\"\[\]]/,  "") |>
  to_char_list |>
  ElfJson.parse(0, [])  #|>
  # ElfJson.antired([]) |>
  # List.flatten |>
  # Enum.map(fn(x) -> Regex.scan(~r/[-\d]+/, x , captures: :first)  end) |>
  # Enum.map(&String.to_integer/1) |>
  # Enum.sum
end
# File.read!('input.txt') |> calc.()
s = ~s([1,{"c":"red","b":2},{"d":3,"f":4},3])
calc.(s)
