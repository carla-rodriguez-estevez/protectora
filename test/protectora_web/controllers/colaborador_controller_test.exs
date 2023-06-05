defmodule ProtectoraWeb.ColaboradorControllerTest do
  use ProtectoraWeb.ConnCase

  import Protectora.ColaboradoresFixtures
  import Protectora.VoluntariosFixtures

  alias Protectora.Colaboradores.Colaborador
  alias Protectora.Voluntarios.Voluntario

  @create_attrs %{
    apelidos: "Rodríguez",
    codigoPostal: 36860,
    dataNacemento: ~D[2001-05-14],
    direccion: "Canedo 32",
    email: "carla@udc.es",
    localidade: "Ponteareas",
    nome: "Carla",
    numeroConta: "ES12123412341234123412",
    perioricidade: "mensual",
    cantidadeAporte: 12
  }
  @update_attrs %{
    apelidos: "Estévez",
    codigoPostal: 15001,
    dataNacemento: ~D[1997-05-14],
    direccion: "Poeta Trillo Figueroa",
    email: "lucia@udc.es",
    localidade: "A Coruña",
    nome: "Lucia",
    numeroConta: "ES12123412341234123434",
    perioricidade: "trimestral",
    cantidadeAporte: 12
  }
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
    perioricidade: nil,
    cantidadeAporte: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_voluntario]

    test "lists all colaborador", %{conn: conn} do
      {:ok, account, jwt} =
        ProtectoraWeb.Auth.Guardian.authenticate("some@email.com", "some contrasinal")

      conn =
        conn
        |> Plug.Test.init_test_session(%{})
        |> put_session(:account_id, account.id)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt}")

      conn = get(conn, Routes.colaborador_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create colaborador" do
    setup [:create_voluntario]

    test "renders colaborador when data is valid", %{conn: conn} do
      {:ok, account, jwt} =
        ProtectoraWeb.Auth.Guardian.authenticate("some@email.com", "some contrasinal")

      conn =
        conn
        |> Plug.Test.init_test_session(%{})
        |> put_session(:account_id, account.id)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt}")

      conn = post(conn, Routes.colaborador_path(conn, :create), colaborador: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.colaborador_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "apelidos" => "Rodríguez",
               "codigoPostal" => 36860,
               "dataNacemento" => "2001-05-14",
               "direccion" => "Canedo 32",
               "email" => "carla@udc.es",
               "localidade" => "Ponteareas",
               "nome" => "Carla",
               "numeroConta" => "ES12123412341234123412",
               "perioricidade" => "mensual"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      {:ok, account, jwt} =
        ProtectoraWeb.Auth.Guardian.authenticate("some@email.com", "some contrasinal")

      conn =
        conn
        |> Plug.Test.init_test_session(%{})
        |> put_session(:account_id, account.id)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt}")

      conn = post(conn, Routes.colaborador_path(conn, :create), colaborador: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update colaborador" do
    setup [:create_voluntario]
    setup [:create_colaborador]

    test "renders colaborador when data is valid", %{
      conn: conn,
      colaborador: %Colaborador{id: id} = colaborador
    } do
      {:ok, account, jwt} =
        ProtectoraWeb.Auth.Guardian.authenticate("some@email.com", "some contrasinal")

      conn =
        conn
        |> Plug.Test.init_test_session(%{})
        |> put_session(:account_id, account.id)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt}")

      conn =
        put(conn, Routes.colaborador_path(conn, :update, colaborador), colaborador: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.colaborador_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "apelidos" => "Estévez",
               "codigoPostal" => 15001,
               "dataNacemento" => "1997-05-14",
               "direccion" => "Poeta Trillo Figueroa",
               "email" => "lucia@udc.es",
               "localidade" => "A Coruña",
               "nome" => "Lucia",
               "numeroConta" => "ES12123412341234123434",
               "perioricidade" => "trimestral"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, colaborador: colaborador} do
      {:ok, account, jwt} =
        ProtectoraWeb.Auth.Guardian.authenticate("some@email.com", "some contrasinal")

      conn =
        conn
        |> Plug.Test.init_test_session(%{})
        |> put_session(:account_id, account.id)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt}")

      conn =
        put(conn, Routes.colaborador_path(conn, :update, colaborador), colaborador: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete colaborador" do
    setup [:create_voluntario]
    setup [:create_colaborador]

    test "deletes chosen colaborador", %{conn: conn, colaborador: colaborador} do
      {:ok, account, jwt} =
        ProtectoraWeb.Auth.Guardian.authenticate("some@email.com", "some contrasinal")

      conn =
        conn
        |> Plug.Test.init_test_session(%{})
        |> put_session(:account_id, account.id)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt}")

      conn = delete(conn, Routes.colaborador_path(conn, :delete, colaborador))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, Routes.colaborador_path(conn, :show, colaborador))
      end)
    end
  end

  defp create_voluntario(_) do
    voluntario = voluntario_fixture()
    %{voluntario: voluntario}
  end

  defp create_colaborador(_) do
    colaborador = colaborador_fixture()
    %{colaborador: colaborador}
  end
end
