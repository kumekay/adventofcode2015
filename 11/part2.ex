defmodule Password do
    @abc Stream.iterate('abc', fn([a , b , c]) -> [ a + 1, b + 1, c + 1] end) |> Enum.take(24) |> Enum.map(&to_string/1)
    @iol ["i", "o", "l"]
    @aa Stream.iterate('aa', fn([a , _]) -> [ a + 1, a + 1] end) |> Enum.take(26) |> Enum.map(&to_string/1)

    def good?(password) do
        (!String.contains?(password, @iol)) &&
        String.contains?(password, @abc) &&
        ((String.length(password) -
         (Enum.reduce(@aa, password, fn(pattern, password) -> String.replace(password, pattern, "__") end) |> String.replace("__", "") |> String.length)) >= 4)
    end

    def next_string(password) do
        password |> String.reverse |> to_char_list |> next |> to_string |> String.reverse
    end

    def next([ ?z | t]) do
        [ ?a | next(t)]
    end

    def next([h | t]) do
        [ h + 1 | t ]
    end

    def next_good(password) do
        next_password = next_string(password)
        if good?(next_password) do
        next_password
          else
          next_good(next_password)
end
    end

end

File.read!("input.txt") |> Password.next_good |> Password.next_good |> IO.puts
