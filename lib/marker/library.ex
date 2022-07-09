defmodule Marker.Library do
  @moduledoc """
  The Library context.
  """

  import Ecto.Query, warn: false
  alias Marker.Repo

  alias Marker.Library.Bookmark
  alias Marker.Accounts.User

  @spec list_bookmarks :: [Bookmark.t()]
  @doc """
  Returns the list of bookmarks.

  ## Examples

      iex> list_bookmarks()
      [%Bookmark{}, ...]

  """
  def list_bookmarks do
    Repo.all(Bookmark)
  end

  @spec list_bookmarks_by_user(User.t()) :: [Bookmark.t()]
  @doc """
  Returns the list of bookmark by a given user

  ## Examples

      iex> list_bookmarks_by_user(user)
      [%Bookmark{}, ...]

  """
  def list_bookmarks_by_user(%User{} = user) do
    Bookmark.Query.from_user(user)
    |> Repo.all()
  end

  @spec get_bookmark!(term) :: [Bookmark.t()]
  @doc """
  Gets a single bookmark.

  Raises `Ecto.NoResultsError` if the Bookmark does not exist.

  ## Examples

      iex> get_bookmark!(123)
      %Bookmark{}

      iex> get_bookmark!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bookmark!(id), do: Repo.get!(Bookmark, id)

  @spec create_bookmark(%{}) :: {:ok, Bookmark.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Creates a bookmark.

  ## Examples

      iex> create_bookmark(%{field: value})
      {:ok, %Bookmark{}}

      iex> create_bookmark(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bookmark(attrs \\ %{}) do
    %Bookmark{}
    |> Bookmark.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_bookmark(Bookmark.t(), %{}) :: {:ok, Bookmark.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Updates a bookmark.

  ## Examples

      iex> update_bookmark(bookmark, %{field: new_value})
      {:ok, %Bookmark{}}

      iex> update_bookmark(bookmark, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bookmark(%Bookmark{} = bookmark, attrs) do
    bookmark
    |> Bookmark.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_bookmark(Bookmark.t()) :: {:ok, Bookmark.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Deletes a bookmark.

  ## Examples

      iex> delete_bookmark(bookmark)
      {:ok, %Bookmark{}}

      iex> delete_bookmark(bookmark)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bookmark(%Bookmark{} = bookmark) do
    Repo.delete(bookmark)
  end

  @spec change_bookmark(Bookmark.t(), %{}) :: Ecto.Changeset.t()
  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bookmark changes.

  ## Examples

      iex> change_bookmark(%Bookmark{})
      %Ecto.Changeset{data: %Bookmark{}}

  """
  def change_bookmark(%Bookmark{} = bookmark, attrs \\ %{}) do
    Bookmark.changeset(bookmark, attrs)
  end
end
