defmodule Marker.LibraryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Marker.Library` context.
  """

  @doc """
  Generate a bookmark.
  """
  def bookmark_fixture(attrs \\ %{}) do
    {:ok, bookmark} =
      attrs
      |> Enum.into(%{
        title: "some title",
        url: "some url",
        user_id: Marker.AccountsFixtures.user_fixture().id
      })
      |> Marker.Library.create_bookmark()

    bookmark
  end
end
