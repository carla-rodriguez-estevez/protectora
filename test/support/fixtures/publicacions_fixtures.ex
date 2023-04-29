defmodule Protectora.PublicacionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Protectora.Publicacions` context.
  """

  @doc """
  Generate a publicacion.
  """
  def publicacion_fixture(attrs \\ %{}) do
    {:ok, {:ok, publicacion}} =
      attrs
      |> Enum.into(%{
        contido: "some contido",
        titulo: "some titulo"
      })
      |> Protectora.Publicacions.create_publicacion(fn _ -> [] end)

    Protectora.Publicacions.get_publicacion!(publicacion.id)

  end
end
