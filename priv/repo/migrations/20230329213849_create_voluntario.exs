defmodule Protectora.Repo.Migrations.CreateVoluntario do
  use Ecto.Migration

  def change do
    create table(:voluntario, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :nome, :string
      add :contrasinal, :string
      add :email, :string

      timestamps()
    end
  end
end
