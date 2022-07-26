defmodule Marker.Archive.Shiori.Cache do
  @moduledoc """
  An in-memory cache of Shiori URLs.

  (In the future, we may wish to implement some form of persistance as an
  optimization)
  """
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> nil end, name: __MODULE__)
  end

  def override_cache(new_cache) do
    Agent.update(__MODULE__, fn _ -> new_cache end)
  end

  @spec has_archive?(String.t()) :: boolean()
  def has_archive?(url) do
    Agent.get(__MODULE__, fn state -> Map.has_key?(state, url) end)
  end

  @spec list_archives :: [String.t()]
  def list_archives() do
    Agent.get(__MODULE__, fn state -> Map.keys(state) end)
  end

  @spec get_archive_shiori_id(String.t()) :: number() | nil
  def get_archive_shiori_id(url) do
    Agent.get(__MODULE__, fn state ->
      if Map.has_key?(state, url) do
        state[url][:shiori_id]
      else
        nil
      end
    end)
  end

  @spec put_archive(String.t(), integer()) :: :ok
  def put_archive(url, shiori_id) do
    Agent.update(__MODULE__, fn state ->
      Map.put(state, url, %{url: url, shiori_id: shiori_id})
    end)
  end

  @doc """
  Helper function. Creates a cache using `all_bookmarks`, as created by
  `Protocol.all_bookmarks!/1`.
  """
  def create_cache!(all_bookmarks) do
    all_bookmarks
    |> Map.new(fn %{url: url} = b -> {url, b} end)
  end
end
