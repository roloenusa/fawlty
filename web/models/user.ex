defmodule User do
  use Ecto.Model

  validate user, name: present()
  validate user, email: present()

  # weather is the DB table
  schema "users" do
    field :name, :string
    field :email, :string
    field :tag,   :string
    field :token, :string
  end
end
