defmodule Fawlty.UsersController do
  use Phoenix.Controller
  alias Fawlty.Repo
  import Ecto.Query

  plug :action

  def index(conn, _params) do
    users = Repo.all(User)
    render conn, "index", users: users
  end

  def create(conn, params) do

    user = Map.merge(%User{}, Fawlty.Util.atomize_keys(params))
    case User.validate(user) do
      [] ->
        Repo.insert(user)
      _ ->
        nil
    end

    redirect conn, Fawlty.Router.Helpers.users_path(:index)
  end
end
