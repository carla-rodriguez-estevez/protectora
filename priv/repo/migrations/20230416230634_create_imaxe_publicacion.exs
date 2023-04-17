defmodule Protectora.Repo.Migrations.CreateImaxePublicacion do
  use Ecto.Migration

  def change do
    create table(:imaxe_publicacion, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :path_imaxe, :string
      add :publicacion_id, references(:publicacion,on_delete: :delete_all, null: false, type: :binary_id)

      timestamps()
    end

    create index(:imaxe_publicacion, [:publicacion_id])
  end
end
