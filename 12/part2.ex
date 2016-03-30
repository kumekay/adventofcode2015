defmodule ElfJson do

  def parse([]), do: []

  def parse(arr) do
      {nt, s} = parse_string(arr)
      if Enum.any?(s, &(&1 == ?{)) do
        [parse(s) | parse(nt)]
      else
        ss = to_string(s)
        if (Enum.count(s, &(&1 == ?})) == 1) do
          [[ss] | parse(nt)]
        else
          [ ss | parse(nt)]
        end
      end
  end

  def parse_string([h|t]), do:  parse_string([h|t], 0, [])

  def parse_string([123|t], d, []) do
    parse_string( t, d+1, [])
  end

  def parse_string([123|t], 0, s) do
    # IO.puts("Start: Tail: #{[123|t]}  String: #{s}")
    {[123|t], s}
  end

  def parse_string([123|t], d, s) do
    parse_string( t, d+1, s ++ '{')
  end

  def parse_string([?}|t], 1, s) do
    # IO.puts("End d1 : Tail: #{t}  String: #{s}")
    {t, s ++ '}'}
  end

  def parse_string([?}|t], d, s) do
    parse_string( t, d-1, s ++ '}')
  end

  def parse_string([h|t], d, s) do
    parse_string( t, d, s ++ [h])
  end

  def parse_string([], _, s), do:  {[], s}

  def red_filter(arr) do
    if withred?(arr) do
      []
    else
      Enum.map(arr, fn
        (e) when is_binary(e) -> e
        (e) -> red_filter(e)
      end)
    end
  end

  def withred?(arr) do
    Enum.any?(arr, fn
      e when is_binary(e) -> String.contains?(e, "red")
      _ -> false
    end)
  end
end

calc = fn (elf_json) ->
  s = elf_json |>
  String.strip |>
  String.replace(~r/([^:])"red"/,  "") |>
  String.replace(~r/[\"]/,  "") |>
  to_char_list |>
  ElfJson.parse

  IO.puts '---------'
  IO.inspect s

  s2 = s |>
  ElfJson.red_filter
  IO.inspect  s2

  s2 |>
  List.flatten |>
  Enum.map(fn(x) -> Regex.scan(~r/[-\d]+/, x , captures: :first) end) |>
  List.flatten |>
  Enum.map(&String.to_integer/1) |>
  Enum.sum
end

# tests
test = fn(x, e) ->
  IO.puts "--------"
  IO.puts(x)
  r = calc.(x)
  IO.puts("Get #{r}, expected: #{e}")
  r == e
end

test.(~s([1,2,3]), 6) &&
test.(~s([1,{"c":"red","b":2},3]), 4) &&
test.(~s({"d":"red","e":[1,2,3,4],"f":5}), 0) &&
test.(~s([1,"red",5]), 6) &&
test.(~s({"c":"sdf","b":2,"g":{"a":{"a":8,"b":9},"b":9,"qw":{"a":1,"b":200,"k":"red"},"m":[1,2,3,"red"]},"e":2}), 36) &&
test.(~s(["red",["green",165],{"a":"red","c":2324},[["green","blue","red","violet",82,"violet","violet",61,86]]]), 394)

# File.read!('input.txt') |> calc.()
