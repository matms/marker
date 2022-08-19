defmodule Marker.Library do
  @moduledoc """
  The Library context.
  """
  use Boundary, deps: [Marker.{Accounts, Repo}], exports: [Bookmark]

  import Ecto.Query, warn: false
  alias Marker.Repo

  alias Marker.Library.{Bookmark, Tag}
  alias Marker.Accounts.User

  @doc """
  Returns the list of bookmarks.

  ## Examples

  iex> list_bookmarks()
  [%Bookmark{}, ...]

  """
  @spec list_bookmarks :: [Bookmark.t()]
  def list_bookmarks do
    Repo.all(Bookmark)
  end

  @doc """
  Returns the list of bookmark by a given user

  ## Examples

  iex> list_bookmarks_by_user(user)
  [%Bookmark{}, ...]

  """
  @spec list_bookmarks_by_user(User.t()) :: [Bookmark.t()]
  def list_bookmarks_by_user(%User{} = user) do
    Bookmark.Query.from_user(user)
    |> Repo.all()
  end

  @doc """
  Gets a single bookmark. Returns nil if the bookmark doesn't exist.

  ## Examples

      iex> get_bookmark!(123)
      %Bookmark{}

      iex> get_bookmark!(456)
      nil
  """
  @spec get_bookmark(term) :: Bookmark.t() | nil
  def get_bookmark(id) do
    Repo.get(Bookmark, id)
  end

  @doc """
  Like `get_bookmark/1`, but raises `Ecto.NoResultsError` if the Bookmark does
  not exist.
  """
  @spec get_bookmark!(term) :: Bookmark.t()
  def get_bookmark!(id) do
    Repo.get!(Bookmark, id)
  end

  @doc """
  Gets a single bookmark with a given url. The url must match exactly.

  Returns nil if there is no bookmark with the given url.
  """
  @spec get_bookmark_by_url(String.t()) :: Bookmark.t() | nil
  def get_bookmark_by_url(url), do: Repo.one(Bookmark.Query.with_url(url))

  @doc """
  Gets a single bookmark, assuming that bookmark is possessed by `user`.

  Raises `Ecto.NoResultsError` if the Bookmark does not exist or is by a
  different user.

  ## Examples

  iex> get_bookmark_check_user!(123, user)
  %Bookmark{}

  iex> get_bookmark_check_user!(123, incorrect_user)
  ** (Ecto.NoResultsError)
  """
  @spec get_bookmark_check_user!(term, Marker.Accounts.User.t()) :: Bookmark.t()
  def get_bookmark_check_user!(id, %User{} = user) do
    Bookmark.Query.from_user(user)
    |> Repo.get!(id)
  end

  @doc """
  Gets a single bookmark, or a list of bookmarks, and preloads tags into these.
  """
  @spec preload_tags(t) :: t | nil when t: Bookmark.t() | [Bookmark.t()]
  def preload_tags(bookmark_or_bookmarks) do
    Repo.preload(bookmark_or_bookmarks, :tags)
  end

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

  @doc """
  Updates a bookmark.

  ## Examples

  iex> update_bookmark(bookmark, %{field: new_value})
  {:ok, %Bookmark{}}

  iex> update_bookmark(bookmark, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  @spec update_bookmark(Bookmark.t(), %{}) :: {:ok, Bookmark.t()} | {:error, Ecto.Changeset.t()}
  def update_bookmark(%Bookmark{} = bookmark, attrs) do
    bookmark
    |> Bookmark.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bookmark.

  ## Examples

  iex> delete_bookmark(bookmark)
  {:ok, %Bookmark{}}

  iex> delete_bookmark(bookmark)
  {:error, %Ecto.Changeset{}}

  """
  @spec delete_bookmark(Marker.Library.Bookmark.t()) :: any
  def delete_bookmark(%Bookmark{} = bookmark) do
    Repo.delete(bookmark)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bookmark changes.

  ## Examples

  iex> change_bookmark(%Bookmark{})
  %Ecto.Changeset{data: %Bookmark{}}

  """
  @spec change_bookmark(Bookmark.t(), map()) :: Ecto.Changeset.t()
  def change_bookmark(%Bookmark{} = bookmark, attrs \\ %{}) do
    Bookmark.changeset(bookmark, attrs)
  end

  @doc """
  Creates a new tag.
  """
  @spec create_tag(map()) :: {:ok, Tag.t()} | {:error, Ecto.Changeset.t()}
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a tag with the given name if it doesn't already exist.
  In any case, returns the matching tag.

  Throws on failure.

  ## Examples

      iex> create_tag_if_new!("new")
      %Tag{}

      iex> create_tag_if_new!("existing")
      %Tag{}
  """
  @spec create_tag_if_new!(String.t()) :: Tag.t()
  def create_tag_if_new!(name) do
    normalized_name = Tag.Normalize.normalized(name)

    {:ok, tag} =
      Repo.transaction(fn ->
        if tag = Repo.one(Tag.Query.with_normalized_name(normalized_name)) do
          tag
        else
          {:ok, tag} = create_tag(%{name: name, normalized_name: normalized_name})

          tag
        end
      end)

    tag
  end
end
