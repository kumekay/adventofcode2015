s = File.read!('input.txt')  |> String.strip |>
String.replace(~r/{(\[(\[(?2)*]|{(?2)*}|[^][}{])*]|{(?2)*}|[^][}{])*red(?1)*}/,  "")

Regex.scan(~r/[-\d]+/, s , captures: :first) |>
List.flatten |> Enum.map(&String.to_integer/1) |> Enum.sum |> IO.puts
