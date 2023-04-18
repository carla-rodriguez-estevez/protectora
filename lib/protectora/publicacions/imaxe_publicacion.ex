defmodule Protectora.Publicacions.ImaxePublicacion do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "imaxe_publicacion" do
    field :path_imaxe, :string
    field :publicacion_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(imaxe_publicacion, attrs) do
    imaxe_publicacion
    |> cast(attrs, [:path_imaxe, :publicacion_id])
    |> validate_required([:path_imaxe, :publicacion_id])
  end
end
