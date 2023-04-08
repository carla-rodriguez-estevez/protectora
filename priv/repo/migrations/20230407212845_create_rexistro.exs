defmodule Protectora.Repo.Migrations.CreateRexistro do
  use Ecto.Migration

  def change do
    create table(:rexistro, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :titulo, :string
      add :descricion, :string
      add :prezo, :float
      add :animal_id, references(:animal, on_delete: :delete_all, null: false, type: :binary_id)

      timestamps()
    end

    create index(:rexistro, [:animal_id])
  end
end
