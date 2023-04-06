defmodule Protectora.Repo.Migrations.CreateAnimal do
  use Ecto.Migration

  def change do
    create table(:animal, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :nome, :string
      add :tipo, :string
      add :peso, :integer
      add :madurez, :string
      add :tamano, :string
      add :raza, :string
      add :idade, :integer
      add :descricion, :string
      add :eUrxente, :boolean, default: false, null: false
      add :eEspecial, :boolean, default: false, null: false

      timestamps()
    end
  end
end
