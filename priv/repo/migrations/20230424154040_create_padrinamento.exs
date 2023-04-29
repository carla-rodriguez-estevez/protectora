defmodule Protectora.Repo.Migrations.CreatePadrinamento do
  use Ecto.Migration

  def change do
    create table(:padrinamento, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :perioricidade, :string
      add :cantidade_aporte, :decimal
      add :animal_id, references(:animal, on_delete: :delete_all, type: :binary_id, null: false)

      add :colaborador_id,
          references(:colaborador, on_delete: :nothing, type: :binary_id, null: false)

      timestamps()
    end

    create index(:padrinamento, [:animal_id])
    create index(:padrinamento, [:colaborador_id])
  end
end
