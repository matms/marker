defmodule Marker.Page do
  @moduledoc """
  Functionality related to a webpage.
  """
  use Boundary

  alias Marker.Page.Favicon

  @doc """
  Given an URL, returns an URL that may be used to serve its favicon.

  Note this may be a third party URL.

  ## Examples

      iex> Marker.Page.favicon_url("https://github.com")
      "https://icons.duckduckgo.com/ip3/github.com.ico"

      iex> Marker.Page.favicon_url("invalidUrl")
      nil
  """
  @spec favicon_url(String.t() | URI.t()) :: String.t() | nil
  defdelegate favicon_url(url), to: Favicon
end
