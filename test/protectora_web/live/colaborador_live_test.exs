defmodule ProtectoraWeb.ColaboradorLiveTest do
  use ProtectoraWeb.ConnCase

  import Phoenix.LiveViewTest
  import Protectora.ColaboradoresFixtures

  @create_attrs %{
    apelidos: "Rodríguez",
    codigoPostal: 36_860,
    dataNacemento: %{day: 14, month: 5, year: 2001},
    direccion: "Canedo 32",
    email: "carla@udc.es",
    localidade: "Ponteareas",
    nome: "Carla",
    numeroConta: "ES12123412341234123412",
    perioricidade: "Mensual"
  }

  @update_attrs %{
    apelidos: "Estévez",
    codigoPostal: 15_001,
    dataNacemento: %{day: 14, month: 5, year: 1997},
    direccion: "Poeta Trillo Figueroa",
    email: "lucia@udc.es",
    localidade: "A Coruña",
    nome: "Lucia",
    numeroConta: "ES12123412341234123434",
    perioricidade: "Trimestral"
  }

  @invalid_attrs %{
    apelidos: nil,
    codigoPostal: nil,
    dataNacemento: %{day: 30, month: 2, year: 2023},
    direccion: nil,
    email: nil,
    localidade: nil,
    nome: nil,
    numeroConta: nil
  }

  defp create_colaborador(_) do
    colaborador = colaborador_fixture()
    %{colaborador: colaborador}
  end

  describe "Index" do
    setup [:create_colaborador]

    test "lists all colaborador", %{conn: conn, colaborador: colaborador} do
      {:ok, _index_live, html} = live(conn, Routes.colaborador_index_path(conn, :index))

      assert html =~ "Listing Colaborador"
      assert html =~ colaborador.apelidos
    end

    test "saves new colaborador", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.colaborador_index_path(conn, :index))

      assert index_live |> element("a", "New Colaborador") |> render_click() =~
               "New Colaborador"

      assert_patch(index_live, Routes.colaborador_index_path(conn, :new))

      assert index_live
             |> form("#colaborador-form", colaborador: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, view, html} =
        index_live
        |> form("#colaborador-form", colaborador: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.colaborador_index_path(conn, :index))

      assert html =~ "Colaborador created successfully"
      # some created apelidos
      assert html =~ "Rodríguez"
    end

    test "updates colaborador in listing", %{conn: conn, colaborador: colaborador} do
      {:ok, index_live, _html} = live(conn, Routes.colaborador_index_path(conn, :index))

      assert index_live |> element("#colaborador-#{colaborador.id} a", "Edit") |> render_click() =~
               "Edit Colaborador"

      assert_patch(index_live, Routes.colaborador_index_path(conn, :edit, colaborador))

      assert index_live
             |> form("#colaborador-form", colaborador: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#colaborador-form", colaborador: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.colaborador_index_path(conn, :index))

      assert html =~ "Colaborador updated successfully"
      # some updated apelidos
      assert html =~ "Estévez"
    end

    test "deletes colaborador in listing", %{conn: conn, colaborador: colaborador} do
      {:ok, index_live, _html} = live(conn, Routes.colaborador_index_path(conn, :index))

      assert index_live |> element("#colaborador-#{colaborador.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#colaborador-#{colaborador.id}")
    end
  end

  describe "Show" do
    setup [:create_colaborador]

    test "displays colaborador", %{conn: conn, colaborador: colaborador} do
      {:ok, _show_live, html} = live(conn, Routes.colaborador_show_path(conn, :show, colaborador))

      assert html =~ "Show Colaborador"
      assert html =~ colaborador.apelidos
    end

    test "updates colaborador within modal", %{conn: conn, colaborador: colaborador} do
      {:ok, show_live, _html} = live(conn, Routes.colaborador_show_path(conn, :show, colaborador))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Colaborador"

      assert_patch(show_live, Routes.colaborador_show_path(conn, :edit, colaborador))

      assert show_live
             |> form("#colaborador-form", colaborador: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#colaborador-form", colaborador: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.colaborador_show_path(conn, :show, colaborador))

      assert html =~ "Colaborador updated successfully"
      # some updated apelidos
      assert html =~ "Estévez"
    end
  end
end
