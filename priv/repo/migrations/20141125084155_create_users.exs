defmodule Fawlty.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    [ "CREATE TABLE IF NOT EXISTS users( \
        id serial primary key, \
        name character(100), \
        email character(100) UNIQUE, \
        tag character(20) UNIQUE, \
        token text \
      )",

      "CREATE INDEX name_idx ON users (name)",
      "CREATE INDEX email_idx ON users (email)",
      "CREATE INDEX tag_idx ON users (tag)"
    ]
  end

  def down do
    "DROP TABLE users"
  end
end
