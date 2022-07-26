defmodule Marker.Archive.Shiori do
  @moduledoc """
  The Shiori Archival Backend.

  Thiese modules provide support for saving bookmarks using go-shiori
  (https://github.com/go-shiori/shiori)
  """
  use Boundary, exports: [ShioriError, Supervisor]
  alias Marker.Archive.Shiori.{Server, Cache, Protocol}

  @spec archive_url(String.t()) ::
          {:error, Marker.Archive.Shiori.ShioriError.t()} | {:ok, {number, String.t()}}
  @doc """
  Synchronously archives an URL in shiori.

  Note the shiori url might not be the same as the requested URL. For instance,
  archiving `https://hexdocs.pm/elixir/1.12/naming-conventions.html#casing` will
  produce shiori url `https://hexdocs.pm/elixir/1.12/naming-conventions.html`.

  Returns {:error, %ShioriError{}} if the URL is already archived. Note this may
  exhibit somewhat counter-intuitive behaviour since Shiori normalizes URLs.

  Returns {:ok, {shiori_id, shiori_url}} on success.

  Raises on other types of errors, e.g. timeout.

  ## Examples

      iex> archive_url("https://hexdocs.pm/elixir/1.12/library-guidelines.html")
      {:ok, {1, "https://hexdocs.pm/elixir/1.12/library-guidelines.html"}}

      iex> archive_url("https://hexdocs.pm/elixir/1.12/syntax-reference.html#reserved-words")
      # A warning may be logged or printed due to URL normalization.
      {:ok, {2, "https://hexdocs.pm/elixir/1.12/syntax-reference.html"}}

      iex> archive_url("https://hexdocs.pm/elixir/1.12/syntax-reference.html")
      {:error, %ShioriError{...}}
  """
  def archive_url(url) do
    Server.new_archive(url)
  end

  @spec has_archive?(String.t()) :: boolean()
  def has_archive?(url) do
    Cache.has_archive?(url)
  end

  @spec list_archives :: [String.t()]
  def list_archives() do
    Cache.list_archives()
  end

  @spec url_to_shiori_content_url(String.t()) :: String.t()
  def url_to_shiori_content_url(url) do
    Cache.get_archive_shiori_id(url)
    |> Protocol.id_to_shiori_content_url()
  end

  @spec url_to_shiori_archive_url(String.t()) :: String.t()
  def url_to_shiori_archive_url(url) do
    Cache.get_archive_shiori_id(url)
    |> Protocol.id_to_shiori_archive_url()
  end
end
