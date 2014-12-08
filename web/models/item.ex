defmodule Item do
  use Ecto.Model
  alias Fawlty.Repo
  import Ecto.Query

  validate item, description: present()

  schema "items" do
    field :description, :string
    field :position, :integer
    field :done, :boolean
    field :updated_at, :datetime
    field :tags, :virtual
  end

  @doc """
  Create an item and execute any post saving hooks.
  """
  @spec create_item(Item) :: Item | nil
  def create_item(item) do
    do_create_item(item)
      |> after_item_save
  end

  defp do_create_item(item) do
    case Item.validate(item) do
      [] -> Repo.insert(item)
      _  -> nil
    end
  end

  defp after_item_save(nil), do: nil
  defp after_item_save(%Item{description: description, id: id} = item) do
    Tag.process_tags(description, id)
    item
  end


  @doc """
  Delete an item and the related associations by the item_id.
  """
  def delete_item(item_id) do
    item = Repo.get(Item, item_id)
    delete_by_id(item_id)
    ItemTagMap.delete_all_by_item_id(item_id)
    item
  end


  ####
  # Queries

  @doc """
  Get a record by the id Nad preload the associations.
  """
  @spec get(pos_integer) :: Item | nil
  def get(item_id) do
    Item
      |> where([item], item.id == ^item_id)
      |> find_query
      |> Repo.find_single
  end

  @doc """
  Find all items that have not been completed.
  """
  def find_all_pending do
    Item
      |> where([item], item.done == false)
      |> find_query
  end

  @doc """
  Find all items that have been marked as completed.
  """
  def find_all_completed do
    Item
      |> where([item], item.done == true)
      |> find_query
  end

  defp find_query(query) do
    query
      |> order_by([item], asc: item.position)
      |> Repo.all
  end

  defp compile_tag_item_tuples(results) do
    Enum.reduce(results, HashDict.new,
      fn({%Item{id: id} = item, nil}, acc) ->
          Dict.update(acc, id, %Item{item | tags: []}, fn(%Item{tags: tags} = item) -> item  end)
        ({%Item{id: id} = item, tag}, acc) ->
          Dict.update(acc, id, %Item{item | tags: [tag]}, fn(%Item{tags: tags} = item) ->
            %Item{item| tags: [tag | tags]}
          end)
       end)
    |> Dict.values
    |> Enum.sort(fn(i1, i2) -> i1.id <= i2.id end)
  end

  @doc """
  finds a list of all tags associated with an Item.
  """
  @spec find_all_tags(Item) :: list(Tag)
  def find_all_tags(%Item{id: id}) do
    find_all_tags_by_item_id(id)
  end

  @doc """
  finds a list of all tags associated with an item_id.
  """
  @spec find_all_tags_by_item_id(pos_integer) :: list(Tag.t)
  def find_all_tags_by_item_id(item_id) do
    from(item in Item,
         join: map in ItemTagMap, on: item.id == map.item_id, # Search the map for the item id.
         inner_join: tag in Tag, on: tag.id == map.tag_id,    # based on this join, get all tags by map.tag_id
         select: tag,
         where: item.id == ^item_id)
      |> Repo.all
  end

  @doc """
  Delete the item by id from the database.
  Ecto returns the number of records deleted.
  """
  @spec delete_by_id(pos_integer) :: non_neg_integer
  def delete_by_id(item_id) do
    from(item in Item,
         where: item.id == ^item_id)
      |> Repo.delete_all
  end


  @doc """
  finds a list of all tags associated with an item_id.
  """
  def find_all_by_tag_name(word) do
    from(item in Item,
         join: map in ItemTagMap, on: item.id == map.item_id, # Search the map for the item id.
         inner_join: tag in Tag, on: tag.id == map.tag_id,    # based on this join, get all tags by map.tag_id
         select: item,
         where: tag.word == ^word)
      |> Repo.all
  end
end


# @doc """
# Find all items that have been marked as completed.
# """
# def find_all_by_tag_name(tag_name) do
#   from(item in Item,
#        full_join: map in ItemTagMap, on: item.id == map.item_id, # Search the map for the item id.
#        full_join: tag in Tag, on: tag.id == map.tag_id,    # based on this join, get all tags by map.tag_id
#        select: {item, tag},
#        where: tag.word == ^tag_name)
#     |> Repo.all
#     |> compile_tag_item_tuples
# end
