defmodule Protectora.VoluntariosTest do
  use Protectora.DataCase

  alias Protectora.Voluntarios

  describe "voluntario" do
    alias Protectora.Voluntarios.Voluntario

    import Protectora.VoluntariosFixtures

    @invalid_attrs %{contrasinal: nil, email: nil, nome: nil}

    test "list_voluntario/0 returns all voluntario" do
      voluntario = voluntario_fixture()
      assert Voluntarios.list_voluntario() == [voluntario]
    end

    test "get_voluntario!/1 returns the voluntario with given id" do
      voluntario = voluntario_fixture()
      assert Voluntarios.get_voluntario!(voluntario.id) == voluntario
    end

    test "create_voluntario/1 with valid data creates a voluntario" do
      valid_attrs = %{contrasinal: "some contrasinal", email: "some email", nome: "some nome"}

      assert {:ok, %Voluntario{} = voluntario} = Voluntarios.create_voluntario(valid_attrs)
      assert voluntario.contrasinal == "some contrasinal"
      assert voluntario.email == "some email"
      assert voluntario.nome == "some nome"
    end

    test "create_voluntario/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Voluntarios.create_voluntario(@invalid_attrs)
    end

    test "update_voluntario/2 with valid data updates the voluntario" do
      voluntario = voluntario_fixture()
      update_attrs = %{contrasinal: "some updated contrasinal", email: "some updated email", nome: "some updated nome"}

      assert {:ok, %Voluntario{} = voluntario} = Voluntarios.update_voluntario(voluntario, update_attrs)
      assert voluntario.contrasinal == "some updated contrasinal"
      assert voluntario.email == "some updated email"
      assert voluntario.nome == "some updated nome"
    end

    test "update_voluntario/2 with invalid data returns error changeset" do
      voluntario = voluntario_fixture()
      assert {:error, %Ecto.Changeset{}} = Voluntarios.update_voluntario(voluntario, @invalid_attrs)
      assert voluntario == Voluntarios.get_voluntario!(voluntario.id)
    end

    test "delete_voluntario/1 deletes the voluntario" do
      voluntario = voluntario_fixture()
      assert {:ok, %Voluntario{}} = Voluntarios.delete_voluntario(voluntario)
      assert_raise Ecto.NoResultsError, fn -> Voluntarios.get_voluntario!(voluntario.id) end
    end

    test "change_voluntario/1 returns a voluntario changeset" do
      voluntario = voluntario_fixture()
      assert %Ecto.Changeset{} = Voluntarios.change_voluntario(voluntario)
    end
  end
end
