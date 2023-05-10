defmodule Protectora.Voluntarios.Voluntario do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> validate_required([:nome, :contrasinal, :email])
    |> validate_format(:email, @mail_regex, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unique_constraint([:email])
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{hash_password: hash_password}} = changeset
       ) do
    change(changeset, hash_password: Bcrypt.hash_pwd_salt(hash_password))
  end

  defp put_password_hash(changeset), do: changeset
end
