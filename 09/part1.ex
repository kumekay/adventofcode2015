distances = File.stream!("input.txt") |>
Enum.map( fn(x) -> x |> String.strip |> String.split(" ") end) |>
Enum.map( fn([p1, _, p2, _, l]) ->
    l = String.to_integer(l)
    [{ {p1, p2}, l }, {{p2, p1}, l}]
end) |>
List.flatten |> Map.new

places = distances |> Map.keys |> Enum.map( &(elem(&1, 0))) |> MapSet.new |> MapSet.to_list

defmodule Ways do
    def cycles(l) do
       cycles(l, length(l) , [])
    end

    def cycles(_, 0, all) do
       all
    end

    def cycles([head | tail], i, all) do
        nl = tail ++ [head]
        cycles(nl, i-1, all ++ [nl])
    end

    def find(l), do: sub(cycles(l))

    def subfind([le]), do: [le]

    def subfind([he | te]) do
        sub(cycles(te)) |> Enum.map(&([he | List.wrap(&1)] ))
    end

    def sub([ h | t ]) do
        subfind(h) ++ sub(t)
    end

    def sub([]), do: []


    def way_distance( [f | [ s| o ]], distances, acc) do
            way_distance( [s | o], distances, (distances |> Map.get({f, s})) + acc )
    end

    def way_distance([_], _, acc), do: acc
end


ways = Ways.find(places)

ways |> Enum.map(&(Ways.way_distance(&1, distances, 0))) |> Enum.min |> IO.puts