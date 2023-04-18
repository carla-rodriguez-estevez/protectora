defmodule ProtectoraWeb.ImaxePublicacionControllerTest do
  use ProtectoraWeb.ConnCase

  import Protectora.PublicacionsFixtures

  alias Protectora.Publicacions.ImaxePublicacion

  @create_attrs %{
    path_imaxe: "some path_imaxe"
  }
  @update_attrs %{
    path_imaxe: "some updated path_imaxe"
  }
  @invalid_attrs %{path_imaxe: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all imaxe_publicacion", %{conn: conn} do
      conn = get(conn, Routes.imaxe_publicacion_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create imaxe_publicacion" do
    test "renders imaxe_publicacion when data is valid", %{conn: conn} do
      conn = post(conn, Routes.imaxe_publicacion_path(conn, :create), imaxe_publicacion: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.imaxe_publicacion_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "path_imaxe" => "some path_imaxe"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.imaxe_publicacion_path(conn, :create), imaxe_publicacion: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update imaxe_publicacion" do
    setup [:create_imaxe_publicacion]

    test "renders imaxe_publicacion when data is valid", %{conn: conn, imaxe_publicacion: %ImaxePublicacion{id: id} = imaxe_publicacion} do
      conn = put(conn, Routes.imaxe_publicacion_path(conn, :update, imaxe_publicacion), imaxe_publicacion: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.imaxe_publicacion_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "path_imaxe" => "some updated path_imaxe"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, imaxe_publicacion: imaxe_publicacion} do
      conn = put(conn, Routes.imaxe_publicacion_path(conn, :update, imaxe_publicacion), imaxe_publicacion: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete imaxe_publicacion" do
    setup [:create_imaxe_publicacion]

    test "deletes chosen imaxe_publicacion", %{conn: conn, imaxe_publicacion: imaxe_publicacion} do
      conn = delete(conn, Routes.imaxe_publicacion_path(conn, :delete, imaxe_publicacion))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.imaxe_publicacion_path(conn, :show, imaxe_publicacion))
      end
    end
  end

  defp create_imaxe_publicacion(_) do
    imaxe_publicacion = imaxe_publicacion_fixture()
    %{imaxe_publicacion: imaxe_publicacion}
  end
end
