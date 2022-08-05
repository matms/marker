defmodule Marker.Library.BookmarkTag do
  @moduledoc """
  Many-to-many association joining Bookmark w/ Tag.

  Indicates that a given bookmark has a given tag.
  """
  use Ecto.Schema
  alias Marker.Library.{Bookmark, Tag}

  schema "bookmark_tags" do
    belongs_to :bookmark, Bookmark
    belongs_to :tag, Tag

    timestamps()
  end
end
