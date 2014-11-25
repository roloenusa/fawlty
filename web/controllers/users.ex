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
    redirect conn, Fawlty.Router.Helpers.users_path(:index)
  end
end
