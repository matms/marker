defmodule Marker.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :normalized_name, :string

      timestamps()
    end

    create unique_index(:tags, [:name])
    create unique_index(:tags, [:normalized_name])
  end
end
