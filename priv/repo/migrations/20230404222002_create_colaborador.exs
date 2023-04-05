defmodule Protectora.Repo.Migrations.CreateColaborador do
  use Ecto.Migration

  def change do
    create table(:colaborador, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :nome, :string
      add :apelidos, :string
      add :dataNacemento, :date
      add :direccion, :string
      add :codigoPostal, :integer
      add :localidade, :string
      add :email, :string
      add :numeroConta, :string
      add :cantidadeAporte, :integer
      add :perioricidade, :string

      timestamps()
    end

    create unique_index(:colaborador, [:email])
  end
end
