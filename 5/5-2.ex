defmodule Rules do
  # pair of any two letters that appears at least twice in the string without overlapping
  def first(s) do
    sl = to_char_list s

    Enum.zip(sl, tl(sl))
    |> Enum.map(fn(x) ->  Tuple.to_list(x) |> to_string end)
    |> MapSet.new
    |> Enum.filter(fn(x) -> (String.length(s) - (String.replace(s, x , "") |> String.length)) >= 4 end)
    |> Enum.count > 0
  end

  # contains at least one letter which repeats with exactly one letter between them
  def second(s) do
    sl = to_char_list s
    second(sl, 0)
  end

  def second([x | [ y | [ z | tail]]], cnt) do
    if (x == z), do: cnt = cnt + 1
    second([y | [ z | tail]], cnt)
  end

  def second(_, count), do: count > 0

end

nice = fn(s) ->
  s = String.strip(s)
  Rules.first(s) && Rules.second(s) 
end

File.stream!("5.input")
|> Enum.filter(nice)
|> Enum.count
|> IO.puts
