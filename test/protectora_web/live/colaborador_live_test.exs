defmodule ProtectoraWeb.ColaboradorLiveTest do
  use ProtectoraWeb.ConnCase

  import Phoenix.LiveViewTest
  import Protectora.ColaboradoresFixtures
  alias Protectora.Accounts
  alias ProtectoraWeb.UserAuth
  import Protectora.AccountsFixtures

  ##  @create_attrs %{
  #    apelidos: "Rodríguez",
  #    codigoPostal: 36_860,
  #    dataNacemento: %{day: 14, month: 5, year: 2001},
  #    direccion: "Canedo 32",
  #    email: "carla@udc.es",
  #    localidade: "Ponteareas",
  #    nome: "Carla",
  #    numeroConta: "ES12123412341234123412",
  #    perioricidade: "Mensual"
  #  }

  @update_attrs %{
    apelidos: "Estévez",
    codigoPostal: 15_001,
    dataNacemento: "2023-04-12",
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
    codigoPostal: nil,
    dataNacemento: nil,
    direccion: nil,
    email: nil,
    localidade: nil,
    nome: nil,
    numeroConta: "ES20"
  }

  defp create_colaborador(_) do
    colaborador = colaborador_fixture()
    %{colaborador: colaborador}
  end

  describe "Index" do
    setup [:create_colaborador]

    test "lists all colaborador", %{conn: conn, colaborador: colaborador} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, _index_live, html} = live(conn, Routes.colaborador_index_path(conn, :index))

      assert html =~ "Lista de colaboradores"
      assert html =~ colaborador.apelidos
    end

    test "updates colaborador in listing", %{conn: conn, colaborador: colaborador} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.colaborador_index_path(conn, :index))

      assert index_live |> element("#colaborador-#{colaborador.id} a", "Editar") |> render_click() =~
               "Editar colaborador"

      assert_patch(index_live, Routes.colaborador_index_path(conn, :edit, colaborador))

      assert index_live
             |> form("#colaborador-form", colaborador: @invalid_attrs)
             |> render_change() =~ "non pode estar valeiro"

      {:ok, _, html} =
        index_live
        |> form("#colaborador-form", colaborador: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, "/colaborador?colaboradores=1")

      assert html =~ "Colaborador actualizado correctamente"
      # some updated apelidos
      assert html =~ "Estévez"
    end

    test "deletes colaborador in listing", %{conn: conn, colaborador: colaborador} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.colaborador_index_path(conn, :index))

      assert index_live
             |> element("#colaborador-#{colaborador.id} a", "Eliminar")
             |> render_click()

      refute has_element?(index_live, "#colaborador-#{colaborador.id}")
    end
  end

  describe "Show" do
    setup [:create_colaborador]

    test "displays colaborador", %{conn: conn, colaborador: colaborador} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, _show_live, html} = live(conn, Routes.colaborador_show_path(conn, :show, colaborador))

      assert html =~ colaborador.nome
      assert html =~ colaborador.apelidos
    end

    test "updates colaborador within modal", %{conn: conn, colaborador: colaborador} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, show_live, _html} = live(conn, Routes.colaborador_show_path(conn, :show, colaborador))

      assert show_live |> element("a", "Editar") |> render_click() =~
               "Editar colaborador"

      assert_patch(show_live, Routes.colaborador_show_path(conn, :edit, colaborador))

      assert show_live
             |> form("#colaborador-form", colaborador: @invalid_attrs)
             |> render_submit() =~ "A conta debe ter 20 caracteres sen espacios"

      {:ok, _, html} =
        show_live
        |> form("#colaborador-form", colaborador: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.colaborador_show_path(conn, :show, colaborador))

      assert html =~ "Colaborador actualizado correctamente"
      # some updated apelidos
      assert html =~ "Estévez"
    end
  end
end
