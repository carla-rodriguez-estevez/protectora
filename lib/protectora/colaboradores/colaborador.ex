defmodule Protectora.Colaboradores.Colaborador do
  use Ecto.Schema
  use Timex
  import Ecto.Changeset
  require Logger

  @mail_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  @account_regex ~r/^[a-zA-Z]{2}[0-9]{20}$/

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "colaborador" do
    field(:apelidos, :string)
    field(:cantidadeAporte, :integer)
    field(:codigoPostal, :integer)
    field(:dataNacemento, :date)
    field(:direccion, :string)
    field(:email, :string)
    field(:localidade, :string)
    field(:nome, :string)
    field(:numeroConta, :string)
    field(:perioricidade, :string)
    has_many(:padrinamento, Protectora.Padrinamentos.Padrinamento)

    timestamps()
  end

  @doc false
  def changeset(colaborador, attrs) do
    colaborador
    |> cast(attrs, [
      :nome,
      :apelidos,
      :dataNacemento,
      :direccion,
      :codigoPostal,
      :localidade,
      :email,
      :numeroConta,
      :cantidadeAporte,
      :perioricidade
    ])
    |> validate_required(
      [
        :nome,
        :apelidos,
        :dataNacemento,
        :direccion,
        :codigoPostal,
        :localidade,
        :email,
        :numeroConta
      ],
      message: "non pode estar baleiro"
    )
    |> validate_format(:email, @mail_regex, message: "Debe conter o signo @ e ningún espacio")
    |> validate_format(:numeroConta, @account_regex,
      message: "A conta debe ter 20 caracteres sen espacios"
    )
    |> validate_current_or_future_date(:dataNacemento)
    |> validate_number(:cantidadeAporte,
      greater_than: 0,
      less_than: 99_999,
      message: "A cantidade debe ser maior que 0"
    )
    |> validate_number(:codigoPostal,
      greater_than: 10_000,
      less_than: 99_999,
      message: "O código postal é incorrecto"
    )
    |> validate_length(:email, max: 160, message: "Email demasiado longo")
    |> unique_constraint(:email, message: "Email xa empregado")
    |> validate_inclusion(
      :perioricidade,
      [
        "mensual",
        "bimensual",
        "trimestral",
        "cada 6 meses",
        "anual"
      ],
      message: "Perioricidade non válida"
    )
  end

  def complete_changeset(colaborador, attrs) do
    colaborador
    |> cast(attrs, [
      :nome,
      :apelidos,
      :dataNacemento,
      :direccion,
      :codigoPostal,
      :localidade,
      :email,
      :numeroConta,
      :cantidadeAporte,
      :perioricidade
    ])
    |> validate_required(
      [
        :nome,
        :apelidos,
        :dataNacemento,
        :direccion,
        :codigoPostal,
        :localidade,
        :email,
        :numeroConta,
        :cantidadeAporte,
        :perioricidade
      ],
      message: "non pode estar baleiro"
    )
    |> validate_format(:email, @mail_regex, message: "Debe conter o signo @ e ningún espacio")
    |> validate_format(:numeroConta, @account_regex,
      message: "A conta debe ter 20 caracteres sen espacios"
    )
    |> validate_current_or_future_date(:dataNacemento)
    |> validate_number(:codigoPostal,
      greater_than: 10_000,
      less_than: 99_999,
      message: "O código postal é incorrecto"
    )
    |> validate_length(:email, max: 160, message: "Email demasiado longo")
    |> unique_constraint(:email, message: "Email xa empregado")
    |> validate_number(:cantidadeAporte,
      greater_than: 0,
      less_than: 999_999,
      message: "A cantidade debe ser maior que 0"
    )
    |> validate_inclusion(
      :perioricidade,
      [
        "mensual",
        "bimensual",
        "trimestral",
        "cada 6 meses",
        "anual"
      ],
      message: "A perioricidade indicada é incorrecta"
    )
  end

  def validate_current_or_future_date(%{changes: changes} = changeset, field) do
    if date = changes[field] do
      do_validate_current_or_future_date(changeset, field, date)
    else
      changeset
    end
  end

  defp do_validate_current_or_future_date(changeset, field, date) do
    today = Timex.today()

    # Logger.info(to_string(Timex.compare(date, today)))

    if Timex.compare(date, today) == 1 do
      changeset
      |> add_error(field, "Data incorrecta")
    else
      changeset
    end
  end
end
