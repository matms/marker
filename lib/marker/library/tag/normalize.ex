defmodule Marker.Library.Tag.Normalize do
  @doc """
  Normalizes a tag name.
  """
  def normalized(string) do
    string
    |> String.normalize(:nfkc)
    |> String.trim()
    |> String.downcase()
    |> String.replace(~r/\s+|\-|\_/, "")
  end
end
