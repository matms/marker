defmodule MarkerWeb.Library.BookmarkLive.Show do
  use MarkerWeb, :live_view

  alias Marker.Library

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:bookmark, Library.get_bookmark!(id))}
  end

  defp page_title(:show), do: "Show Bookmark"
  defp page_title(:edit), do: "Edit Bookmark"
end
