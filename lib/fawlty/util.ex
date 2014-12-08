defmodule Fawlty.Util do

  def atomize_keys(struct) do
    Enum.reduce struct, %{}, fn({k, v}, map) -> Map.put(map, String.to_existing_atom(k), v) end
  end

  def parse_tags(string) do
    ~r/(?<=^|\s)((#|@)\w+)/
      |> Regex.scan(string)
      |> Enum.map(fn(words) ->
                    List.first(words)
                      |>String.lstrip(?#)
                      |>String.downcase
                  end)
      |> Enum.uniq
  end
end
