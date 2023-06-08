defmodule Protectora.Animais do
  @moduledoc """
  The Animais context.
  """

  import Ecto.Query, warn: false
  alias Protectora.Repo

  alias Protectora.Animais.Animal
  alias Protectora.Animais.ImaxeAnimal
  alias Protectora.Padrinamentos

  require Logger

  @doc """
  Returns the list of animal.

  ## Examples

      iex> list_animal()
      [%Animal{}, ...]

  """
  def list_animal do
    Repo.all(Animal)
  end

  def list_animal_paginated(params \\ []) do
    Repo.paginate(Animal |> preload([:imaxe_animal]), params)
  end

  @doc """
  Gets a single animal.

  Raises `Ecto.NoResultsError` if the Animal does not exist.

  ## Examples

      iex> get_animal!(123)
      %Animal{}

      iex> get_animal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_animal!(id) do
    Animal
    |> where(id: ^id)
    |> preload([:rexistro, :imaxe_animal, padrinamento: :colaborador])
    |> Repo.one!()
  end

  @doc """
  Creates a animal.

  ## Examples

      iex> create_animal(%{field: value})
      {:ok, %Animal{}}

      iex> create_animal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_animal(attrs \\ %{}, after_save \\ &{:ok, &1}) do
    Repo.transaction(fn -> create_full_animal(attrs, after_save) end)
  end

  defp create_full_animal(attrs \\ %{}, after_save \\ &{:ok, &1}) do
    resp =
      %Animal{}
      |> Animal.changeset(attrs)
      |> Repo.insert()
      |> after_save(after_save)
      |> broadcast(:animal_created)

    resp
  end

  defp after_save({:ok, animal}, func) do
    photos = func.(animal)

    completed =
      Enum.each(photos, fn el ->
        %ImaxeAnimal{}
        |> ImaxeAnimal.changeset(%{path_imaxe: el, animal_id: animal.id})
        |> Repo.insert()
      end)

    {:ok, animal}
  end

  defp after_save(error, _func), do: error

  @doc """
  Updates a animal.

  ## Examples

      iex> update_animal(animal, %{field: new_value})
      {:ok, %Animal{}}

      iex> update_animal(animal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_animal(%Animal{} = animal, attrs, after_update \\ &{:ok, &1}) do
    Repo.transaction(fn -> update_full_animal(animal, attrs, after_update) end)
  end

  defp update_full_animal(%Animal{} = animal, attrs, after_update \\ &{:ok, &1}) do
    animal
    |> Animal.changeset(attrs)
    |> Repo.update()
    |> after_update(after_update)
    |> broadcast(:animal_updated)
  end

  defp after_update({:ok, animal}, func) do
    photos = func.(animal)

    case photos do
      [] ->
        {:ok, animal}

      _ ->
        Enum.each(animal.imaxe_animal, fn el -> el |> Repo.delete() end)

        Enum.each(photos, fn el ->
          %ImaxeAnimal{}
          |> ImaxeAnimal.changeset(%{path_imaxe: el, animal_id: animal.id})
          |> Repo.insert()
        end)

        {:ok, animal}
    end
  end

  defp after_update(error, _func), do: error

  @doc """
  Deletes a animal.

  ## Examples

      iex> delete_animal(animal)
      {:ok, %Animal{}}

      iex> delete_animal(animal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_animal(%Animal{} = animal) do
    Repo.transaction(fn -> delete_full_animal(animal) end)
  end

  defp delete_full_animal(%Animal{} = animal) do
    imaxes = animal.imaxe_animal

    padrinamentos = animal.padrinamento

    deleted_animal = Repo.get!(Animal, animal.id)

    Enum.each(padrinamentos, fn padrinamento ->
      Padrinamentos.delete_padrinamento(padrinamento)
    end)

    Enum.each(imaxes, fn el ->
      File.rm(Path.join(["priv/static", el.path_imaxe]))
    end)

    Repo.delete(deleted_animal)
    |> broadcast(:animal_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking animal changes.

  ## Examples

      iex> change_animal(animal)
      %Ecto.Changeset{data: %Animal{}}

  """
  def change_animal(%Animal{} = animal, attrs \\ %{}) do
    Animal.changeset(animal, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Protectora.PubSub, "animais")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(Protectora.PubSub, "animais", {event, post})
    {:ok, post}
  end
end
