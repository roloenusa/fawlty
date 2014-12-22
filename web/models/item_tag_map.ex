defmodule ItemTagMap do
  use Ecto.Model
  alias Fawlty.Repo
  import Ecto.Query

  validate item_tag_map, item_id: present()
  validate item_tag_map, tag_id: present()

  # weather is the DB table
  schema "item_tag_map" do
    field :item_id, :integer
    field :tag_id, :integer
  end

  def get_all_maps_by_item_id(item_id) do
    ItemTagMap
      |> where([map], map.item_id == ^item_id)
      |> Repo.all
  end

  def process_map(tag_id, item_id) do
    %ItemTagMap{tag_id: tag_id, item_id: item_id}
      |> safe_insert
  end


  ####
  # Queries

  def safe_insert(%ItemTagMap{tag_id: tag_id, item_id: item_id} = map) do
    find_by_tag_id_and_item_id(tag_id, item_id)
      |> safe_insert(map)
  end

  defp safe_insert(%ItemTagMap{} = map, _), do: map
  defp safe_insert(nil, map), do: Repo.create(map)

  def find_by_tag_id_and_item_id(tag_id, item_id) do
    ItemTagMap
      |> where([t], t.tag_id == ^tag_id)
      |> where([t], t.item_id == ^item_id)
      |> Repo.find_single
  end

  @doc """
  Delete the mapping by the item_id from the database.
  Ecto returns the number of records deleted.
  """
  @spec delete_all_by_item_id(pos_integer) :: non_neg_integer
  def delete_all_by_item_id(item_id) do
    from(map in ItemTagMap,
         where: map.item_id == ^item_id)
      |> Repo.delete_all
  end
end
