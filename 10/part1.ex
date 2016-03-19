parse = fn
    (x) -> x |>
        String.replace("111", "eq") |>
        String.replace("222", "ew") |>
        String.replace("333", "ee") |>
        String.replace("11", "wq") |>
        String.replace("22", "ww") |>
        String.replace("33", "we") |>
        String.replace("1", "qq") |>
        String.replace("2", "qw") |>
        String.replace("3", "qe") |>
        String.replace("q", "1") |>
        String.replace("w", "2") |>
        String.replace("e", "3")
end

File.read!("input.txt") |> Stream.iterate(parse) |> Enum.at(40) |> String.length |> IO.puts
