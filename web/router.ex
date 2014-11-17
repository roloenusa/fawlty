defmodule Fawlty.Router do
  use Phoenix.Router
  use Phoenix.Router.Socket, mount: "/ws"

  scope "/" do
    # Use the default browser stack.
    pipe_through :browser

    # get "/", Fawlty.PageController, :index, as: :pages

    get "/", RealTimeToDo.ToDosController, :index, as: :root
    channel "to_dos", RealTimeToDo.ToDoChannel
  end

  # Other scopes may use custom stacks.
  # scope "/api" do
  #   pipe_through :api
  # end
end
