defmodule Marker.Page.Favicon do
  @moduledoc """
  Functionality related to favicons.
  """
  @spec favicon_url(String.t() | URI.t()) :: String.t() | nil
  def favicon_url(url) do
    if cfg_dyn_fetch_favicons() do
      case URI.new(url) do
        {:ok, %URI{host: host}} when is_binary(host) and host != "" ->
          favicon_url_from_host(host, cfg_dyn_favicon_service())

        _ ->
          nil
      end
    else
      nil
    end
  end

  defp favicon_url_from_host(host, :icons_duckduckgo) do
    "https://icons.duckduckgo.com/ip3/#{host}.ico"
  end

  defp favicon_url_from_host(_, _) do
    nil
  end

  def cfg_dyn_fetch_favicons do
    Application.get_env(:marker, Marker.Page.Favicon)[:dyn_fetch_favicons]
  end

  def cfg_dyn_favicon_service do
    Application.get_env(:marker, Marker.Page.Favicon)[:dyn_favicon_service]
  end
end
