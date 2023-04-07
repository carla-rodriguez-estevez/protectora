defmodule Protectora.RexistrosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Protectora.Rexistros` context.
  """

  @doc """
  Generate a rexistro.
  """
  import Protectora.AnimaisFixtures

  def rexistro_fixture(attrs \\ %{}) do
    animal = animal_fixture()

    {:ok, rexistro} =
      attrs
      |> Enum.into(%{
        descricion: "some descricion",
        prezo: 42,
        titulo: "some titulo",
        animal_id: animal.id
      })
      |> Protectora.Rexistros.create_rexistro()

    rexistro
  end
end
