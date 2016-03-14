{:ok, body} = File.read('1.input')
body_chars = to_char_list body

defmodule RightFloor do
  def level([40 | tail ], i, floor) when floor >= 0 do
     level tail, i + 1, floor + 1
   end

  def level([41 | tail ], i, floor) when floor >= 0 do
     level tail, i + 1, floor - 1
   end

  def level(_, i, _ ), do: IO.puts(i)
end

RightFloor.level body_chars, 0, 0
