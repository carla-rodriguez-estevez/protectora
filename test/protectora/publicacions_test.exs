defmodule Protectora.PublicacionsTest do
  use Protectora.DataCase

  alias Protectora.Publicacions

  describe "publicacion" do
    alias Protectora.Publicacions.Publicacion

    import Protectora.PublicacionsFixtures

    @invalid_attrs %{contido: nil, titulo: nil}

    test "list_publicacion/0 returns all publicacion" do
      publicacion = publicacion_fixture()
      assert Publicacions.list_publicacion() == [publicacion]
    end

    test "get_publicacion!/1 returns the publicacion with given id" do
      publicacion = publicacion_fixture()
      assert Publicacions.get_publicacion!(publicacion.id) == publicacion
    end

    test "create_publicacion/1 with valid data creates a publicacion" do
      valid_attrs = %{contido: "some contido", titulo: "some titulo"}

      assert {:ok, %Publicacion{} = publicacion} = Publicacions.create_publicacion(valid_attrs)
      assert publicacion.contido == "some contido"
      assert publicacion.titulo == "some titulo"
    end

    test "create_publicacion/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Publicacions.create_publicacion(@invalid_attrs)
    end

    test "update_publicacion/2 with valid data updates the publicacion" do
      publicacion = publicacion_fixture()
      update_attrs = %{contido: "some updated contido", titulo: "some updated titulo"}

      assert {:ok, %Publicacion{} = publicacion} = Publicacions.update_publicacion(publicacion, update_attrs)
      assert publicacion.contido == "some updated contido"
      assert publicacion.titulo == "some updated titulo"
    end

    test "update_publicacion/2 with invalid data returns error changeset" do
      publicacion = publicacion_fixture()
      assert {:error, %Ecto.Changeset{}} = Publicacions.update_publicacion(publicacion, @invalid_attrs)
      assert publicacion == Publicacions.get_publicacion!(publicacion.id)
    end

    test "delete_publicacion/1 deletes the publicacion" do
      publicacion = publicacion_fixture()
      assert {:ok, %Publicacion{}} = Publicacions.delete_publicacion(publicacion)
      assert_raise Ecto.NoResultsError, fn -> Publicacions.get_publicacion!(publicacion.id) end
    end

    test "change_publicacion/1 returns a publicacion changeset" do
      publicacion = publicacion_fixture()
      assert %Ecto.Changeset{} = Publicacions.change_publicacion(publicacion)
    end
  end
end
