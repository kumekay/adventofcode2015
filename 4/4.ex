defmodule Force do
  def brute(input, zeros), do: brute(input, 0, false, String.duplicate("0", zeros))
  def brute(input, i, false, pat) do
    valid = :crypto.hash(:md5, [input, to_string(i)]) |> Base.encode16 |> String.starts_with?(pat)
    brute(input, (if (valid), do: i, else: i+1), valid, pat)
  end
  def brute(_, i, true, _), do: i
end
