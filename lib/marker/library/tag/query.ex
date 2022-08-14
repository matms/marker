defmodule Marker.Library.Tag.Query do
  import Ecto.Query
  alias Marker.Library.Tag

  def base, do: Tag

  def with_normalized_name(query \\ base(), normalized_name) do
    query
    |> where([t], t.normalized_name == ^normalized_name)
  end
end
