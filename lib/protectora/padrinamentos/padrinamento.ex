defmodule Protectora.Padrinamentos.Padrinamento do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "padrinamento" do
    field(:cantidade_aporte, :decimal)
    field(:perioricidade, :string)
    belongs_to :animal, Protectora.Animais.Animal
    belongs_to :colaborador, Protectora.Colaboradores.Colaborador

    timestamps()
  end

  @doc false
  def changeset(padrinamento, attrs) do
    padrinamento
    |> cast(attrs, [:perioricidade, :cantidade_aporte, :animal_id, :colaborador_id])
    |> validate_required([:perioricidade, :cantidade_aporte, :animal_id])
    |> validate_number(:cantidade_aporte, greater_than: 0, less_than: 999_999)
    |> validate_inclusion(:perioricidade, [
      "mensual",
      "bimensual",
      "trimestral",
      "cada 6 meses",
      "anual"
    ])
  end
end
