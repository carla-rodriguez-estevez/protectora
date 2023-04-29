defmodule Protectora.Animais.ImaxeAnimal do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "imaxe_animal" do
    field :path_imaxe, :string
    field :animal_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(imaxe_animal, attrs) do
    imaxe_animal
    |> cast(attrs, [:path_imaxe, :animal_id])
    |> validate_required([:path_imaxe, :animal_id])
  end
end
