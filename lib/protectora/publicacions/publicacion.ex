defmodule Protectora.Publicacions.Publicacion do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "publicacion" do
    field :contido, :string
    field :titulo, :string

    timestamps()
  end

  @doc false
  def changeset(publicacion, attrs) do
    publicacion
    |> cast(attrs, [:titulo, :contido])
    |> validate_required([:titulo, :contido])
  end
end
