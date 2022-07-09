defmodule Marker.LibraryTest do
  use Marker.DataCase

  alias Marker.Library

  describe "bookmarks" do
    alias Marker.Library.Bookmark

    import Marker.LibraryFixtures

    @invalid_attrs %{title: nil, url: nil}

    test "list_bookmarks/0 returns all bookmarks" do
      bookmark = bookmark_fixture()
      assert Library.list_bookmarks() == [bookmark]
    end

    test "list_bookmarks_by_user/1 returns all bookmarks for some user" do
      %{id: id1} = user1 = Marker.AccountsFixtures.user_fixture(email: "a@test")
      %{id: id2} = Marker.AccountsFixtures.user_fixture(email: "b@test")

      bookmark = bookmark_fixture(%{user_id: id1})
      bookmark2 = bookmark_fixture(%{user_id: id1})
      _bookmark3 = bookmark_fixture(%{user_id: id2})
      assert Enum.sort(Library.list_bookmarks_by_user(user1)) == Enum.sort([bookmark, bookmark2])
    end

    test "get_bookmark!/1 returns the bookmark with given id" do
      bookmark = bookmark_fixture()
      assert Library.get_bookmark!(bookmark.id) == bookmark
    end

    test "create_bookmark/1 with valid data creates a bookmark" do
      valid_attrs = %{
        title: "some title",
        url: "some url",
        user_id: Marker.AccountsFixtures.user_fixture().id
      }

      assert {:ok, %Bookmark{} = bookmark} = Library.create_bookmark(valid_attrs)
      assert bookmark.title == "some title"
      assert bookmark.url == "some url"
    end

    test "create_bookmark/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Library.create_bookmark(@invalid_attrs)
    end

    test "update_bookmark/2 with valid data updates the bookmark" do
      bookmark = bookmark_fixture()
      update_attrs = %{title: "some updated title", url: "some updated url"}

      assert {:ok, %Bookmark{} = bookmark} = Library.update_bookmark(bookmark, update_attrs)
      assert bookmark.title == "some updated title"
      assert bookmark.url == "some updated url"
    end

    test "update_bookmark/2 with invalid data returns error changeset" do
      bookmark = bookmark_fixture()
      assert {:error, %Ecto.Changeset{}} = Library.update_bookmark(bookmark, @invalid_attrs)
      assert bookmark == Library.get_bookmark!(bookmark.id)
    end

    test "delete_bookmark/1 deletes the bookmark" do
      bookmark = bookmark_fixture()
      assert {:ok, %Bookmark{}} = Library.delete_bookmark(bookmark)
      assert_raise Ecto.NoResultsError, fn -> Library.get_bookmark!(bookmark.id) end
    end

    test "change_bookmark/1 returns a bookmark changeset" do
      bookmark = bookmark_fixture()
      assert %Ecto.Changeset{} = Library.change_bookmark(bookmark)
    end
  end
end
