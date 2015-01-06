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
    field :encrypted_password, :string
    field :sign_in_count, :integer
    field :provider, :virtual
  end

  @doc """
  Create a user and execute any post saving hooks.
  """
  def create(user, password \\ nil) do
    Repo.create(user)
    |> after_save
  end

  def build(name, email, %{provider: provider}) do
    IO.puts "building provider: #{inspect provider}"
    %Fawlty.User{name: name, email: email, provider: provider}
  end
  def build(name, email, opts) do
    IO.puts "building -- #{inspect opts}"
    %Fawlty.User{name: name, email: email}
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

  @doc """
  Get a record by the id Nad preload the associations.
  """
  def get(id) do
    Fawlty.User
      |> Repo.get(id)
  end
end
