defmodule Protectora.Rexistros.Rexistro do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rexistro" do
    field(:descricion, :string)
    field(:prezo, :float)
    field(:titulo, :string)
    belongs_to(:animal, Protectora.Animais.Animal)

    timestamps()
  end

  @doc false
  def changeset(rexistro, attrs) do
    rexistro
    |> cast(attrs, [:titulo, :descricion, :prezo, :animal_id])
    |> validate_required([:titulo, :descricion, :prezo, :animal_id],
      message: "non pode estar baleiro"
    )
    |> validate_number(:prezo,
      greater_than: 0,
      less_than: 999_999,
      message: "A cantidade debe ser maior que 0"
    )
  end
end
