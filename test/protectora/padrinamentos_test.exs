defmodule Protectora.PadrinamentosTest do
  use Protectora.DataCase

  alias Protectora.Padrinamentos
  import Protectora.AnimaisFixtures
  import Protectora.ColaboradoresFixtures

  describe "padrinamento" do
    alias Protectora.Padrinamentos.Padrinamento

    import Protectora.PadrinamentosFixtures

    @invalid_attrs %{cantidade_aporte: nil, perioricidade: nil}

    test "list_padrinamento/0 returns all padrinamento" do
      padrinamento = padrinamento_fixture()
      assert Padrinamentos.list_padrinamento() == [padrinamento]
    end

    test "get_padrinamento!/1 returns the padrinamento with given id" do
      padrinamento = padrinamento_fixture()
      assert Padrinamentos.get_padrinamento!(padrinamento.id) == padrinamento
    end

    test "create_padrinamento/1 with valid data creates a padrinamento" do
      animal = animal_fixture()
      colaborador = colaborador_fixture()

      valid_attrs = %{
        cantidade_aporte: "120.5",
        perioricidade: "some perioricidade",
        animal_id: animal.id,
        colaborador_id: colaborador.id
      }

      assert {:ok, %Padrinamento{} = padrinamento} =
               Padrinamentos.create_padrinamento(valid_attrs)

      assert padrinamento.cantidade_aporte == Decimal.new("120.5")
      assert padrinamento.perioricidade == "some perioricidade"
      assert padrinamento.animal_id == animal.id
      assert padrinamento.colaborador_id == colaborador.id
    end

    test "create_padrinamento/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Padrinamentos.create_padrinamento(@invalid_attrs)
    end

    test "update_padrinamento/2 with valid data updates the padrinamento" do
      padrinamento = padrinamento_fixture()
      update_attrs = %{cantidade_aporte: "456.7", perioricidade: "some updated perioricidade"}

      assert {:ok, %Padrinamento{} = padrinamento} =
               Padrinamentos.update_padrinamento(padrinamento, update_attrs)

      assert padrinamento.cantidade_aporte == Decimal.new("456.7")
      assert padrinamento.perioricidade == "some updated perioricidade"
    end

    test "update_padrinamento/2 with invalid data returns error changeset" do
      padrinamento = padrinamento_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Padrinamentos.update_padrinamento(padrinamento, @invalid_attrs)

      assert padrinamento == Padrinamentos.get_padrinamento!(padrinamento.id)
    end

    test "delete_padrinamento/1 deletes the padrinamento" do
      padrinamento = padrinamento_fixture()
      assert {:ok, %Padrinamento{}} = Padrinamentos.delete_padrinamento(padrinamento)
      assert_raise Ecto.NoResultsError, fn -> Padrinamentos.get_padrinamento!(padrinamento.id) end
    end

    test "change_padrinamento/1 returns a padrinamento changeset" do
      padrinamento = padrinamento_fixture()
      assert %Ecto.Changeset{} = Padrinamentos.change_padrinamento(padrinamento)
    end
  end
end
