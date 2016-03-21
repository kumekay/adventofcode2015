Regex.scan(~r/[-\d]+/, File.read!('input.txt'), captures: :first) |>
List.flatten |>
Enum.map(&String.to_integer/1) |>
Enum.sum
