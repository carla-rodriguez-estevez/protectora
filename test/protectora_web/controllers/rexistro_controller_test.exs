defmodule ProtectoraWeb.RexistroControllerTest do
  use ProtectoraWeb.ConnCase

  import Protectora.RexistrosFixtures
  import Protectora.AnimaisFixtures

  alias Protectora.Rexistros.Rexistro

  @create_attrs %{
    descricion: "some descricion",
    prezo: 120.5,
    titulo: "some titulo"
  }
  @update_attrs %{
    descricion: "some updated descricion",
    prezo: 456.7,
    titulo: "some updated titulo"
  }
  @invalid_attrs %{descricion: nil, prezo: nil, titulo: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all rexistro", %{conn: conn} do
      conn = get(conn, Routes.rexistro_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create rexistro" do
    test "renders rexistro when data is valid", %{conn: conn} do
      animal = animal_fixture()

      conn =
        post(conn, Routes.rexistro_path(conn, :create),
          rexistro: %{
            descricion: "some descricion",
            prezo: 120.5,
            titulo: "some titulo",
            animal_id: animal.id
          }
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.rexistro_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "descricion" => "some descricion",
               "prezo" => 120.5,
               "titulo" => "some titulo"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.rexistro_path(conn, :create), rexistro: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update rexistro" do
    setup [:create_rexistro]

    test "renders rexistro when data is valid", %{
      conn: conn,
      rexistro: %Rexistro{id: id} = rexistro
    } do
      conn = put(conn, Routes.rexistro_path(conn, :update, rexistro), rexistro: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.rexistro_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "descricion" => "some updated descricion",
               "prezo" => 456.7,
               "titulo" => "some updated titulo"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, rexistro: rexistro} do
      conn = put(conn, Routes.rexistro_path(conn, :update, rexistro), rexistro: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete rexistro" do
    setup [:create_rexistro]

    test "deletes chosen rexistro", %{conn: conn, rexistro: rexistro} do
      conn = delete(conn, Routes.rexistro_path(conn, :delete, rexistro))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.rexistro_path(conn, :show, rexistro))
      end
    end
  end

  defp create_rexistro(_) do
    rexistro = rexistro_fixture()
    %{rexistro: rexistro}
  end
end
