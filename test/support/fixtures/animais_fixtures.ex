defmodule Protectora.AnimaisFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Protectora.Animais` context.
  """

  @doc """
  Generate a animal.
  """
  alias Protectora.Repo

  def animal_fixture(attrs \\ %{}) do
    {:ok, {:ok, animal}} =
      attrs
      |> Enum.into(%{
        descricion: "some descricion",
        eEspecial: true,
        eUrxente: true,
        idade: 2,
        madurez: "cachorro",
        nome: "some nome",
        peso: 12,
        raza: "some raza",
        tamano: "pequeno",
        tipo: "can"
      })
      |> Protectora.Animais.create_animal(fn _ -> [] end)

    Protectora.Animais.get_animal!(animal.id)
  end

  def animal_fixture_images(photos, attrs \\ %{}) do
    {:ok, {:ok, animal}} =
      attrs
      |> Enum.into(%{
        descricion: "some descricion",
        eEspecial: true,
        eUrxente: true,
        idade: 2,
        madurez: "cachorro",
        nome: "some nome",
        peso: 12,
        raza: "some raza",
        tamano: "pequeno",
        tipo: "can"
      })
      |> Protectora.Animais.create_animal(fn _ -> [] end)

    Enum.each(photos, fn el ->
      %Protectora.Animais.ImaxeAnimal{}
      |> Protectora.Animais.ImaxeAnimal.changeset(%{path_imaxe: el, animal_id: animal.id})
      |> Repo.insert()
    end)

    Protectora.Animais.get_animal!(animal.id)
  end
end
