defmodule Fawlty.UsersController do
  use Phoenix.Controller
  alias Fawlty.Repo
  alias Fawlty.User
  import Ecto.Query

  @type conn   :: %Plug.Conn{}
  @type params :: map

  plug :authenticate, :user when action in [:index, :profile]
  plug :action

  def index(conn, _params) do
    users = Repo.all(User)
    render conn, :index, users: users
  end

  def profile(conn, _params) do
    user = Fawlty.Devise.signed_user(conn)
    render conn, :show, user: user
  end

  def create(conn, params) do
    user = Map.merge(%User{}, Fawlty.Util.atomize_keys(params))
    Fawlty.Repo.create(user)
    redirect(conn, to: Fawlty.Router.Helpers.users_path(:index))
  end

  def update(conn, %{"_method" => "PATCH", "user" => params}) do
    user = Fawlty.Devise.signed_user(conn)
    user = Map.merge(user, Fawlty.Util.atomize_keys(params))
    :ok = Repo.update(user)
    redirect(conn, to: Fawlty.Router.Helpers.users_path(:profile))
  end

  def publica(conn, params) do
    render conn, :publica, scripts: ["hello", "world"]
  end

  @spec authenticate(conn, :user) :: conn
  defp authenticate(conn, :user) do
    Fawlty.SessionsController.authenticated?(conn)
  end
end
