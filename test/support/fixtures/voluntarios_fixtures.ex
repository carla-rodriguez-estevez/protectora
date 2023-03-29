defmodule Protectora.VoluntariosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Protectora.Voluntarios` context.
  """

  @doc """
  Generate a voluntario.
  """
  def voluntario_fixture(attrs \\ %{}) do
    {:ok, voluntario} =
      attrs
      |> Enum.into(%{
        contrasinal: "some contrasinal",
        email: "some email",
        nome: "some nome"
      })
      |> Protectora.Voluntarios.create_voluntario()

    voluntario
  end
end
