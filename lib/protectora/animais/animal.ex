defmodule Protectora.Animais.Animal do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "animal" do
    field :descricion, :string
    field :eEspecial, :boolean, default: false
    field :eUrxente, :boolean, default: false
    field :idade, :integer
    field :madurez, :string
    field :nome, :string
    field :peso, :integer
    field :raza, :string
    field :tamano, :string
    field :tipo, :string, default: "outro"
    has_many :rexistro, Protectora.Rexistros.Rexistro
    has_many :imaxe_animal, Protectora.Animais.ImaxeAnimal
    has_many :padrinamento, Protectora.Padrinamentos.Padrinamento

    timestamps()
  end

  @doc false
  def changeset(animal, attrs) do
    animal
    |> cast(attrs, [
      :nome,
      :tipo,
      :peso,
      :madurez,
      :tamano,
      :raza,
      :idade,
      :descricion,
      :eUrxente,
      :eEspecial
    ])
    |> validate_required(
      [
        :nome,
        :tipo,
        :peso,
        :madurez,
        :tamano,
        :raza,
        :idade,
        :descricion,
        :eUrxente,
        :eEspecial
      ],
      message: "non pode estar valeiro"
    )
    |> validate_number(:idade,
      greater_than: -1,
      less_than: 50,
      message: "a cantidade debe ser maior que 0 e menor que 50"
    )
    |> validate_number(:peso,
      greater_than: 0,
      less_than: 100,
      message: "a cantidade debe ser maior que 0 e menor que 100"
    )
    |> validate_inclusion(:madurez, ["cachorro", "adulto", "ancián"], message: "Madurez inválida")
    |> validate_inclusion(:tamano, ["grande", "mediano", "pequeno"], message: "tamaño inválido")
    |> validate_inclusion(
      :tipo,
      [
        "can",
        "cadela",
        "gato",
        "gata",
        "roedor",
        "roedora",
        "outro",
        "outra"
      ],
      message: "tipo inválido"
    )
  end
end
