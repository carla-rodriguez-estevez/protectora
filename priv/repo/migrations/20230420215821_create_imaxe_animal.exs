defmodule Protectora.Repo.Migrations.CreateImaxeAnimal do
  use Ecto.Migration

  def change do
    create table(:imaxe_animal, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :path_imaxe, :string
      add :animal_id, references(:animal,on_delete: :delete_all, null: false, type: :binary_id)

      timestamps()
    end

    create index(:imaxe_animal, [:animal_id])
  end
end
