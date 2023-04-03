defmodule Protectora.Repo.Migrations.CreatePublicacion do
  use Ecto.Migration

  def change do
    create table(:publicacion, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :titulo, :string
      add :contido, :string

      timestamps()
    end
  end
end
