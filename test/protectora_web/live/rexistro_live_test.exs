defmodule ProtectoraWeb.RexistroLiveTest do
  use ProtectoraWeb.ConnCase

  import Phoenix.LiveViewTest
  import Protectora.RexistrosFixtures
  import Protectora.AnimaisFixtures
  alias Protectora.Accounts
  alias ProtectoraWeb.UserAuth
  import Protectora.AccountsFixtures

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
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, _index_live, html} = live(conn, Routes.rexistro_index_path(conn, :index))

      assert html =~ "Listaxe de rexistros"
      assert html =~ rexistro.descricion
    end

    test "saves new rexistro", %{conn: conn} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      animal = animal_fixture()

      {:ok, index_live, _html} = live(conn, Routes.animal_show_path(conn, :new_rexistro, animal))

      assert index_live |> element("a", "Engadir rexistro") |> render_click() =~
               "Engadir rexistro"

      assert_patch(index_live, Routes.animal_show_path(conn, :new_rexistro, animal))

      assert index_live
             |> form("#rexistro-form", rexistro: @invalid_attrs)
             |> render_change() =~ "non pode estar baleiro"

      {:ok, _, html} =
        index_live
        |> form("#rexistro-form",
          rexistro: %{
            descricion: "some descricion",
            prezo: 120.5,
            titulo: "some titulo"
          }
        )
        |> render_submit()
        |> follow_redirect(conn, "/animal/" <> animal.id)

      assert html =~ "Rexistro creado correctamente"
      assert html =~ "some descricion"
    end

    test "updates rexistro in listing", %{conn: conn, rexistro: rexistro} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.rexistro_index_path(conn, :index))

      assert index_live |> element("#rexistro-#{rexistro.id} a", "Editar") |> render_click() =~
               "Editar rexistro"

      assert_patch(index_live, Routes.rexistro_index_path(conn, :edit, rexistro))

      assert index_live
             |> form("#rexistro-form", rexistro: @invalid_attrs)
             |> render_change() =~ "non pode estar baleiro"

      {:ok, _, html} =
        index_live
        |> form("#rexistro-form", rexistro: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, "/rexistro?rexistros=1")

      assert html =~ "Rexistro actualizado correctamente"
      assert html =~ "some updated descricion"
    end

    test "deletes rexistro in listing", %{conn: conn, rexistro: rexistro} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.rexistro_index_path(conn, :index))

      assert index_live |> element("#rexistro-#{rexistro.id} a", "Eliminar") |> render_click()
      refute has_element?(index_live, "#rexistro-#{rexistro.id}")
    end
  end

  describe "Show" do
    setup [:create_rexistro]

    test "displays rexistro", %{conn: conn, rexistro: rexistro} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, _show_live, html} = live(conn, Routes.rexistro_show_path(conn, :show, rexistro))

      assert html =~ "Detalles do rexistro"
      assert html =~ rexistro.descricion
    end

    test "updates rexistro within modal", %{conn: conn, rexistro: rexistro} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, show_live, _html} = live(conn, Routes.rexistro_show_path(conn, :show, rexistro))

      assert show_live |> element("a", "Editar") |> render_click() =~
               "Editar rexistro"

      assert_patch(show_live, Routes.rexistro_show_path(conn, :edit, rexistro))

      assert show_live
             |> form("#rexistro-form", rexistro: @invalid_attrs)
             |> render_change() =~ "non pode estar baleiro"

      {:ok, _, html} =
        show_live
        |> form("#rexistro-form", rexistro: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.rexistro_show_path(conn, :show, rexistro))

      assert html =~ "Rexistro actualizado correctamente"
      assert html =~ "some updated descricion"
    end
  end
end
