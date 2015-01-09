defmodule Fawlty.ToDoChannel do
  use Phoenix.Channel
  alias Fawlty.Repo
  import Ecto.Query

  def join(socket, "list", _message) do
    {:ok, socket}
  end

  def event(socket, "create:item", %{"item" => params}) do
    item = create_item(params)
    if item do
      {:safe, item_html} = Phoenix.View.render Fawlty.ToDosView, "item.html", item: item
      broadcast socket, "create:item", %{item_html: item_html}
    end
    socket
  end

  def event(socket, "toggle:item", data) do
    item = toggle_item_done_status(data["item_id"])
    if item, do: broadcast(socket, "toggle:item", %{item: item})
    socket
  end

  def event(socket, "delete:item", data) do
    item = delete_item(data["item_id"])
    broadcast socket, "delete:item", %{item: item}
    socket
  end

  def event(socket, "update:item", %{"item_id" => item_id, "item" => params}) do
    item = update_item(item_id, params)
    if item, do: broadcast(socket, "update:item", %{item: item})
    socket
  end

  def event(socket, "arrange:items", data) do
    update_positions(data["item_ids"])
    broadcast socket, "arrange:items", %{item_ids: data["item_ids"], for_list: data["for_list"]}
    socket
  end

  defp create_item(params) do
    item = Map.merge(%Item{done: false}, Fawlty.Util.atomize_keys(params))
    Item.create_item(item)
  end

  defp update_positions(item_ids) do
    item_ids = String.split(item_ids, ",")
                      |> Enum.map fn item_id -> String.to_integer(item_id) end

    items = Repo.all(Item |> where([item], item.id in array(^item_ids, :integer)))
    item_hash = Enum.reduce items, %{}, fn item, map -> Map.put(map, item.id, item) end

    item_ids
      |> Stream.with_index
      |> Enum.each fn {item_id, index} ->
        item = item_hash[item_id]
        Repo.update(%{item | position: index + 1})
      end
  end

  defp toggle_item_done_status(item_id) do
    case Repo.get(Item, String.to_integer(item_id)) do
      item when is_map(item) ->
        item = %{item | done: !item.done}
        Repo.update(item)
        item
      _ ->
        nil
    end
  end

  defp update_item(item_id, params) do
    Item.update(String.to_integer(item_id), Fawlty.Util.atomize_keys(params))
  end

  defp delete_item(item_id) do
    String.to_integer(item_id)
      |> Item.delete_item
  end
end
