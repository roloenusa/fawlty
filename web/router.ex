defmodule Fawlty.Router do
  use Phoenix.Router
  use Phoenix.Router.Socket, mount: "/ws"

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
  end

  channel "to_dos", Fawlty.ToDoChannel
  channel "publica", Fawlty.PublicaChannel

  scope "/" do
    # Use the default browser stack.
    pipe_through :browser

    get "/", Fawlty.PageController, :index, as: :pages

    # scope "/users" do
      get "/users/profile", Fawlty.UsersController, :profile
      get "/users/publica", Fawlty.UsersController, :publica
      resources "users", Fawlty.UsersController
    # end

    resources "/items", Fawlty.ItemsController
    resources "/tags", Fawlty.TagsController

    get "/sessions/google_oauth2", Fawlty.SessionsController, :google_oauth2, as: :sessions
    get "/sessions/oauth2callback", Fawlty.SessionsController, :oauth2callback, as: :sessions
    get "/sessions/logout", Fawlty.SessionsController, :logout, as: :sessions
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Fawlty do
    pipe_through :api

    get "/items", ItemsController, :items
  end
end
