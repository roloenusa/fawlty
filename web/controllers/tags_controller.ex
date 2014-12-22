defmodule Fawlty.TagsController do
  use Phoenix.Controller
  alias Fawlty.Repo
  import Ecto.Query

  plug :action

  def show(conn, %{"word" => word}) do
    items = Item.find_all_by_tag_name(word)
    render conn, :show, tag: word, items: items
  end
end
