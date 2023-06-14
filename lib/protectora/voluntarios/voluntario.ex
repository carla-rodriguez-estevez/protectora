defmodule Protectora.Voluntarios.Voluntario do
  use Ecto.Schema
  import Ecto.Changeset

  require Logger

  @mail_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "voluntario" do
    field :contrasinal, :string
    field :email, :string
    field :nome, :string

    timestamps()
  end

  @doc false
  def changeset(voluntario, attrs) do
    voluntario
    |> cast(attrs, [:nome, :contrasinal, :email])
    |> validate_required([:nome, :contrasinal, :email], message: "non pode estar baleiro")
    |> validate_format(:email, @mail_regex, message: "Debe conter o signo @ e ningún espacio")
    |> validate_length(:email, max: 160, message: "email demasiado longo")
    |> unique_constraint([:email], message: "Este email xa ten un voluntario asociado")
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{contrasinal: hash_password}} = changeset
       ) do
    change(changeset, contrasinal: Bcrypt.hash_pwd_salt(hash_password))
  end

  defp put_password_hash(changeset), do: changeset
end
