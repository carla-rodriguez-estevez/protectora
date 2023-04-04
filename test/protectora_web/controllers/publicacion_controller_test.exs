defmodule ProtectoraWeb.PublicacionControllerTest do
  use ProtectoraWeb.ConnCase

  import Protectora.PublicacionsFixtures

  alias Protectora.Publicacions.Publicacion

  @create_attrs %{
    contido: "Contido exemplo",
    titulo: "Titulo de exemplo"
  }
  @update_attrs %{
    contido: "Contido exemplo",
    titulo: "Titulo de exemplo"
  }
  @invalid_attrs %{
    contido: nil,
    titulo: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all publicacion", %{conn: conn} do
      conn = get(conn, Routes.publicacion_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create publicacion" do
    test "renders publicacion when data is valid", %{conn: conn} do
      conn = post(conn, Routes.publicacion_path(conn, :create), publicacion: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.publicacion_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.publicacion_path(conn, :create), publicacion: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update publicacion" do
    setup [:create_publicacion]

    test "renders publicacion when data is valid", %{
      conn: conn,
      publicacion: %Publicacion{id: id} = publicacion
    } do
      conn =
        put(conn, Routes.publicacion_path(conn, :update, publicacion), publicacion: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.publicacion_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, publicacion: publicacion} do
      conn =
        put(conn, Routes.publicacion_path(conn, :update, publicacion), publicacion: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete publicacion" do
    setup [:create_publicacion]

    test "deletes chosen publicacion", %{conn: conn, publicacion: publicacion} do
      conn = delete(conn, Routes.publicacion_path(conn, :delete, publicacion))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.publicacion_path(conn, :show, publicacion))
      end
    end
  end

  defp create_publicacion(_) do
    publicacion = publicacion_fixture()
    %{publicacion: publicacion}
  end
end
