defmodule Protectora.Colaboradores do
  @moduledoc """
  The Colaboradores context.
  """

  import Ecto.Query, warn: false
  alias Protectora.Repo

  alias Protectora.Colaboradores.Colaborador
  alias Protectora.Padrinamentos

  @doc """
  Returns the list of colaborador.

  ## Examples

      iex> list_colaborador()
      [%Colaborador{}, ...]

  """
  def list_colaborador do
    Repo.all(Colaborador)
  end

  def list_colaborador_paginated(params \\ []) do
    Repo.paginate(Colaborador, params)
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
  def get_colaborador!(id),
    do: Colaborador |> where(id: ^id) |> preload([:padrinamento]) |> Repo.one!()

  def get_colaborador_by_email!(email), do: Colaborador |> where(email: ^email) |> Repo.one()

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
    |> broadcast(:colaborador_created)
  end

  def create_colaborador(attrs, :full_check) do
    %Colaborador{}
    |> Colaborador.complete_changeset(attrs)
    |> Repo.insert()
    |> broadcast(:colaborador_created)
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
    |> broadcast(:colaborador_updated)
  end

  def update_colaborador(%Colaborador{} = colaborador, attrs, :full_check) do
    colaborador
    |> Colaborador.complete_changeset(attrs)
    |> Repo.update()
    |> broadcast(:colaborador_updated)
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
    {:ok, resp} = Repo.transaction(fn _ -> delete_colaborador_completed(colaborador) end)

    resp
  end

  defp delete_colaborador_completed(colaborador) do
    colaborador_full = get_colaborador!(colaborador.id)
    padrinamentos = colaborador_full.padrinamento

    if length(padrinamentos) == 0 do
      Repo.delete(colaborador) |> broadcast(:colaborador_deleted)
    else
      update_colaborador(colaborador, %{perioricidade: nil, cantidadeAporte: nil})
      |> broadcast(:colaborador_deleted)
    end
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

  def subscribe do
    Phoenix.PubSub.subscribe(Protectora.PubSub, "colaboradores")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(Protectora.PubSub, "colaboradores", {event, post})
    {:ok, post}
  end
end
