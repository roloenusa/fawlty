defmodule Fawlty.Repo.Migrations.CreateItemTagMap do
  use Ecto.Migration

  def up do
    [ "CREATE TABLE IF NOT EXISTS item_tag_map( \
        id serial primary key, \
        tag_id integer NOT NULL, \
        item_id integer NOT NULL, \
        UNIQUE (tag_id, item_id)
      )",

      "CREATE INDEX item_tag_map_idx ON item_tag_map (item_id, tag_id)",
      "CREATE INDEX tag_item_map_idx ON item_tag_map (tag_id, item_id)"
    ]
  end

  def down do
    [ "DROP TABLE item_tag_map" ]
  end
end
