defmodule ProtectoraWeb.PadrinamentoLiveTest do
  use ProtectoraWeb.ConnCase

  import Phoenix.LiveViewTest
  import Protectora.PadrinamentosFixtures
  import Protectora.AnimaisFixtures
  import Protectora.ColaboradoresFixtures
  alias Protectora.Accounts
  alias ProtectoraWeb.UserAuth
  import Protectora.AccountsFixtures
  import Protectora.AnimaisFixtures

  @create_attrs %{cantidade_aporte: "120.5", perioricidade: "mensual"}
  @update_attrs %{cantidade_aporte: "456.7", perioricidade: "anual"}
  @invalid_attrs %{cantidade_aporte: nil, perioricidade: nil}

  defp create_padrinamento(_) do
    padrinamento = padrinamento_fixture()
    %{padrinamento: padrinamento}
  end

  defp create_animal(_) do
    animal_fixture_var = animal_fixture()
    animal = Protectora.Animais.get_animal!(animal_fixture_var.id)

    %{animal: animal}
  end

  describe "Index" do
    setup [:create_padrinamento]
    setup [:create_animal]

    test "lists all padrinamento", %{conn: conn, padrinamento: padrinamento} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, _index_live, html} = live(conn, Routes.padrinamento_index_path(conn, :index))

      assert html =~ "Lista de padriños"
      assert html =~ padrinamento.perioricidade
    end

    test "saves new padrinamento", %{conn: conn, animal: animal} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.animal_show_path(conn, :show, animal))

      assert index_live |> element("a", "Convertirse en padriño") |> render_click() =~
               "Convertirse en padriño"

      assert_patch(index_live, "/animal/" <> animal.id <> "/padrinamento/new")

      assert index_live
             |> form("#padrinamento-form", padrinamento: @invalid_attrs)
             |> render_change() =~ "non pode estar baleiro"

      {:ok, colaborador} =
        %{}
        |> Enum.into(%{
          apelidos: "Rodríguez",
          codigoPostal: 36_860,
          dataNacemento: ~D[2001-05-14],
          direccion: "Canedo 32",
          email: "carla1@udc.es",
          localidade: "Ponteareas",
          nome: "Carla",
          numeroConta: "ES12123412341234123412",
          perioricidade: "mensual"
        })
        |> Protectora.Colaboradores.create_colaborador()

      valid_attrs = %{
        cantidade_aporte: "120.5",
        perioricidade: "anual",
        email: "carla1@udc.es"
      }

      {:ok, _, html} =
        index_live
        |> form("#padrinamento-form", padrinamento: valid_attrs)
        |> render_submit()
        |> follow_redirect(conn, "/animal/" <> animal.id)

      assert html =~ "Padriñamento creado correctamente"
      assert html =~ "anual"
    end

    test "updates padrinamento in listing", %{conn: conn, padrinamento: padrinamento} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.padrinamento_index_path(conn, :index))

      assert index_live |> element("#padrinamento-#{padrinamento.id} a", "Edit") |> render_click() =~
               "Editar padriñamento"

      assert_patch(index_live, Routes.padrinamento_index_path(conn, :edit, padrinamento))

      assert index_live
             |> form("#padrinamento-form", padrinamento: @invalid_attrs)
             |> render_change() =~ "non pode estar baleiro"

      animal = animal_fixture()

      {:ok, colaborador} =
        %{}
        |> Enum.into(%{
          apelidos: "Rodríguez",
          codigoPostal: 36_860,
          dataNacemento: ~D[2001-05-14],
          direccion: "Canedo 32",
          email: "carla1@udc.es",
          localidade: "Ponteareas",
          nome: "Carla",
          numeroConta: "ES12123412341234123412",
          perioricidade: "mensual"
        })
        |> Protectora.Colaboradores.create_colaborador()

      update_attrs = %{
        cantidade_aporte: "120.5",
        perioricidade: "trimestral",
        animal_id: animal.id,
        email: "carla1@udc.es"
      }

      {:ok, _, html} =
        index_live
        |> form("#padrinamento-form", padrinamento: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, "/padrinamento?padrinamentos=1")

      assert html =~ "Padriñamento actualizado correctamente"
      assert html =~ "trimestral"
    end

    test "deletes padrinamento in listing", %{conn: conn, padrinamento: padrinamento} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.padrinamento_index_path(conn, :index))

      assert index_live
             |> element("#padrinamento-#{padrinamento.id} a", "Borrar")
             |> render_click()

      refute has_element?(index_live, "#padrinamento-#{padrinamento.id}")
    end
  end

  describe "Show" do
    setup [:create_padrinamento]

    test "displays padrinamento", %{conn: conn, padrinamento: padrinamento} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, _show_live, html} =
        live(conn, Routes.padrinamento_show_path(conn, :show, padrinamento))

      assert html =~ "Show Padrinamento"
      assert html =~ padrinamento.perioricidade
    end

    test "updates padrinamento within modal", %{conn: conn, padrinamento: padrinamento} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, show_live, _html} =
        live(conn, Routes.padrinamento_show_path(conn, :show, padrinamento))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Padrinamento"

      assert_patch(show_live, Routes.padrinamento_show_path(conn, :edit, padrinamento))

      assert show_live
             |> form("#padrinamento-form", padrinamento: @invalid_attrs)
             |> render_change() =~ "non pode estar baleiro"

      animal = animal_fixture()

      {:ok, colaborador} =
        %{}
        |> Enum.into(%{
          apelidos: "Rodríguez",
          codigoPostal: 36_860,
          dataNacemento: ~D[2001-05-14],
          direccion: "Canedo 32",
          email: "carla1@udc.es",
          localidade: "Ponteareas",
          nome: "Carla",
          numeroConta: "ES12123412341234123412",
          perioricidade: "mensual"
        })
        |> Protectora.Colaboradores.create_colaborador()

      update_attrs = %{
        cantidade_aporte: "120.5",
        perioricidade: "trimestral",
        animal_id: animal.id,
        email: "carla1@udc.es"
      }

      {:ok, _, html} =
        show_live
        |> form("#padrinamento-form", padrinamento: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.padrinamento_show_path(conn, :show, padrinamento))

      assert html =~ "Padriñamento actualizado correctamente"
      assert html =~ "trimestral"
    end
  end
end
