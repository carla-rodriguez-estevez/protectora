defmodule Protectora.Padrinamentos.Padrinamento do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "padrinamento" do
    field :catidade_aporte, :decimal
    field :perioricidade, :string
    field :animal_id, :binary_id
    field :colaborador_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(padrinamento, attrs) do
    padrinamento
    |> cast(attrs, [:perioricidade, :catidade_aporte, :animal_id, :colaborador_id])
    |> validate_required([:perioricidade, :catidade_aporte, :animal_id, :colaborador_id])
    |> validate_number(:catidade_aporte, greater_than: 0, less_than: 999_999)
  end
end
