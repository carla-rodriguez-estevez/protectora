defmodule ProtectoraWeb.VoluntarioControllerTest do
  use ProtectoraWeb.ConnCase

  import Protectora.VoluntariosFixtures

  alias Protectora.Voluntarios.Voluntario

  @create_attrs %{
    contrasinal: "some contrasinal",
    email: "some@email.com",
    nome: "some nome"
  }
  @update_attrs %{
    contrasinal: "some updated contrasinal",
    email: "someupdated@email.com",
    nome: "some updated nome"
  }
  @invalid_attrs %{contrasinal: nil, email: nil, nome: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all voluntario", %{conn: conn} do
      conn = get(conn, Routes.voluntario_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create voluntario" do
    test "renders voluntario when data is valid", %{conn: conn} do
      conn = post(conn, Routes.voluntario_path(conn, :create), voluntario: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.voluntario_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "contrasinal" => "some contrasinal",
               "email" => "some@email.com",
               "nome" => "some nome"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.voluntario_path(conn, :create), voluntario: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update voluntario" do
    setup [:create_voluntario]

    test "renders voluntario when data is valid", %{
      conn: conn,
      voluntario: %Voluntario{id: id} = voluntario
    } do
      conn =
        put(conn, Routes.voluntario_path(conn, :update, voluntario), voluntario: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.voluntario_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "contrasinal" => "some updated contrasinal",
               "email" => "someupdated@email.com",
               "nome" => "some updated nome"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, voluntario: voluntario} do
      conn =
        put(conn, Routes.voluntario_path(conn, :update, voluntario), voluntario: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete voluntario" do
    setup [:create_voluntario]

    test "deletes chosen voluntario", %{conn: conn, voluntario: voluntario} do
      conn = delete(conn, Routes.voluntario_path(conn, :delete, voluntario))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.voluntario_path(conn, :show, voluntario))
      end
    end
  end

  defp create_voluntario(_) do
    voluntario = voluntario_fixture()
    %{voluntario: voluntario}
  end
end
