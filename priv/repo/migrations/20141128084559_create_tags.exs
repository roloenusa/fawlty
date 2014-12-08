defmodule Fawlty.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def up do
    [ "CREATE TABLE IF NOT EXISTS tags( \
        id serial primary key, \
        word varchar(20) UNIQUE NOT NULL\
      )",

      "CREATE INDEX lower_tag_idx ON tags ((lower(word)))"
    ]
  end

  def down do
    [ "DROP TABLE tags" ]
  end
end
