defmodule Marker.Archive.Shiori.Protocol do
  @moduledoc """
  Represents the protocol used to communicate with the Shiori API.
  """
  require Logger
  alias Marker.Archive.Shiori.ShioriError

  @doc """
  Logs into to the Shiori backend server.

  Returns a session string if successful. Raises on failure.
  """
  def shiori_login! do
    resp =
      HTTPoison.post!(
        "#{shiori_address()}/api/login",
        Jason.encode!(%{
          "username" => shiori_username(),
          "password" => shiori_password(),
          "remember" => true,
          "owner" => true
        }),
        [{"Accept", "application/json"}]
      )

    if resp.status_code == 500 do
      Logger.error("Failed to login to shiori - code 500 - HTML response: #{inspect(resp)}")
      raise ShioriError.failed_login()
    end

    session = Jason.decode!(resp.body)["session"]

    session
  end

  @doc """
  Fetches all bookmarks using the Shiori API.

  Note: It is unsafe to call this function concurrently with making any
  changes to the Shiori backend.

  Returns a list of shiori bookmarks.
  """
  @spec all_bookmarks!(String.t()) :: [
          %{url: String.t(), shiori_id: integer(), shiori_bookmark_raw: term()}
        ]
  def all_bookmarks!(session) do
    all_bookmarks_raw!(session)
    |> Enum.map(fn %{
                     "url" => url,
                     "id" => sid,
                     "hasArchive" => has_archive,
                     "hasContent" => has_content
                   } = _raw ->
      # Logger.info("Loaded shiori bookmark into cache: #{url}")

      if not has_archive do
        # Logger.warn("hasArchive is false for #{url}")
      end

      if not has_content do
        # Logger.warn("Warning: hasContent is false for #{url}")
      end

      %{url: url, shiori_id: sid}
    end)
  end

  @spec id_to_shiori_content_url(number) :: String.t()
  def id_to_shiori_content_url(id) when is_number(id) do
    "#{shiori_address()}/bookmark/#{id}/content"
  end

  @spec id_to_shiori_archive_url(number) :: String.t()
  def id_to_shiori_archive_url(id) when is_number(id) do
    "#{shiori_address()}/bookmark/#{id}/archive"
  end

  defp all_bookmarks_raw!(session) do
    resp = HTTPoison.get!(shiori_api_bookmark_url_page(1), session_header(session))

    %{"maxPage" => max_page} = first_page = Jason.decode!(resp.body)

    all_pages =
      [first_page] ++
        Enum.map(
          2..max_page//1,
          fn page_num ->
            resp = HTTPoison.get!(shiori_api_bookmark_url_page(page_num), session_header(session))

            Jason.decode!(resp.body)
          end
        )

    all_bookmarks = Enum.flat_map(all_pages, fn page -> page["bookmarks"] end)

    all_bookmarks
  end

  defp shiori_api_bookmark_url_page(page_num) do
    "#{shiori_address()}/api/bookmarks?page=#{page_num}"
  end

  @spec shiori_add_new(any, any) ::
          {:error, Marker.Archive.Shiori.ShioriError.t()}
          | {:ok, {shiori_id :: number(), shiori_url :: String.t()}}
  def shiori_add_new(session, url) do
    addr = "#{shiori_address()}/api/bookmarks"
    body = Jason.encode!(%{"url" => url, "createArchive" => true, "public" => 1})
    head = session_header(session)

    resp = HTTPoison.post!(addr, body, head)

    if String.starts_with?(
         resp.body,
         "failed to save bookmark: constraint failed: UNIQUE constraint failed"
       ) do
      {:error, ShioriError.unique_constraint_failed()}
    else
      json = Jason.decode!(resp.body)
      shiori_id = json["id"]
      shiori_url = json["url"]

      # Note that it is possible for shiori_url != url. This is because
      # shiori "normalizes" URLs.
      {:ok, {shiori_id, shiori_url}}
    end
  end

  defp session_header(session) do
    [{"X-Session-Id", session}]
  end

  defp shiori_address do
    Application.get_env(:marker, Marker.Archive.Shiori)[:address]
  end

  defp shiori_username do
    Application.get_env(:marker, Marker.Archive.Shiori)[:username]
  end

  defp shiori_password do
    Application.get_env(:marker, Marker.Archive.Shiori)[:password]
  end
end
