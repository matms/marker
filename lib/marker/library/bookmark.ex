defmodule Marker.Library.Bookmark do
  @moduledoc """
  A Bookmark entry.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Marker.Accounts.User
  alias Marker.Library.{BookmarkTag, Tag}

  @type t() :: %__MODULE__{
          id: integer(),
          title: String.t(),
          url: String.t(),
          user: User.t(),
          user_id: integer(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "bookmarks" do
    field :title, :string
    field :url, :string
    belongs_to :user, User
    many_to_many :tags, Tag, join_through: BookmarkTag

    timestamps()
  end

  @required_fields ~w(title url user_id)a

  @doc """
  Changeset for a bookmark.

  ## Attributes

  Required: `:title`, `:url`, `:user_id`.

  Optional: `:tags`.

  If present, `:tags` should be a list of %Library.Tag{} structs. All these
  structs must already exist in the Repo. The bookmark will be created or
  updated so as to have ONLY the tags in this list.

  (If `:tags` does not exist or is nil, then no modification will be made to
  the bookmark's tags.)
  """
  def changeset(bookmark, attrs) do
    bookmark
    |> cast(attrs, @required_fields)
    |> maybe_put_tags(attrs)
    |> validate_required(@required_fields)
    |> validate_url()
    |> unsafe_validate_unique([:url], Marker.Repo)
  end

  # Note that passing nil means don't make a change, whereas passing the empty
  # list means clear out all tags.
  defp maybe_put_tags(changeset, attrs) do
    if Map.has_key?(attrs, :tags) && attrs[:tags] != nil do
      changeset
      |> put_assoc(:tags, attrs[:tags])
    else
      changeset
    end
  end

  defp validate_url(changeset) do
    changeset
    |> validate_format(:url, ~r/^https?:\/\//, message: "Must start with http:// or https://")
  end
end
