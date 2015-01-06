defmodule Fawlty.Repo.Migrations.AlterUser do
  use Ecto.Migration

  def up do
    [ "ALTER TABLE users \
       ADD COLUMN encrypted_password varchar(100), \
       ADD COLUMN sign_in_count integer, \
       ALTER COLUMN email TYPE varchar(100), \
       ALTER COLUMN name TYPE varchar(100), \
       ALTER COLUMN tag TYPE varchar(20) \
      "
    ]
  end

  def down do
    [ "ALTER TABLE users \
       DROP COLUMN IF EXISTS encrypted_password, \
       DROP COLUMN IF EXISTS sign_in_count \
      "
    ]
  end
end
