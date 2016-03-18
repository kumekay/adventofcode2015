File.stream!("input.txt")
|> Enum.map( fn(x) ->
    s = String.strip(x)
    String.length(s) - (String.strip(s, ?") |> Macro.unescape_string |> String.length)
end)
|> Enum.sum
|> IO.puts
