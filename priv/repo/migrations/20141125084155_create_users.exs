defmodule Fawlty.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    [ "CREATE TABLE IF NOT EXISTS users( \
        id serial primary key, \
        name character(20), \
        email character(100), \
        tag character(4), \
        token text \
      )"
    ]
  end

  def down do
    "DROP TABLE users"
  end
end
