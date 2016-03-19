lines = File.stream!("input.txt") |> Enum.to_list |> Enum.map( &(String.strip(&1)))

sum1 = lines |> Enum.map( &((String.replace(&1, ~r/([\\"])/, "\\\0") |> String.length) + 2)) |> Enum.sum
sum2 = lines |> Enum.map( &(String.length(&1))) |> Enum.sum

IO.puts(sum1 - sum2)
