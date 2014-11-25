defmodule User do
  use Ecto.Model

  # weather is the DB table
  schema "users" do
    field :name, :string
    field :email, :string
    field :tag,   :string
    field :token, :string
  end
end
