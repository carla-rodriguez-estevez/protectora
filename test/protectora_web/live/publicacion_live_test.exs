defmodule ProtectoraWeb.PublicacionLiveTest do
  use ProtectoraWeb.ConnCase

  import Phoenix.LiveViewTest
  import Protectora.PublicacionsFixtures
  alias Protectora.Accounts
  alias ProtectoraWeb.UserAuth
  import Protectora.AccountsFixtures
  @create_attrs %{contido: "some contido", titulo: "some titulo"}
  @update_attrs %{contido: "some updated contido", titulo: "some updated titulo"}
  @invalid_attrs %{contido: nil, titulo: nil}

  defp create_publicacion(_) do
    publicacion = publicacion_fixture()
    %{publicacion: publicacion}
  end

  describe "Index" do
    setup [:create_publicacion]

    test "lists all publicacion", %{conn: conn, publicacion: publicacion} do
      {:ok, _index_live, html} = live(conn, Routes.publicacion_index_path(conn, :index))

      assert html =~ "Publicacións dispoñibles"
      assert html =~ publicacion.contido
    end

    test "saves new publicacion", %{conn: conn} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.publicacion_index_path(conn, :index))

      assert index_live |> element("a", "Engadir publicación") |> render_click() =~
               "Engadir publicación"

      assert_patch(index_live, Routes.publicacion_index_path(conn, :new))

      assert index_live
             |> form("#publicacion-form", publicacion: @invalid_attrs)
             |> render_change() =~ "non pode estar valeiro"

      {:ok, _, html} =
        index_live
        |> form("#publicacion-form", publicacion: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.publicacion_index_path(conn, :index))

      assert html =~ "Publicación creada correctamente"
      assert html =~ "some contido"
    end

    # THis functionality is no longer needed, wait here in case is necessary
    # test "updates publicacion in listing", %{conn: conn, publicacion: publicacion} do
    #   conn =
    #     conn
    #     |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
    #     |> init_test_session(%{})

    #   token = Protectora.Accounts.generate_user_session_token(user_fixture())

    #   conn =
    #     conn
    #     |> put_session(:user_token, token)

    #   {:ok, index_live, _html} = live(conn, Routes.publicacion_index_path(conn, :index))

    #   assert index_live |> element("#publicacion-#{publicacion.id} a", "Editar") |> render_click() =~
    #            "Editar Publicación"

    #   assert_patch(index_live, Routes.publicacion_index_path(conn, :edit, publicacion))

    #   assert index_live
    #          |> form("#publicacion-form", publicacion: @invalid_attrs)
    #          |> render_change() =~ "can&#39;t be blank"

    #   {:ok, _, html} =
    #     index_live
    #     |> form("#publicacion-form", publicacion: @update_attrs)
    #     |> render_submit()
    #     |> follow_redirect(conn, Routes.publicacion_index_path(conn, :index))

    #   assert html =~ "Publicación actualizada correctamente"
    #   assert html =~ "some updated contido"
    # end

    test "deletes publicacion in listing", %{conn: conn, publicacion: publicacion} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.publicacion_index_path(conn, :index))

      assert index_live |> element("#publicacion-#{publicacion.id} a", "Borrar") |> render_click()
      refute has_element?(index_live, "#publicacion-#{publicacion.id}")
    end
  end

  describe "Show" do
    setup [:create_publicacion]

    test "displays publicacion", %{conn: conn, publicacion: publicacion} do
      {:ok, _show_live, html} = live(conn, Routes.publicacion_show_path(conn, :show, publicacion))

      assert html =~ "Show Publicacion"
      assert html =~ publicacion.contido
    end

    test "updates publicacion within modal", %{conn: conn, publicacion: publicacion} do
      {:ok, show_live, _html} = live(conn, Routes.publicacion_show_path(conn, :show, publicacion))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Publicacion"

      assert_patch(show_live, Routes.publicacion_show_path(conn, :edit, publicacion))

      assert show_live
             |> form("#publicacion-form", publicacion: @invalid_attrs)
             |> render_change() =~ "non pode estar valeiro"

      {:ok, _, html} =
        show_live
        |> form("#publicacion-form", publicacion: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.publicacion_show_path(conn, :show, publicacion))

      assert html =~ "Publicación actualizada correctamente"
      assert html =~ "some updated contido"
    end
  end
end
