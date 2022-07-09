defmodule Marker.Library.Bookmark.Query do
  import Ecto.Query
  alias Marker.Library.Bookmark

  def base, do: Bookmark

  def from_user(query \\ base(), user) do
    query
    |> where([b], b.user_id == ^user.id)
  end
end
