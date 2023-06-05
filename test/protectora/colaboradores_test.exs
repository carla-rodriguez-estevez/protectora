defmodule Protectora.ColaboradoresTest do
  use Protectora.DataCase

  alias Protectora.Colaboradores

  describe "colaborador" do
    alias Protectora.Colaboradores.Colaborador

    import Protectora.ColaboradoresFixtures

    @invalid_attrs %{
      apelidos: nil,
      cantidadeAporte: nil,
      codigoPostal: nil,
      dataNacemento: nil,
      direccion: nil,
      email: nil,
      localidade: nil,
      nome: nil,
      numeroConta: nil,
      perioricidade: nil
    }

    test "list_colaborador/0 returns all colaborador" do
      colaborador = colaborador_fixture()
      assert Colaboradores.list_colaborador() == [colaborador]
    end

    test "get_colaborador!/1 returns the colaborador with given id" do
      colaborador = colaborador_fixture()
      assert Colaboradores.get_colaborador!(colaborador.id) == colaborador
    end

    test "create_colaborador/1 with valid data creates a colaborador" do
      valid_attrs = %{
        apelidos: "Rodríguez",
        codigoPostal: 36860,
        dataNacemento: ~D[2001-05-14],
        direccion: "Canedo 32",
        email: "carla@udc.es",
        localidade: "Ponteareas",
        nome: "Carla",
        numeroConta: "ES12123412341234123412",
        perioricidade: "mensual"
      }

      assert {:ok, %Colaborador{} = colaborador} = Colaboradores.create_colaborador(valid_attrs)
      assert colaborador.apelidos == "Rodríguez"
      assert colaborador.codigoPostal == 36860
      assert colaborador.dataNacemento == ~D[2001-05-14]
      assert colaborador.direccion == "Canedo 32"
      assert colaborador.email == "carla@udc.es"
      assert colaborador.localidade == "Ponteareas"
      assert colaborador.nome == "Carla"
      assert colaborador.numeroConta == "ES12123412341234123412"
      assert colaborador.perioricidade == "mensual"
    end

    test "create_colaborador/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Colaboradores.create_colaborador(@invalid_attrs)
    end

    test "update_colaborador/2 with valid data updates the colaborador" do
      colaborador = colaborador_fixture()

      update_attrs = %{
        apelidos: "Estévez",
        codigoPostal: 15_001,
        dataNacemento: ~D[1997-05-14],
        direccion: "Poeta Trillo Figueroa",
        email: "lucia@udc.es",
        localidade: "A Coruña",
        nome: "Lucia",
        numeroConta: "ES12123412341234123434",
        perioricidade: "trimestral"
      }

      assert {:ok, %Colaborador{} = colaborador} =
               Colaboradores.update_colaborador(colaborador, update_attrs)

      assert colaborador.apelidos == "Estévez"
      assert colaborador.cantidadeAporte == nil
      assert colaborador.codigoPostal == 15001
      assert colaborador.dataNacemento == ~D[1997-05-14]
      assert colaborador.direccion == "Poeta Trillo Figueroa"
      assert colaborador.email == "lucia@udc.es"
      assert colaborador.localidade == "A Coruña"
      assert colaborador.nome == "Lucia"
      assert colaborador.numeroConta == "ES12123412341234123434"
      assert colaborador.perioricidade == "trimestral"
    end

    test "update_colaborador/2 with invalid data returns error changeset" do
      colaborador = colaborador_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Colaboradores.update_colaborador(colaborador, @invalid_attrs)

      assert colaborador == Colaboradores.get_colaborador!(colaborador.id)
    end

    test "delete_colaborador/1 deletes the colaborador" do
      colaborador = colaborador_fixture()
      assert {:ok, %Colaborador{}} = Colaboradores.delete_colaborador(colaborador)
      assert_raise Ecto.NoResultsError, fn -> Colaboradores.get_colaborador!(colaborador.id) end
    end

    test "change_colaborador/1 returns a colaborador changeset" do
      colaborador = colaborador_fixture()
      assert %Ecto.Changeset{} = Colaboradores.change_colaborador(colaborador)
    end
  end
end
