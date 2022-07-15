defmodule Marker.Library.Bookmark do
  @moduledoc """
  A Bookmark entry.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Marker.Accounts.User

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

    timestamps()
  end

  @required_fields ~w(title url user_id)a

  @doc false
  def changeset(bookmark, attrs) do
    bookmark
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_url()
    |> unsafe_validate_unique([:url], Marker.Repo)
  end

  defp validate_url(changeset) do
    changeset
    |> validate_format(:url, ~r/^https?:\/\//, message: "Must start with http:// or https://")
  end
end
