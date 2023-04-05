defmodule Protectora.Colaboradores do
  @moduledoc """
  The Colaboradores context.
  """

  import Ecto.Query, warn: false
  alias Protectora.Repo

  alias Protectora.Colaboradores.Colaborador

  @doc """
  Returns the list of colaborador.

  ## Examples

      iex> list_colaborador()
      [%Colaborador{}, ...]

  """
  def list_colaborador do
    Repo.all(Colaborador)
  end

  @doc """
  Gets a single colaborador.

  Raises `Ecto.NoResultsError` if the Colaborador does not exist.

  ## Examples

      iex> get_colaborador!(123)
      %Colaborador{}

      iex> get_colaborador!(456)
      ** (Ecto.NoResultsError)

  """
  def get_colaborador!(id), do: Repo.get!(Colaborador, id)

  @doc """
  Creates a colaborador.

  ## Examples

      iex> create_colaborador(%{field: value})
      {:ok, %Colaborador{}}

      iex> create_colaborador(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_colaborador(attrs \\ %{}) do
    %Colaborador{}
    |> Colaborador.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a colaborador.

  ## Examples

      iex> update_colaborador(colaborador, %{field: new_value})
      {:ok, %Colaborador{}}

      iex> update_colaborador(colaborador, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_colaborador(%Colaborador{} = colaborador, attrs) do
    colaborador
    |> Colaborador.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a colaborador.

  ## Examples

      iex> delete_colaborador(colaborador)
      {:ok, %Colaborador{}}

      iex> delete_colaborador(colaborador)
      {:error, %Ecto.Changeset{}}

  """
  def delete_colaborador(%Colaborador{} = colaborador) do
    Repo.delete(colaborador)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking colaborador changes.

  ## Examples

      iex> change_colaborador(colaborador)
      %Ecto.Changeset{data: %Colaborador{}}

  """
  def change_colaborador(%Colaborador{} = colaborador, attrs \\ %{}) do
    Colaborador.changeset(colaborador, attrs)
  end
end
