defmodule Protectora.AnimaisFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Protectora.Animais` context.
  """

  @doc """
  Generate a animal.
  """
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
end
