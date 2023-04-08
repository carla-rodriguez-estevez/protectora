defmodule ProtectoraWeb.RexistroLiveTest do
  use ProtectoraWeb.ConnCase

  import Phoenix.LiveViewTest
  import Protectora.RexistrosFixtures
  import Protectora.AnimaisFixtures

  @create_attrs %{descricion: "some descricion", prezo: 120.5, titulo: "some titulo"}
  @update_attrs %{
    descricion: "some updated descricion",
    prezo: 456.7,
    titulo: "some updated titulo"
  }
  @invalid_attrs %{descricion: nil, prezo: nil, titulo: nil}

  defp create_rexistro(_) do
    rexistro = rexistro_fixture()
    %{rexistro: rexistro}
  end

  describe "Index" do
    setup [:create_rexistro]

    test "lists all rexistro", %{conn: conn, rexistro: rexistro} do
      {:ok, _index_live, html} = live(conn, Routes.rexistro_index_path(conn, :index))

      assert html =~ "Listing Rexistro"
      assert html =~ rexistro.descricion
    end

    test "saves new rexistro", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.rexistro_index_path(conn, :index))

      assert index_live |> element("a", "New Rexistro") |> render_click() =~
               "New Rexistro"

      assert_patch(index_live, Routes.rexistro_index_path(conn, :new))

      assert index_live
             |> form("#rexistro-form", rexistro: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      animal = animal_fixture()

      {:ok, _, html} =
        index_live
        |> form("#rexistro-form",
          rexistro: %{
            descricion: "some descricion",
            prezo: 120.5,
            titulo: "some titulo",
            animal_id: animal.id
          }
        )
        |> render_submit()
        |> follow_redirect(conn, Routes.rexistro_index_path(conn, :index))

      assert html =~ "Rexistro created successfully"
      assert html =~ "some descricion"
    end

    test "updates rexistro in listing", %{conn: conn, rexistro: rexistro} do
      {:ok, index_live, _html} = live(conn, Routes.rexistro_index_path(conn, :index))

      assert index_live |> element("#rexistro-#{rexistro.id} a", "Edit") |> render_click() =~
               "Edit Rexistro"

      assert_patch(index_live, Routes.rexistro_index_path(conn, :edit, rexistro))

      assert index_live
             |> form("#rexistro-form", rexistro: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#rexistro-form", rexistro: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.rexistro_index_path(conn, :index))

      assert html =~ "Rexistro updated successfully"
      assert html =~ "some updated descricion"
    end

    test "deletes rexistro in listing", %{conn: conn, rexistro: rexistro} do
      {:ok, index_live, _html} = live(conn, Routes.rexistro_index_path(conn, :index))

      assert index_live |> element("#rexistro-#{rexistro.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#rexistro-#{rexistro.id}")
    end
  end

  describe "Show" do
    setup [:create_rexistro]

    test "displays rexistro", %{conn: conn, rexistro: rexistro} do
      {:ok, _show_live, html} = live(conn, Routes.rexistro_show_path(conn, :show, rexistro))

      assert html =~ "Show Rexistro"
      assert html =~ rexistro.descricion
    end

    test "updates rexistro within modal", %{conn: conn, rexistro: rexistro} do
      {:ok, show_live, _html} = live(conn, Routes.rexistro_show_path(conn, :show, rexistro))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Rexistro"

      assert_patch(show_live, Routes.rexistro_show_path(conn, :edit, rexistro))

      assert show_live
             |> form("#rexistro-form", rexistro: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#rexistro-form", rexistro: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.rexistro_show_path(conn, :show, rexistro))

      assert html =~ "Rexistro updated successfully"
      assert html =~ "some updated descricion"
    end
  end
end
