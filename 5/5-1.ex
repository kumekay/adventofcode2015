nice = fn(s) ->
  s = String.strip(s)
  sl =  to_char_list(s)
  # 3 of aeiou
  ( String.replace(s , ~r/[^aeiou]/, "") |> String.length >= 3) &&

  # doubles
  (Enum.count(sl) > Enum.dedup(sl) |> Enum.count) &&

  # ! ["ab", "cd", "pq", "xy"]
  ! String.contains?(s, ["ab","cd","pq","xy"])
end

File.stream!("5.input")
|> Enum.filter(nice)
|> Enum.count
|> IO.puts
