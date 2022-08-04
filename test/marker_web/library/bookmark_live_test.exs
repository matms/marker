defmodule MarkerWeb.Library.BookmarkLiveTest do
  @moduledoc false
  use MarkerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Marker.LibraryFixtures

  @create_attrs %{title: "some title", url: "https://www.example.com"}
  @update_attrs %{title: "some updated title", url: "https://www.example.com/2"}
  @invalid_attrs %{title: nil, url: nil}

  defp create_bookmark(%{user: user}) do
    bookmark = bookmark_fixture(%{user_id: user.id})
    %{bookmark: bookmark}
  end

  describe "Index" do
    setup [:register_and_log_in_user, :create_bookmark]

    test "lists all bookmarks", %{conn: conn, bookmark: bookmark} do
      {:ok, _index_live, html} = live(conn, Routes.library_bookmark_index_path(conn, :index))

      assert html =~ "Listing Bookmarks"
      assert html =~ bookmark.title
    end

    test "saves new bookmark", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.library_bookmark_index_path(conn, :index))

      assert index_live |> element("a", "New Bookmark") |> render_click() =~
               "New Bookmark"

      assert_patch(index_live, Routes.library_bookmark_index_path(conn, :new))

      assert index_live
             |> form("#bookmark-form", bookmark: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#bookmark-form", bookmark: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.library_bookmark_index_path(conn, :index))

      assert html =~ "Bookmark created successfully"
      assert html =~ "some title"
    end

    test "updates bookmark in listing", %{conn: conn, bookmark: bookmark} do
      {:ok, index_live, _html} = live(conn, Routes.library_bookmark_index_path(conn, :index))

      assert index_live |> element("#bookmark-#{bookmark.id} a", "Edit") |> render_click() =~
               "Edit Bookmark"

      assert_patch(index_live, Routes.library_bookmark_index_path(conn, :edit, bookmark))

      assert index_live
             |> form("#bookmark-form", bookmark: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#bookmark-form", bookmark: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.library_bookmark_index_path(conn, :index))

      assert html =~ "Bookmark updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes bookmark in listing", %{conn: conn, bookmark: bookmark} do
      {:ok, index_live, _html} = live(conn, Routes.library_bookmark_index_path(conn, :index))

      assert index_live |> element("#bookmark-#{bookmark.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#bookmark-#{bookmark.id}")
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_bookmark]

    test "displays bookmark", %{conn: conn, bookmark: bookmark} do
      {:ok, _show_live, html} =
        live(conn, Routes.library_bookmark_show_path(conn, :show, bookmark))

      assert html =~ "Show Bookmark"
      assert html =~ bookmark.title
    end

    test "updates bookmark within modal", %{conn: conn, bookmark: bookmark} do
      {:ok, show_live, _html} =
        live(conn, Routes.library_bookmark_show_path(conn, :show, bookmark))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Bookmark"

      assert_patch(show_live, Routes.library_bookmark_show_path(conn, :edit, bookmark))

      assert show_live
             |> form("#bookmark-form", bookmark: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#bookmark-form", bookmark: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.library_bookmark_show_path(conn, :show, bookmark))

      assert html =~ "Bookmark updated successfully"
      assert html =~ "some updated title"
    end
  end
end
