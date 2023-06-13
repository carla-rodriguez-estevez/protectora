defmodule Protectora.Animais.AdoptionEmail do
  import Ecto.Changeset
  use Ecto.Schema

  @mail_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  schema "adoption email" do
    field(:nome, :string)
    field(:email, :string)
    field(:telefono, :integer)
    field(:nota, :string)
  end

  @doc false
  def changeset(adoption, attrs \\ %{}) do
    adoption
    |> cast(attrs, [:nome, :telefono, :email, :nota])
    |> validate_required([:nome, :telefono, :email], message: "non pode estar valeiro")
    |> validate_number(:telefono,
      greater_than: 99_999_999,
      less_than: 999_999_999,
      message: "Teléfono móvil incorrecto"
    )
    |> validate_format(:email, @mail_regex, message: "Debe conter o signo @ e ningún espacio")
  end
end
