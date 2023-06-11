defmodule Protectora.RexistrosTest do
  use Protectora.DataCase

  alias Protectora.Rexistros

  describe "rexistro" do
    alias Protectora.Rexistros.Rexistro

    import Protectora.RexistrosFixtures
    import Protectora.AnimaisFixtures

    @invalid_attrs %{descricion: nil, prezo: nil, titulo: nil}

    test "list_rexistro/0 returns all rexistro" do
      rexistro = rexistro_fixture()
      assert Rexistros.list_rexistro() == [rexistro]
    end

    test "get_rexistro!/1 returns the rexistro with given id" do
      rexistro = rexistro_fixture()
      rexistro2 = Rexistros.get_rexistro!(rexistro.id)

      assert rexistro2.descricion == rexistro.descricion
      assert rexistro2.prezo == rexistro.prezo
      assert rexistro2.titulo == rexistro.titulo
      assert rexistro2.animal_id == rexistro.animal_id
    end

    test "create_rexistro/1 with valid data creates a rexistro" do
      animal = animal_fixture()

      valid_attrs = %{
        descricion: "some descricion",
        prezo: 120.5,
        titulo: "some titulo",
        animal_id: animal.id
      }

      assert {:ok, %Rexistro{} = rexistro} = Rexistros.create_rexistro(valid_attrs)
      assert rexistro.descricion == "some descricion"
      assert rexistro.prezo == 120.5
      assert rexistro.titulo == "some titulo"
      assert rexistro.animal_id == animal.id
    end

    test "create_rexistro/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rexistros.create_rexistro(@invalid_attrs)
    end

    test "update_rexistro/2 with valid data updates the rexistro" do
      rexistro = rexistro_fixture()

      update_attrs = %{
        descricion: "some updated descricion",
        prezo: 456.7,
        titulo: "some updated titulo"
      }

      assert {:ok, %Rexistro{} = rexistro} = Rexistros.update_rexistro(rexistro, update_attrs)
      assert rexistro.descricion == "some updated descricion"
      assert rexistro.prezo == 456.7
      assert rexistro.titulo == "some updated titulo"
    end

    test "update_rexistro/2 with invalid data returns error changeset" do
      rexistro = rexistro_fixture()
      rexistro2 = Rexistros.get_rexistro!(rexistro.id)

      assert {:error, %Ecto.Changeset{}} = Rexistros.update_rexistro(rexistro, @invalid_attrs)

      assert rexistro2.descricion == rexistro.descricion
      assert rexistro2.prezo == rexistro.prezo
      assert rexistro2.titulo == rexistro.titulo
      assert rexistro2.animal_id == rexistro.animal_id
    end

    test "delete_rexistro/1 deletes the rexistro" do
      rexistro = rexistro_fixture()
      assert {:ok, %Rexistro{}} = Rexistros.delete_rexistro(rexistro)
      assert_raise Ecto.NoResultsError, fn -> Rexistros.get_rexistro!(rexistro.id) end
    end

    test "change_rexistro/1 returns a rexistro changeset" do
      rexistro = rexistro_fixture()
      assert %Ecto.Changeset{} = Rexistros.change_rexistro(rexistro)
    end
  end
end
