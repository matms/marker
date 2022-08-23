defmodule MarkerWeb.Library.Bookmark.ShowLive do
  use MarkerWeb, :live_view

  alias Marker.Library
  alias Marker.Accounts

  alias MarkerWeb.Library.Bookmark.FormComponent

  @impl true
  def mount(_params, %{"user_token" => user_token} = _session, socket) do
    {:ok, socket |> assign_user(user_token)}
  end

  defp assign_user(socket, token) do
    assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(token) end)
  end

  @impl true
  def handle_params(%{"id" => id}, _, %{assigns: %{current_user: user}} = socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:bookmark, Library.get_bookmark_check_user!(id, user) |> Library.preload_tags())}
  end

  defp page_title(:show), do: "Show Bookmark"
  defp page_title(:edit), do: "Edit Bookmark"
end
