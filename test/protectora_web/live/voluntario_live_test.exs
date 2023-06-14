defmodule ProtectoraWeb.VoluntarioLiveTest do
  use ProtectoraWeb.ConnCase

  import Phoenix.LiveViewTest
  import Protectora.VoluntariosFixtures
  alias Protectora.Accounts
  alias ProtectoraWeb.UserAuth
  import Protectora.AccountsFixtures

  @create_attrs %{contrasinal: "some", email: "some@email.com", nome: "some nome"}
  @update_attrs %{
    contrasinal: "some updated contrasinal",
    email: "someupdated@email.com",
    nome: "some updated nome"
  }
  @invalid_attrs %{contrasinal: "", email: "", nome: ""}

  defp create_voluntario(_) do
    voluntario = voluntario_fixture()
    %{voluntario: voluntario}
  end

  describe "Index" do
    setup [:create_voluntario]

    test "lists all voluntario", %{conn: conn, voluntario: voluntario} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, _index_live, html} = live(conn, Routes.voluntario_index_path(conn, :index))

      assert html =~ "Voluntarios Rexistrados"
      assert html =~ voluntario.nome
    end

    test "saves new voluntario", %{conn: conn} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.voluntario_index_path(conn, :index))

      assert index_live |> element("a", "Engadir Voluntario") |> render_click() =~
               "Engadir Voluntario"

      assert_patch(index_live, Routes.voluntario_index_path(conn, :new))

      assert index_live
             |> form("#voluntario-form", voluntario: @invalid_attrs)
             |> render_submit() =~ "non pode estar baleiro"

      {:ok, _, html} =
        index_live
        |> form("#voluntario-form",
          voluntario: %{contrasinal: "some", email: "some@email1.com", nome: "some nome"}
        )
        |> render_submit()
        |> follow_redirect(conn, Routes.voluntario_index_path(conn, :index))

      assert html =~ "Voluntario creado correctamente"
    end

    test "updates voluntario in listing", %{conn: conn, voluntario: voluntario} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.voluntario_index_path(conn, :index))

      assert index_live |> element("#voluntario-#{voluntario.id} a", "Editar") |> render_click() =~
               "Editar Voluntario"

      assert_patch(index_live, Routes.voluntario_index_path(conn, :edit, voluntario))

      assert index_live
             |> form("#voluntario-form", voluntario: @invalid_attrs)
             |> render_submit() =~ "non pode estar baleiro"

      {:ok, _, html} =
        index_live
        |> form("#voluntario-form", voluntario: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.voluntario_index_path(conn, :index))

      assert html =~ "Voluntario actualizado correctamente"
    end

    test "deletes voluntario in listing", %{conn: conn, voluntario: voluntario} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.voluntario_index_path(conn, :index))

      assert index_live |> element("#voluntario-#{voluntario.id} a", "Eliminar") |> render_click()
      refute has_element?(index_live, "#voluntario-#{voluntario.id}")
    end
  end

  describe "Show" do
    setup [:create_voluntario]

    test "displays voluntario", %{conn: conn, voluntario: voluntario} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, _show_live, html} = live(conn, Routes.voluntario_show_path(conn, :show, voluntario))

      assert html =~ "Información Voluntario"
      assert html =~ voluntario.nome
    end

    test "updates voluntario within modal", %{conn: conn, voluntario: voluntario} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, show_live, _html} = live(conn, Routes.voluntario_show_path(conn, :show, voluntario))

      assert show_live |> element("a", "Editar voluntario") |> render_click() =~
               "Editar Voluntario"

      assert_patch(show_live, Routes.voluntario_show_path(conn, :edit, voluntario))

      assert show_live
             |> form("#voluntario-form", voluntario: @invalid_attrs)
             |> render_submit() =~ "non pode estar baleiro"

      {:ok, _, html} =
        show_live
        |> form("#voluntario-form", voluntario: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.voluntario_show_path(conn, :show, voluntario))

      assert html =~ "Voluntario actualizado correctamente"
    end
  end
end
