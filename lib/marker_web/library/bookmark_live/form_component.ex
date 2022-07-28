defmodule MarkerWeb.Library.BookmarkLive.FormComponent do
  use MarkerWeb, :live_component

  alias Marker.Library

  @impl true
  def update(%{bookmark: bookmark} = assigns, socket) do
    changeset = Library.change_bookmark(bookmark)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"bookmark" => bookmark_params}, socket) do
    changeset =
      socket.assigns.bookmark
      |> Library.change_bookmark(bookmark_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"bookmark" => bookmark_params}, socket) do
    save_bookmark(socket, socket.assigns.action, bookmark_params)
  end

  defp save_bookmark(socket, :edit, bookmark_params) do
    case Library.update_bookmark(socket.assigns.bookmark, bookmark_params) do
      {:ok, _bookmark} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bookmark updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_bookmark(socket, :new, bookmark_params) do
    case Library.create_bookmark(bookmark_params) do
      {:ok, _bookmark} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bookmark created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
