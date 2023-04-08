defmodule Protectora.RexistrosFixtures do
  import Protectora.AnimaisFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Protectora.Rexistros` context.
  """

  @doc """
  Generate a rexistro.
  """
  def rexistro_fixture(attrs \\ %{}) do
    animal = animal_fixture()

    {:ok, rexistro} =
      attrs
      |> Enum.into(%{
        descricion: "some descricion",
        prezo: 120.5,
        titulo: "some titulo",
        animal_id: animal.id
      })
      |> Protectora.Rexistros.create_rexistro()

    rexistro
  end
end
