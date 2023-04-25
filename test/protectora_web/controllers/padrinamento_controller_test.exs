defmodule ProtectoraWeb.PadrinamentoControllerTest do
  use ProtectoraWeb.ConnCase

  import Protectora.PadrinamentosFixtures

  alias Protectora.Padrinamentos.Padrinamento

  @create_attrs %{
    cantidade_aporte: "120.5",
    perioricidade: "some perioricidade"
  }
  @update_attrs %{
    cantidade_aporte: "456.7",
    perioricidade: "some updated perioricidade"
  }
  @invalid_attrs %{cantidade_aporte: nil, perioricidade: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all padriñamento", %{conn: conn} do
      conn = get(conn, Routes.padrinamento_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create padrinamento" do
    test "renders padrinamento when data is valid", %{conn: conn} do
      conn = post(conn, Routes.padrinamento_path(conn, :create), padrinamento: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.padrinamento_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "cantidade_aporte" => "120.5",
               "perioricidade" => "some perioricidade"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.padrinamento_path(conn, :create), padrinamento: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update padrinamento" do
    setup [:create_padrinamento]

    test "renders padrinamento when data is valid", %{conn: conn, padrinamento: %Padrinamento{id: id} = padrinamento} do
      conn = put(conn, Routes.padrinamento_path(conn, :update, padrinamento), padrinamento: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.padrinamento_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "cantidade_aporte" => "456.7",
               "perioricidade" => "some updated perioricidade"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, padrinamento: padrinamento} do
      conn = put(conn, Routes.padrinamento_path(conn, :update, padrinamento), padrinamento: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete padrinamento" do
    setup [:create_padrinamento]

    test "deletes chosen padrinamento", %{conn: conn, padrinamento: padrinamento} do
      conn = delete(conn, Routes.padrinamento_path(conn, :delete, padrinamento))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.padrinamento_path(conn, :show, padrinamento))
      end
    end
  end

  defp create_padrinamento(_) do
    padrinamento = padrinamento_fixture()
    %{padrinamento: padrinamento}
  end
end
