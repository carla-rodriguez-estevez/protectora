defmodule Protectora.PublicacionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Protectora.Publicacions` context.
  """

  @doc """
  Generate a publicacion.
  """
  alias Protectora.Repo

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

  def publicacion_fixture_images(photos, attrs \\ %{}) do
    {:ok, {:ok, publicacion}} =
      attrs
      |> Enum.into(%{
        contido: "some contido",
        titulo: "some titulo"
      })
      |> Protectora.Publicacions.create_publicacion(fn _ -> [] end)

    Enum.each(photos, fn el ->
      %Protectora.Publicacions.ImaxePublicacion{}
      |> Protectora.Publicacions.ImaxePublicacion.changeset(%{
        path_imaxe: el,
        publicacion_id: publicacion.id
      })
      |> Repo.insert()
    end)

    Protectora.Publicacions.get_publicacion!(publicacion.id)
  end
end
