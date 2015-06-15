defmodule Fawlty.ItemsView do
  use Fawlty.View

  def render("items.json", %{items: item}) do
    item
  end
end
