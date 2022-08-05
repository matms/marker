defmodule Marker.Library.Bookmark.Query do
  import Ecto.Query
  alias Marker.Library.Bookmark

  def base, do: Bookmark

  def from_user(query \\ base(), user) do
    query
    |> where([b], b.user_id == ^user.id)
  end

  def with_url(query \\ base(), url) do
    query
    |> where([b], b.url == ^url)
  end

  def preload_tags(query \\ base()) do
    query
    |> preload(:tags)
  end
end
