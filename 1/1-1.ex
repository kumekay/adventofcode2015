{:ok, body} = File.read('1.input')
body_chars = to_char_list body

defmodule RightFloor do
  def calc(40, acc), do: acc + 1
  def calc(41, acc), do: acc - 1
  def calc(_, acc), do: acc
end

IO.puts Enum.reduce(body_chars, 0, &RightFloor.calc/2)
