defmodule Marker.Repo.Migrations.CreateBookmarks do
  use Ecto.Migration

  def change do
    create table(:bookmarks) do
      add :title, :string
      add :url, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:bookmarks, [:user_id])
    create unique_index(:bookmarks, [:url])
  end
end
