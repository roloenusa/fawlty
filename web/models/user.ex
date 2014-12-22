defmodule Fawlty.User do
  use Ecto.Model
  alias Fawlty.Repo
  import Ecto.Query

  validate user, name: present()
  validate user, email: present()

  # weather is the DB table
  schema "users" do
    field :name, :string
    field :email, :string
    field :tag,   :string
    field :token, :string
  end

  @doc """
  Create a user and execute any post saving hooks.
  """
  def create(user) do
    Repo.create(user)
      |> after_save
  end

  defp after_save({:ok, record}), do: record
  defp after_save({:error, errors}), do: nil

  ####
  # Queries

  @doc """
  Get a record by the id Nad preload the associations.
  """
  def find_by_email(email) do
    Fawlty.User
      |> where([user], user.email == ^email)
      |> Repo.find_single
  end
end
