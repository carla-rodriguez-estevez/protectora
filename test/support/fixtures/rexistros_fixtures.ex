defmodule Protectora.RexistrosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Protectora.Rexistros` context.
  """

  @doc """
  Generate a rexistro.
  """
  def rexistro_fixture(attrs \\ %{}) do
    {:ok, rexistro} =
      attrs
      |> Enum.into(%{
        descricion: "some descricion",
        prezo: 42,
        titulo: "some titulo"
      })
      |> Protectora.Rexistros.create_rexistro()

    rexistro
  end
end
