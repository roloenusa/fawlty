defmodule Fawlty.ToDosController do
  use Phoenix.Controller

  plug :action

  def index(conn, _params) do
    to_do_items = Item.find_all_pending
    done_items = Item.find_all_completed

    render conn, :index, to_do_items: to_do_items, done_items: done_items
  end
end
