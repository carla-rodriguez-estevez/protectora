defmodule Protectora.Rexistros do
  @moduledoc """
  The Rexistros context.
  """

  import Ecto.Query, warn: false
  alias Protectora.Repo

  alias Protectora.Rexistros.Rexistro

  @doc """
  Returns the list of rexistro.

  ## Examples

      iex> list_rexistro()
      [%Rexistro{}, ...]

  """
  def list_rexistro do
    Repo.all(Rexistro)
  end

  @doc """
  Gets a single rexistro.

  Raises `Ecto.NoResultsError` if the Rexistro does not exist.

  ## Examples

      iex> get_rexistro!(123)
      %Rexistro{}

      iex> get_rexistro!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rexistro!(id), do: Repo.get!(Rexistro, id)

  @doc """
  Creates a rexistro.

  ## Examples

      iex> create_rexistro(%{field: value})
      {:ok, %Rexistro{}}

      iex> create_rexistro(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rexistro(attrs \\ %{}) do
    %Rexistro{}
    |> Rexistro.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rexistro.

  ## Examples

      iex> update_rexistro(rexistro, %{field: new_value})
      {:ok, %Rexistro{}}

      iex> update_rexistro(rexistro, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rexistro(%Rexistro{} = rexistro, attrs) do
    rexistro
    |> Rexistro.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rexistro.

  ## Examples

      iex> delete_rexistro(rexistro)
      {:ok, %Rexistro{}}

      iex> delete_rexistro(rexistro)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rexistro(%Rexistro{} = rexistro) do
    Repo.delete(rexistro)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rexistro changes.

  ## Examples

      iex> change_rexistro(rexistro)
      %Ecto.Changeset{data: %Rexistro{}}

  """
  def change_rexistro(%Rexistro{} = rexistro, attrs \\ %{}) do
    Rexistro.changeset(rexistro, attrs)
  end
end
