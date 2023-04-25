defmodule Protectora.PadrinamentosFixtures do
  import Protectora.AnimaisFixtures
  import Protectora.ColaboradoresFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Protectora.Padrinamentos` context.
  """

  @doc """
  Generate a padrinamento.
  """
  def padrinamento_fixture(attrs \\ %{}) do
    animal = animal_fixture()
    colaborador = colaborador_fixture()

    {:ok, padrinamento} =
      attrs
      |> Enum.into(%{
        cantidade_aporte: "120.5",
        perioricidade: "some perioricidade",
        animal_id: animal.id,
        colaborador_id: colaborador.id
      })
      |> Protectora.Padrinamentos.create_padrinamento()

    padrinamento
  end
end
