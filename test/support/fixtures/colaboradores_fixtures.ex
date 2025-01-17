defmodule Protectora.ColaboradoresFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Protectora.Colaboradores` context.
  """

  @doc """
  Generate a colaborador.
  """
  def colaborador_fixture(attrs \\ %{}) do
    {:ok, colaborador} =
      attrs
      |> Enum.into(%{
        apelidos: "Rodríguez",
        codigoPostal: 36_860,
        dataNacemento: ~D[2001-05-14],
        direccion: "Canedo 32",
        email: "carla@udc.es",
        localidade: "Ponteareas",
        nome: "Carla",
        numeroConta: "ES12123412341234123412",
        perioricidade: "mensual"
      })
      |> Protectora.Colaboradores.create_colaborador()

    Protectora.Colaboradores.get_colaborador!(colaborador.id)
  end

  def colaborador_fixture_notloaded(attrs \\ %{}) do
    {:ok, colaborador} =
      attrs
      |> Enum.into(%{
        apelidos: "Rodríguez",
        codigoPostal: 36_860,
        dataNacemento: ~D[2001-05-14],
        direccion: "Canedo 32",
        email: "carla@udc.es",
        localidade: "Ponteareas",
        nome: "Carla",
        numeroConta: "ES12123412341234123412",
        perioricidade: "mensual"
      })
      |> Protectora.Colaboradores.create_colaborador()

    colaborador
  end
end
