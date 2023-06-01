defmodule ProtectoraWeb.PublicacionControllerTest do
  use ProtectoraWeb.ConnCase

  import Protectora.PublicacionsFixtures

  alias Protectora.Publicacions.Publicacion
  alias Protectora.Voluntarios.Voluntario
  import Protectora.VoluntariosFixtures

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
    setup [:create_voluntario]

    test "renders publicacion when data is valid", %{conn: conn} do
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
        post(conn, Routes.publicacion_path(conn, :create), %{
          publicacion: @create_attrs,
          imaxes: []
        })

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.publicacion_path(conn, :show, id))

      assert %{
               "id" => ^id
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

      conn =
        post(conn, Routes.publicacion_path(conn, :create), publicacion: @invalid_attrs, imaxes: [])

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update publicacion" do
    setup [:create_publicacion]
    setup [:create_voluntario]

    test "renders publicacion when data is valid", %{
      conn: conn,
      publicacion: %Publicacion{id: id} = publicacion
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
        put(conn, Routes.publicacion_path(conn, :update, publicacion), %{
          publicacion: @update_attrs,
          imaxes: []
        })

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.publicacion_path(conn, :show, id))

      assert %{"id" => ^id} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, publicacion: publicacion} do
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
        put(conn, Routes.publicacion_path(conn, :update, publicacion), %{
          publicacion: @update_attrs,
          imaxes: []
        })

      conn =
        put(conn, Routes.publicacion_path(conn, :update, publicacion), %{
          publicacion: @invalid_attrs,
          imaxes: []
        })

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete publicacion" do
    setup [:create_publicacion]
    setup [:create_voluntario]

    test "deletes chosen publicacion", %{conn: conn, publicacion: publicacion} do
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

  defp create_voluntario(_) do
    voluntario = voluntario_fixture()
    %{voluntario: voluntario}
  end
end
