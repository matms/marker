defmodule MarkerWeb.Library.Bookmark.IndexLive do
  use MarkerWeb, :live_view

  alias Marker.Library
  alias Marker.Library.Bookmark
  alias Marker.Accounts

  alias MarkerWeb.Library.Bookmark.FormComponent

  @impl true
  def mount(_params, %{"user_token" => user_token} = _session, socket) do
    {:ok, socket |> assign_user(user_token) |> assign_bookmarks()}
  end

  defp assign_user(socket, token) do
    assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(token) end)
  end

  defp assign_bookmarks(%{assigns: %{current_user: user}} = socket) do
    assign(socket, :bookmarks, list_bookmarks_by_user(user))
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(%{assigns: %{current_user: user}} = socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Bookmark")
    |> assign(:bookmark, Library.get_bookmark_check_user!(id, user))
  end

  defp apply_action(%{assigns: %{current_user: user}} = socket, :new, _params) do
    socket
    |> assign(:page_title, "New Bookmark")
    |> assign(:bookmark, %Bookmark{user_id: user.id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bookmarks")
    |> assign(:bookmark, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, %{assigns: %{current_user: user}} = socket) do
    bookmark = Library.get_bookmark_check_user!(id, user)
    {:ok, _} = Library.delete_bookmark(bookmark)

    {:noreply, assign(socket, :bookmarks, list_bookmarks_by_user(user))}
  end

  defp list_bookmarks_by_user(user) do
    Library.list_bookmarks_by_user(user)
  end
end
