use Bitwise
defmodule Assembly do

    def cycle([head | tail]), do: Enum.concat(tail, [head])

    def connect(l)  do
        connect(l, %{})
    end

    def connect([{ i, o } | tail], connections) do
        inum = Integer.parse(i)
        ival = Map.get(connections, i)
        cond do
            is_tuple(inum) ->
                connections = Map.put(connections, o, elem(inum, 0))
                connect(tail, connections)

            not is_nil(ival) ->
                connections = Map.put(connections, o, ival)
                connect(tail, connections)

            true ->
                connect(cycle([{ i, o } | tail]), connections)
        end
    end

    def connect([{ "NOT", i, o } | tail ], connections) do
        inum = Integer.parse(i)
        ival = Map.get(connections, i)
        cond do
            is_tuple(inum) ->
                connections = Map.put(connections, o, 65536 + bnot(elem(inum, 0)))
                connect(tail, connections)

            not is_nil(ival) ->
                connections = Map.put(connections, o, 65536 + bnot(ival))
                connect(tail, connections)

            true ->
                connect(cycle([{ "NOT", i, o }  | tail]), connections)
        end
    end

    def connect([{ i1, op, i2, o } | tail], connections) do

        getval = fn (connections, i) ->
            inum = Integer.parse(i)
            ival = Map.get(connections, i)
            if is_tuple(inum), do: elem(inum, 0), else: ival
        end

        ival1 = getval.(connections, i1)
        ival2 = getval.(connections, i2)

        cond do
            (not is_nil(ival1)) and (not is_nil(ival2)) ->
                connections = Map.put(connections, o, valeval(ival1, op, ival2))
                connect(tail, connections)

            true ->
                connect(cycle([{ i1, op, i2, o } | tail]), connections)
        end
    end

    def connect([], connections), do: connections

    def valeval(i1, "AND", i2), do: i1 &&& i2
    def valeval(i1, "OR", i2), do: i1 ||| i2
    def valeval(i1, "LSHIFT", i2), do: i1 <<< i2
    def valeval(i1, "RSHIFT", i2), do: i1 >>> i2
end

parse = fn(s) ->
  s = String.strip(s)
  (Regex.run( ~r/^(NOT) ([\d\w]+) -> (\w+)/, s, capture: :all_but_first)  || # NOT x -> y
  Regex.run( ~r/^([\d\w]+) -> (\w+)/, s, capture: :all_but_first) || # 123 -> x
  Regex.run( ~r/^([\d\w]+) (LSHIFT|RSHIFT|AND|OR) ([\d\w]+) -> (\w+)/, s, capture: :all_but_first)) # x LSHIFT y -> z
  |> List.to_tuple
end

lines = File.stream!("7.input")
a = Enum.map(lines, parse)
|> Assembly.connect
|> Map.get("a")

Enum.map(lines, parse)
|> Enum.reject(&(List.last(Tuple.to_list(&1)) == "b"))
|> Enum.concat([{to_string(a), "b"}])
|> Assembly.connect
|> Map.get("a")
|> IO.puts
