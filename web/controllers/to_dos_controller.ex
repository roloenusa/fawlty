defmodule Fawlty.ToDosController do
  use Phoenix.Controller

  import Logger

  plug :authenticate, :user when action in [:index, :items]
  plug :action

  def index(conn, _params) do
    to_do_items = Item.find_all_pending
    done_items = Item.find_all_completed

    render conn, :index, to_do_items: to_do_items, done_items: done_items
  end

  def items(conn, _params) do
    items = Item.find_all

    render conn, response: %{ items: items }
  end

  def toggle(conn, %{"id" => id, "done" => done}) do
    response = Item.update(id, %{done: done})

    render conn, response: %{ success: true }
  end

  defp authenticate(conn, :user) do
    Fawlty.SessionsController.authenticated?(conn)
  end
end
