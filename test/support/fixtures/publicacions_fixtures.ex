defmodule Protectora.PublicacionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Protectora.Publicacions` context.
  """

  @doc """
  Generate a publicacion.
  """
  def publicacion_fixture(attrs \\ %{}) do
    {:ok, publicacion} =
      attrs
      |> Enum.into(%{
        contido: "some contido",
        titulo: "some titulo"
      })
      |> Protectora.Publicacions.create_publicacion()

    publicacion
  end
end
