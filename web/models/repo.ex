defmodule Fawlty.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do
    parse_url "ecto://fawlty:new_password@localhost/fawlty"
  end

  def priv do
    app_dir(:fawlty, "priv/repo")
  end
end
