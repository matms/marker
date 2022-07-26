defmodule Marker.Archive.Shiori.ShioriError do
  @moduledoc """
  This module pertains to the ShioriError Exception.
  """

  alias Marker.Archive.Shiori.ShioriError

  defexception [:reason, :data]

  @type t() :: %__MODULE__{
          __exception__: true,
          reason:
            :failed_login
            | :url_already_in_cache
            | :unique_constraint_failed
            | :archive_not_found
        }

  @spec failed_login :: ShioriError.t()
  def failed_login do
    %__MODULE__{reason: :failed_login}
  end

  @spec url_already_in_cache :: ShioriError.t()
  def url_already_in_cache do
    %__MODULE__{reason: :url_already_in_cache}
  end

  @spec unique_constraint_failed :: ShioriError.t()
  def unique_constraint_failed do
    %__MODULE__{reason: :unique_constraint_failed}
  end

  @impl Exception
  def message(%__MODULE__{reason: :failed_login}) do
    "Failed to login to shiori"
  end

  @impl Exception
  def message(%__MODULE__{reason: :url_already_in_cache}) do
    "The URL requested has already been saved"
  end

  @impl Exception
  def message(%__MODULE__{reason: :unique_constraint_failed}) do
    "Unique Constraint Failed - the URL has already been archived"
  end

  @impl Exception
  def message(%__MODULE__{reason: :archive_not_found}) do
    "Archive not found - the URL hasn't been saved to shiori yet"
  end
end
