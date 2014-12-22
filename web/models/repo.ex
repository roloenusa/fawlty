defmodule Fawlty.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres
  import Ecto.Query

  def conf do
    parse_url "ecto://fawlty:new_password@localhost/fawlty"
  end

  def priv do
    app_dir(:fawlty, "priv/repo")
  end

  def find_single(query) do
    query
      |> limit([q], 1)
      |> all
      |> do_find_single
  end

  defp do_find_single([]), do: nil
  defp do_find_single([m | []]), do: m
  defp do_find_single(_), do: raise "Not a single record"

  def create(record) do
    case apply(record.__struct__, :validate, [record]) do
      nil ->
        {:ok, insert(record)}
      errors ->
        {:error, errors}
    end
  end
end
