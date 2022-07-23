defmodule Marker.Archive.Shiori.Server do
  @moduledoc """
  This module provides access to the Shiori Backend Server.

  All mutations should go through the functions defined here. This allows
  for controlling concurrency and ensures the cache is updated as needed.
  """
  use GenServer

  require Logger

  alias Marker.Archive.Shiori.{Cache, Protocol, ShioriError}

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    session = Protocol.shiori_login!()

    {:ok, %{session: session}, {:continue, :new_cache}}
  end

  @spec new_archive(String.t()) ::
          {:error, ShioriError.t()}
          | {:ok, {shiori_id :: number(), shiori_url :: String.t()}}
  def new_archive(url) do
    GenServer.call(__MODULE__, {:new_archive, url})
  end

  @impl GenServer
  def handle_continue(:new_cache, %{session: session} = state) do
    Cache.override_cache(Cache.create_cache!(Protocol.all_bookmarks!(session)))
    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:new_archive, url}, _from, %{session: session} = state) do
    if Cache.has_archive?(url) do
      Logger.warn("Ignoring new_archive call because URL is already archived in Shiori: #{url}")
      {:reply, {:error, ShioriError.url_already_in_cache()}, state}
    else
      case Protocol.shiori_add_new(session, url) do
        {:ok, {shiori_id, shiori_url}} ->
          if shiori_url != url do
            Logger.notice("Requested url was '#{url}', but shiori saved as '#{shiori_url}'")
          end

          Cache.put_archive(shiori_url, shiori_id)
          {:reply, {:ok, {shiori_id, shiori_url}}, state}

        {:error, %ShioriError{} = e} ->
          # Note that it is possible to get a Unique Constraint Failed here
          # since the Cache.has_archive? cannot account for Shiori's URL
          # normalization.
          Logger.error("New_archive call failed for #{url}: #{Exception.message(e)}")
          {:reply, {:error, e}, state}
      end
    end
  end

  # TODO: handle_call for force-updating archive.
end
