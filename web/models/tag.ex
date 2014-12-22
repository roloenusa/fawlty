defmodule Tag do
  use Ecto.Model
  alias Fawlty.Repo
  import Ecto.Query

  validate tag, word: present()

  # weather is the DB table
  schema "tags" do
    field :word, :string
    field :item_id, :virtual
  end

  def process_tags(description, item_id) do
    Fawlty.Util.parse_tags(description)
      |> Enum.map(fn(word) ->
                     tag = safe_insert(%Tag{word: word})
                     process_tag_map(tag, item_id)
                     tag
                   end)
  end


  defp process_tag_map(%Tag{id: tag_id}, item_id) do
    ItemTagMap.process_map(tag_id, item_id)
  end



  ####
  # Queries

  def safe_insert(%Tag{word: word} = tag) do
    find_by_tag(word)
      |> safe_insert(tag)
  end

  defp safe_insert(%Tag{} = tag, _), do: tag
  defp safe_insert(nil, tag), do: Repo.create(tag)

  def find_by_tag(word) do
    Tag
      |> where([t], t.word == ^word)
      |> Repo.find_single
  end

  @doc """
  finds a list of all items associated with an Tag.
  """
  @spec find_all_items(Tag) :: list(Item)
  def find_all_items(%Tag{id: id}) do
    find_all_item_by_tag_id(id)
  end

  @doc """
  finds a list of all tags associated with an tag_id.
  """
  @spec find_all_item_by_tag_id(pos_integer) :: list(Tag)
  def find_all_item_by_tag_id(tag_id) do
    from(tag in Tag,
         join: map in ItemTagMap, on: tag.id == map.tag_id, # Search the map for the item id.
         inner_join: item in Item, on: item.id == map.item_id,    # based on this join, get all tags by map.tag_id
         select: item,
         where: tag.id == ^tag_id)
    |> Repo.all
  end

  @doc """
  finds a list of all tags associated with an tag_id.
  """
  @spec find_all_items_by_tag_name(bitstring) :: list(Item)
  def find_all_items_by_tag_name(word) do
    from(tag in Tag,
         join: map in ItemTagMap, on: tag.id == map.tag_id, # Search the map for the item id.
         inner_join: item in Item, on: item.id == map.item_id,    # based on this join, get all tags by map.tag_id
         select: item,
         where: tag.word == ^word)
    |> Repo.all
  end
end
