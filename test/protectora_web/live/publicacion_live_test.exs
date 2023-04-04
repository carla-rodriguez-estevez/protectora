defmodule ProtectoraWeb.PublicacionLiveTest do
  use ProtectoraWeb.ConnCase

  import Phoenix.LiveViewTest
  import Protectora.PublicacionsFixtures

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

      assert html =~ "Listing Publicacion"
      assert html =~ publicacion.contido
    end

    test "saves new publicacion", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.publicacion_index_path(conn, :index))

      assert index_live |> element("a", "New Publicacion") |> render_click() =~
               "New Publicacion"

      assert_patch(index_live, Routes.publicacion_index_path(conn, :new))

      assert index_live
             |> form("#publicacion-form", publicacion: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#publicacion-form", publicacion: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.publicacion_index_path(conn, :index))

      assert html =~ "Publicacion created successfully"
      assert html =~ "some contido"
    end

    test "updates publicacion in listing", %{conn: conn, publicacion: publicacion} do
      {:ok, index_live, _html} = live(conn, Routes.publicacion_index_path(conn, :index))

      assert index_live |> element("#publicacion-#{publicacion.id} a", "Edit") |> render_click() =~
               "Edit Publicacion"

      assert_patch(index_live, Routes.publicacion_index_path(conn, :edit, publicacion))

      assert index_live
             |> form("#publicacion-form", publicacion: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#publicacion-form", publicacion: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.publicacion_index_path(conn, :index))

      assert html =~ "Publicacion updated successfully"
      assert html =~ "some updated contido"
    end

    test "deletes publicacion in listing", %{conn: conn, publicacion: publicacion} do
      {:ok, index_live, _html} = live(conn, Routes.publicacion_index_path(conn, :index))

      assert index_live |> element("#publicacion-#{publicacion.id} a", "Delete") |> render_click()
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
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#publicacion-form", publicacion: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.publicacion_show_path(conn, :show, publicacion))

      assert html =~ "Publicacion updated successfully"
      assert html =~ "some updated contido"
    end
  end
end
