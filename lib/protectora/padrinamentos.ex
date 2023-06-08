defmodule Protectora.Padrinamentos do
  @moduledoc """
  The Padrinamentos context.
  """

  import Ecto.Query, warn: false
  alias Protectora.Colaboradores
  alias Protectora.Repo
  import Ecto.Changeset

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

  def list_padrinamento_paginated(params \\ []) do
    Repo.paginate(Padrinamento |> preload([:colaborador, :animal]), params)
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
  def get_padrinamento!(id) do
    Padrinamento |> where(id: ^id) |> preload([:colaborador, :animal]) |> Repo.one!()
  end

  @doc """
  Creates a padrinamento.
  ## Examples
      iex> create_padrinamento(%{field: value})
      {:ok, %Padrinamento{}}
      iex> create_padrinamento(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_padrinamento_simple(attrs \\ %{}) do
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
  def update_padrinamento_simple(%Padrinamento{} = padrinamento, attrs) do
    padrinamento
    |> Padrinamento.changeset(attrs)
    |> Repo.update()
  end

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

    perioricidade = attrs["perioricidade"]

    Map.put(attrs, :perioricidade, nil)

    case create_colaborador(email, attrs) do
      {:ok, colaborador} ->
        %Padrinamento{}
        |> Padrinamento.changeset(%{
          cantidade_aporte: attrs["cantidade_aporte"],
          perioricidade: perioricidade,
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
  def update_padrinamento(padrinamento, attrs) do
    email_attr = attrs["email"]

    email =
      if is_nil(email_attr) do
        ""
      else
        email_attr
      end

    case create_colaborador(email, attrs) do
      {:ok, colaborador} ->
        %Padrinamento{
          id: padrinamento.id,
          cantidade_aporte: padrinamento.cantidade_aporte,
          perioricidade: padrinamento.perioricidade,
          animal_id: padrinamento.animal_id,
          colaborador_id: colaborador.id
        }
        |> Padrinamento.changeset(%{
          cantidade_aporte: attrs["cantidade_aporte"],
          perioricidade: attrs["perioricidade"],
          animal_id: attrs["animal_id"],
          colaborador_id: colaborador.id
        })
        |> Repo.update()

      {:error, %Ecto.Changeset{} = error} ->
        {:error, error}
    end
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
    colaborador = Colaboradores.get_colaborador!(padrinamento.colaborador.id)

    resp = Repo.delete(padrinamento)

    if length(colaborador.padrinamento) == 1 and
         (is_nil(colaborador.cantidadeAporte) or is_nil(colaborador.perioricidade)) do
      Colaboradores.delete_colaborador(colaborador)
    end

    resp
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking padrinamento changes.

  ## Examples

      iex> change_padrinamento(padrinamento)
      %Ecto.Changeset{data: %Padrinamento{}}

  """
  def change_padrinamento(padrinamento, attrs \\ %{}) do
    padrinamento_result =
      Padrinamento.changeset(
        %Padrinamento{
          id: padrinamento.id,
          cantidade_aporte: padrinamento.cantidade_aporte,
          animal_id: padrinamento.animal_id,
          perioricidade: padrinamento.perioricidade
        },
        attrs
      )

    #   colaborador =
    #     Protectora.Colaboradores.Colaborador.changeset(
    #       %Protectora.Colaboradores.Colaborador{
    #         apelidos: padrinamento.apelidos,
    #         codigoPostal: padrinamento.codigoPostal,
    #         dataNacemento: padrinamento.dataNacemento,
    #         direccion: padrinamento.direccion,
    #         email: padrinamento.email,
    #         localidade: padrinamento.localidade,
    #         nome: padrinamento.nome,
    #         numeroConta: padrinamento.numeroConta
    #       },
    #       attrs
    #     )

    padrinamento_result
  end
end
