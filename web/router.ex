defmodule Fawlty.Router do
  use Phoenix.Router
  use Phoenix.Router.Socket, mount: "/ws"

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
  end

  channel "to_dos", Fawlty.ToDoChannel

  scope "/" do
    # Use the default browser stack.
    pipe_through :browser

    get "/", Fawlty.PageController, :index, as: :pages

    # scope "/users" do
      get "/users/profile", Fawlty.UsersController, :profile
      resources "users", Fawlty.UsersController
    # end

    scope "/items", as: :items do
      get "/", Fawlty.ToDosController, :index
      get "/tags/:word", Fawlty.TagsController, :show
    end

    get "/sessions/google_oauth2", Fawlty.SessionsController, :google_oauth2, as: :sessions
    get "/sessions/oauth2callback", Fawlty.SessionsController, :oauth2callback, as: :sessions
    get "/sessions/logout", Fawlty.SessionsController, :logout, as: :sessions
  end

  # Other scopes may use custom stacks.
  # scope "/api" do
  #   pipe_through :api
  # end
end
