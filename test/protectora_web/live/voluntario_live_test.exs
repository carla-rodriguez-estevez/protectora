defmodule ProtectoraWeb.VoluntarioLiveTest do
  use ProtectoraWeb.ConnCase

  import Phoenix.LiveViewTest
  import Protectora.VoluntariosFixtures
  require Logger

  @create_attrs %{contrasinal: "some", email: "some@email.com", nome: "some nome"}
  @update_attrs %{
    contrasinal: "some updated contrasinal",
    email: "someupdated@email.com",
    nome: "some updated nome"
  }
  @invalid_attrs %{contrasinal: nil, email: nil, nome: nil}

  defp create_voluntario(_) do
    voluntario = voluntario_fixture()
    %{voluntario: voluntario}
  end

  describe "Index" do
    setup [:create_voluntario]

    test "lists all voluntario", %{conn: conn, voluntario: voluntario} do
      {:ok, _index_live, html} = live(conn, Routes.voluntario_index_path(conn, :index))

      assert html =~ "Listing Voluntario"
      assert html =~ voluntario.contrasinal
    end

    test "saves new voluntario", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.voluntario_index_path(conn, :index))

      assert index_live |> element("a", "New Voluntario") |> render_click() =~
               "New Voluntario"

      assert_patch(index_live, Routes.voluntario_index_path(conn, :new))

      assert index_live
             |> form("#voluntario-form", voluntario: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#voluntario-form",
          voluntario: %{contrasinal: "some", email: "some@email1.com", nome: "some nome"}
        )
        |> render_submit()
        |> follow_redirect(conn, Routes.voluntario_index_path(conn, :index))

      assert html =~ "Voluntario created successfully"
    end

    test "updates voluntario in listing", %{conn: conn, voluntario: voluntario} do
      {:ok, index_live, _html} = live(conn, Routes.voluntario_index_path(conn, :index))

      assert index_live |> element("#voluntario-#{voluntario.id} a", "Edit") |> render_click() =~
               "Edit Voluntario"

      assert_patch(index_live, Routes.voluntario_index_path(conn, :edit, voluntario))

      assert index_live
             |> form("#voluntario-form", voluntario: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#voluntario-form", voluntario: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.voluntario_index_path(conn, :index))

      assert html =~ "Voluntario updated successfully"
    end

    test "deletes voluntario in listing", %{conn: conn, voluntario: voluntario} do
      {:ok, index_live, _html} = live(conn, Routes.voluntario_index_path(conn, :index))

      assert index_live |> element("#voluntario-#{voluntario.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#voluntario-#{voluntario.id}")
    end
  end

  describe "Show" do
    setup [:create_voluntario]

    test "displays voluntario", %{conn: conn, voluntario: voluntario} do
      {:ok, _show_live, html} = live(conn, Routes.voluntario_show_path(conn, :show, voluntario))

      assert html =~ "Show Voluntario"
      assert html =~ voluntario.contrasinal
    end

    test "updates voluntario within modal", %{conn: conn, voluntario: voluntario} do
      {:ok, show_live, _html} = live(conn, Routes.voluntario_show_path(conn, :show, voluntario))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Voluntario"

      assert_patch(show_live, Routes.voluntario_show_path(conn, :edit, voluntario))

      assert show_live
             |> form("#voluntario-form", voluntario: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#voluntario-form", voluntario: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.voluntario_show_path(conn, :show, voluntario))

      assert html =~ "Voluntario updated successfully"
    end
  end
end
