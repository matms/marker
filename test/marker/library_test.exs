defmodule Marker.LibraryTest do
  @moduledoc false

  use Marker.DataCase

  alias Marker.Library
  alias Marker.Library.Bookmark

  import Marker.LibraryFixtures

  describe "bookmarks" do
    @invalid_attrs %{title: nil, url: nil}

    test "list_bookmarks/0 returns all bookmarks" do
      bookmark = bookmark_fixture()
      assert Library.list_bookmarks() == [bookmark]
    end

    test "list_bookmarks_by_user/1 returns all bookmarks for some user" do
      %{id: id1} = user1 = Marker.AccountsFixtures.user_fixture(email: "a@test")
      %{id: id2} = Marker.AccountsFixtures.user_fixture(email: "b@test")

      bookmark = bookmark_fixture(%{url: "https://www.example.net/1", user_id: id1})
      bookmark2 = bookmark_fixture(%{url: "https://www.example.net/2", user_id: id1})
      _bookmark3 = bookmark_fixture(%{url: "https://www.example.net/3", user_id: id2})
      assert Enum.sort(Library.list_bookmarks_by_user(user1)) == Enum.sort([bookmark, bookmark2])
    end

    test "get_bookmark!/2 returns the bookmark with given id" do
      bookmark = bookmark_fixture()
      assert Library.get_bookmark!(bookmark.id) == bookmark
    end

    test "get_bookmark_check_user!/1 returns the bookmark with given id if user matches" do
      bookmark = bookmark_fixture()
      user = load_user_with_id(bookmark.user_id)
      assert Library.get_bookmark_check_user!(bookmark.id, user) == bookmark
    end

    test "get_bookmark_check_user!/1 raises Ecto.NoResultsError if user doesn't matches" do
      bookmark = bookmark_fixture()
      user = load_user_with_id(bookmark.user_id)
      bad_user = %{user | id: user.id + 1}

      assert_raise Ecto.NoResultsError, fn ->
        Library.get_bookmark_check_user!(bookmark.id, bad_user)
      end
    end

    test "create_bookmark/1 with valid data creates a bookmark" do
      valid_attrs = %{
        title: "some title",
        url: "https://www.example.com",
        user_id: Marker.AccountsFixtures.user_fixture().id
      }

      assert {:ok, %Bookmark{} = bookmark} = Library.create_bookmark(valid_attrs)
      assert bookmark.title == "some title"
      assert bookmark.url == "https://www.example.com"
    end

    test "create_bookmark/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Library.create_bookmark(@invalid_attrs)
    end

    test "update_bookmark/2 with valid data updates the bookmark" do
      bookmark = bookmark_fixture()
      update_attrs = %{title: "some updated title", url: "https://www.example.com/2"}

      assert {:ok, %Bookmark{} = bookmark} = Library.update_bookmark(bookmark, update_attrs)
      assert bookmark.title == "some updated title"
      assert bookmark.url == "https://www.example.com/2"
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

  describe "tags" do
    test "create_tag/1 with valid data creates a new tag" do
      attrs = %{
        name: "hello-world"
      }

      assert {:ok, %Library.Tag{} = tag} = Library.create_tag(attrs)
      assert tag.name == "hello-world"
      assert tag.normalized_name == "helloworld"
    end

    test "create_tag/1 with invalid data returns an error changeset" do
      attrs = %{
        name: ""
      }

      assert {:error, %Ecto.Changeset{}} = Library.create_tag(attrs)
    end

    test "create_tag_if_new! creates a new tag with a given name if new." do
      assert %Library.Tag{name: name} = Library.create_tag_if_new!("new-name")
      assert name == "new-name"
    end

    test "create_tag_if_new! returns an existing tag if applicable." do
      existing_tag = tag_fixture(%{name: "abc"})

      # Note the normalization.
      tag = Library.create_tag_if_new!("ABC")

      assert tag == existing_tag
    end

    test "may preloads tags with preload_tags" do
      tag_a = tag_fixture(%{name: "a"})
      tag_b = tag_fixture(%{name: "b"})
      bookmark = bookmark_fixture(%{tags: [tag_a, tag_b]})

      from_db = Library.get_bookmark!(bookmark.id) |> Library.preload_tags()
      assert length(from_db.tags) == 2
    end
  end

  defp load_user_with_id(id) do
    Marker.Accounts.get_user!(id)
  end
end
