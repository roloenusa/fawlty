defmodule Item do
  use Ecto.Model

  validate item, description: present()

  schema "items" do
    field :description, :string
    field :position, :integer
    field :done, :boolean
    field :updated_at, :datetime
  end
end
