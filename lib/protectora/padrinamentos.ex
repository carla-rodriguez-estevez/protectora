defmodule Protectora.Padrinamentos do
  @moduledoc """
  The Padrinamentos context.
  """

  import Ecto.Query, warn: false
  alias Protectora.Colaboradores
  alias Protectora.Repo

  require Logger
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

  defp existing_colaborador(colaborador, attr) do
    case(
      Colaboradores.update_colaborador(colaborador, %{
        apelidos: attr["apelidos"],
        codigoPostal: attr["codigoPostal"],
        dataNacemento: attr["dataNacemento"],
        direccion: attr["direccion"],
        email: attr["email"],
        localidade: attr["localidade"],
        nome: attr["nome"],
        numeroConta: attr["numeroConta"]
      })
    ) do
      {:ok, new_colaborador} -> {:ok, new_colaborador}
      {:error, _} -> {:ok, colaborador}
    end
  end

  defp create_colaborador(email, attr) do
    colaborador = Colaboradores.get_colaborador_by_email!(email)

    case is_nil(colaborador) do
      true ->
        attr
        |> Enum.into(%{})
        |> Protectora.Colaboradores.create_colaborador()

      false ->
        existing_colaborador(colaborador, attr)
    end
  end

  @doc """
  Creates a padrinamento.

  ## Examples

      iex> create_padrinamento(%{field: value})
      {:ok, %Padrinamento{}}

      iex> create_padrinamento(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_padrinamento(attrs \\ %{}) do
    email_attr = attrs["email"]

    email =
      if is_nil(email_attr) do
        ""
      else
        email_attr
      end

    case create_colaborador(email, attrs) do
      {:ok, colaborador} ->
        %Padrinamento{}
        |> Padrinamento.changeset(%{
          cantidade_aporte: attrs["cantidade_aporte"],
          perioricidade: attrs["perioricidade"],
          animal_id: attrs["animal_id"],
          colaborador_id: colaborador.id
        })
        |> Repo.insert()

      {:error, %Ecto.Changeset{} = error} ->
        {:error, error}
    end
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
  def change_padrinamento(padrinamento, attrs \\ %{}) do
    Logger.warn(padrinamento)
    Padrinamento.changeset(padrinamento, attrs)
  end
end
