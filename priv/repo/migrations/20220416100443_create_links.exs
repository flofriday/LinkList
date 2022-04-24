defmodule Linklist.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :title, :string
      add :description, :string
      add :url, :string
      add :image_url, :string

      timestamps()
    end
  end
end
