defmodule Marker.Library.Tag do
  @moduledoc """
  A tag. Has a name and a normalized name.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Marker.Library.Tag.Normalize

  alias Marker.Library.{Bookmark, BookmarkTag}

  schema "tags" do
    field :name, :string
    field :normalized_name, :string

    # No corresponding cast_assoc since we don't plan to edit bookmarks
    # _through_ tags.
    many_to_many :bookmarks, Bookmark, join_through: BookmarkTag

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_name()
    |> normalize_name()
    |> validate_normalized_name()
  end

  defp validate_name(changeset) do
    changeset
    |> validate_required([:name])
  end

  defp normalize_name(changeset) do
    name = get_change(changeset, :name)

    if name && changeset.valid? do
      put_change(changeset, :normalized_name, normalized(name))
    else
      changeset
    end
  end

  defp validate_normalized_name(changeset) do
    changeset
    |> validate_required([:normalized_name])
  end
end
