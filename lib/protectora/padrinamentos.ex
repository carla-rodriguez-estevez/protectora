defmodule Protectora.Padrinamentos do
  @moduledoc """
  The Padrinamentos context.
  """

  import Ecto.Query, warn: false
  alias Protectora.Repo

  alias Protectora.Padrinamentos.Padrinamento

  @doc """
  Returns the list of padrinamento.

  ## Examples

      iex> list_padrinamento()
      [%Padrinamento{}, ...]

  """
  def list_padrinamento do
    Repo.all(Padrinamento)
  end

  @doc """
  Gets a single padrinamento.

  Raises `Ecto.NoResultsError` if the Padrinamento does not exist.

  ## Examples

      iex> get_padrinamento!(123)
      %Padrinamento{}

      iex> get_padrinamento!(456)
      ** (Ecto.NoResultsError)

  """
  def get_padrinamento!(id), do: Repo.get!(Padrinamento, id)

  @doc """
  Creates a padrinamento.

  ## Examples

      iex> create_padrinamento(%{field: value})
      {:ok, %Padrinamento{}}

      iex> create_padrinamento(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_padrinamento(attrs \\ %{}) do
    %Padrinamento{}
    |> Padrinamento.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a padrinamento.

  ## Examples

      iex> update_padrinamento(padrinamento, %{field: new_value})
      {:ok, %Padrinamento{}}

      iex> update_padrinamento(padrinamento, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_padrinamento(%Padrinamento{} = padrinamento, attrs) do
    padrinamento
    |> Padrinamento.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a padrinamento.

  ## Examples

      iex> delete_padrinamento(padrinamento)
      {:ok, %Padrinamento{}}

      iex> delete_padrinamento(padrinamento)
      {:error, %Ecto.Changeset{}}

  """
  def delete_padrinamento(%Padrinamento{} = padrinamento) do
    Repo.delete(padrinamento)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking padrinamento changes.

  ## Examples

      iex> change_padrinamento(padrinamento)
      %Ecto.Changeset{data: %Padrinamento{}}

  """
  def change_padrinamento(%Padrinamento{} = padrinamento, attrs \\ %{}) do
    Padrinamento.changeset(padrinamento, attrs)
  end
end
