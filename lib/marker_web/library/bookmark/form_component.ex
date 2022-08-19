defmodule MarkerWeb.Library.Bookmark.FormComponent do
  use MarkerWeb, :live_component

  alias Marker.Library
  alias Marker.Library.Bookmark

  @impl true
  def update(%{bookmark: bookmark} = assigns, socket) do
    # We use a field `_tag_string` that will be ignored by the changeset in
    # order to store form information.
    changeset = Library.change_bookmark(bookmark, %{_tag_string: create_tag_string(bookmark)})

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
    tags =
      parse_tag_string(bookmark_params)
      |> Enum.map(fn tag -> Library.create_tag_if_new!(tag) end)

    bookmark_params = Map.put(bookmark_params, "tags", tags)

    save_bookmark(socket, socket.assigns.action, bookmark_params)
  end

  defp create_tag_string(%Bookmark{} = bookmark) do
    Enum.map_join(bookmark.tags, ", ", fn tag -> tag.name end)
  end

  # Takes in a tag string provided by the user (e.g. "tag1, tag2, tag3")
  # Returns a list of tag names (e.g. ["tag1", "tag2", "tag3"])
  defp parse_tag_string(bookmark_params) do
    tag_string = bookmark_params["_tag_string"]

    tag_string
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
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
