defmodule ProtectoraWeb.PadrinamentoControllerTest do
  use ProtectoraWeb.ConnCase

  import Protectora.PadrinamentosFixtures
  import Protectora.AnimaisFixtures
  import Protectora.ColaboradoresFixtures
  import Protectora.VoluntariosFixtures

  alias Protectora.Padrinamentos.Padrinamento
  alias Protectora.Voluntarios.Voluntario

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
    setup [:create_voluntario]

    test "lists all padriñamento", %{conn: conn} do
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

      conn = get(conn, Routes.padrinamento_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create padrinamento" do
    setup [:create_voluntario]

    test "renders padrinamento when data is valid", %{conn: conn} do
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

      animal = animal_fixture()

      {:ok, colaborador} =
        %{}
        |> Enum.into(%{
          apelidos: "Rodríguez",
          codigoPostal: 36_860,
          dataNacemento: ~D[2001-05-14],
          direccion: "Canedo 32",
          email: "lucia2@udc.es",
          localidade: "Ponteareas",
          nome: "Carla",
          numeroConta: "ES12123412341234123412",
          perioricidade: "mensual"
        })
        |> Protectora.Colaboradores.create_colaborador()

      conn =
        post(conn, Routes.padrinamento_path(conn, :create),
          padrinamento: %{
            cantidade_aporte: "120.5",
            perioricidade: "mensual",
            animal_id: animal.id,
            colaborador_id: colaborador.id
          }
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.padrinamento_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "cantidade_aporte" => "120.5",
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

      conn = post(conn, Routes.padrinamento_path(conn, :create), padrinamento: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update padrinamento" do
    setup [:create_padrinamento]
    setup [:create_voluntario]

    test "renders padrinamento when data is valid", %{
      conn: conn,
      padrinamento: %Padrinamento{id: id} = padrinamento
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

      animal = animal_fixture()

      {:ok, colaborador} =
        %{}
        |> Enum.into(%{
          apelidos: "Rodríguez",
          codigoPostal: 36_860,
          dataNacemento: ~D[2001-05-14],
          direccion: "Canedo 32",
          email: "lucia2@udc.es",
          localidade: "Ponteareas",
          nome: "Carla",
          numeroConta: "ES12123412341234123412",
          perioricidade: "mensual"
        })
        |> Protectora.Colaboradores.create_colaborador()

      conn =
        put(conn, Routes.padrinamento_path(conn, :update, padrinamento),
          padrinamento: %{
            cantidade_aporte: "120.5",
            perioricidade: "anual",
            animal_id: animal.id,
            colaborador_id: colaborador.id
          }
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.padrinamento_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "cantidade_aporte" => "120.5",
               "perioricidade" => "anual"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, padrinamento: padrinamento} do
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
        put(conn, Routes.padrinamento_path(conn, :update, padrinamento),
          padrinamento: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete padrinamento" do
    setup [:create_voluntario]
    setup [:create_padrinamento]

    test "deletes chosen padrinamento", %{conn: conn, padrinamento: padrinamento} do
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

      conn = delete(conn, Routes.padrinamento_path(conn, :delete, padrinamento))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, Routes.padrinamento_path(conn, :show, padrinamento))
      end)
    end
  end

  defp create_voluntario(_) do
    voluntario = voluntario_fixture()
    %{voluntario: voluntario}
  end

  defp create_padrinamento(_) do
    padrinamento = padrinamento_fixture()
    %{padrinamento: padrinamento}
  end
end
