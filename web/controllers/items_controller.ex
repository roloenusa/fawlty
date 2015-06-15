defmodule Fawlty.ItemsController do
  use Phoenix.Controller

  plug :authenticate, :user when action in [:index]
  plug :action

  def index(conn, _params) do
    to_do_items = Item.find_all_pending
    done_items = Item.find_all_completed

    render conn, :index, to_do_items: to_do_items, done_items: done_items
  end

  defp authenticate(conn, :user) do
    Fawlty.SessionsController.authenticated?(conn)
  end

  def items(conn, _params) do
    render conn, items: %{hola: "hello", mundo: "world"}
  end
end
