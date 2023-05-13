defmodule Protectora.Voluntarios do
  @moduledoc """
  The Voluntarios context.
  """

  import Ecto.Query, warn: false
  alias Protectora.Repo

  alias Protectora.Voluntarios.Voluntario
  alias Protectora.Accounts.{User, UserToken, UserNotifier}

  @doc """
  Returns the list of voluntario.

  ## Examples

      iex> list_voluntario()
      [%Voluntario{}, ...]

  """
  def list_voluntario do
    Repo.all(Voluntario)
  end

  @doc """
  Gets a single voluntario.

  Raises `Ecto.NoResultsError` if the Voluntario does not exist.

  ## Examples

      iex> get_voluntario!(123)
      %Voluntario{}

      iex> get_voluntario!(456)
      ** (Ecto.NoResultsError)

  """
  def get_voluntario!(id), do: Repo.get!(Voluntario, id)

  @doc """
  Creates a voluntario.

  ## Examples

      iex> create_voluntario(%{field: value})
      {:ok, %Voluntario{}}

      iex> create_voluntario(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_voluntario(attrs \\ %{}), do: create_full_voluntario(attrs)

  defp create_full_voluntario(attrs \\ %{}) do
    Protectora.Accounts.register_user(%{email: attrs["email"], password: attrs["contrasinal"]})

    vol =
      %Voluntario{}
      |> Voluntario.changeset(attrs)
      |> Repo.insert()

    vol
  end

  @doc """
  Updates a voluntario.

  ## Examples

      iex> update_voluntario(voluntario, %{field: new_value})
      {:ok, %Voluntario{}}

      iex> update_voluntario(voluntario, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_voluntario(%Voluntario{} = voluntario, attrs) do
    voluntario
    |> Voluntario.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a voluntario.

  ## Examples

      iex> delete_voluntario(voluntario)
      {:ok, %Voluntario{}}

      iex> delete_voluntario(voluntario)
      {:error, %Ecto.Changeset{}}

  """
  def delete_voluntario(%Voluntario{} = voluntario) do
    {:ok, resp} = Repo.transaction(fn -> delete_voluntario_enteiro(voluntario) end)
    resp
  end

  defp delete_voluntario_enteiro(params) do
    user = Protectora.Accounts.get_user_by_email(params.email)

    Protectora.Accounts.delete_user(user)
    Repo.delete(params)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking voluntario changes.

  ## Examples

      iex> change_voluntario(voluntario)
      %Ecto.Changeset{data: %Voluntario{}}

  """
  def change_voluntario(%Voluntario{} = voluntario, attrs \\ %{}) do
    Voluntario.changeset(voluntario, attrs)
  end
end
