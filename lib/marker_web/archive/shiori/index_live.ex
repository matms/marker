defmodule MarkerWeb.Archive.Shiori.IndexLive do
  use MarkerWeb, :live_view

  alias Marker.Archive.Shiori

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign_archives()}
  end

  defp assign_archives(socket) do
    # TODO: How to forward connections to shiori (and do so safely)? Maybe need
    # a reverse proxy? Look into
    # https://github.com/tallarium/reverse_proxy_plug/blob/master/README.md

    archives =
      Shiori.list_archives()
      |> Enum.map(fn url ->
        %{
          url: url,
          shiori_content_url: Shiori.url_to_shiori_content_url(url),
          shiori_archive_url: Shiori.url_to_shiori_archive_url(url)
        }
      end)

    socket |> assign(:archives, archives)
  end
end
