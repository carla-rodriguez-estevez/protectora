defmodule ProtectoraWeb.AnimalLiveTest do
  use ProtectoraWeb.ConnCase

  import Phoenix.LiveViewTest
  import Protectora.AnimaisFixtures
  alias Protectora.Accounts
  alias ProtectoraWeb.UserAuth
  import Protectora.AccountsFixtures

  @create_attrs %{
    descricion: "some descricion",
    eEspecial: true,
    eUrxente: true,
    idade: 2,
    madurez: "cachorro",
    nome: "some nome",
    peso: 2,
    raza: "some raza",
    tamano: "pequeno",
    tipo: "outro"
  }
  @update_attrs %{
    descricion: "Pequena cadela moi querida e cariñosa",
    eEspecial: false,
    eUrxente: false,
    idade: 2,
    madurez: "cachorro",
    nome: "Reita",
    peso: 2,
    raza: "some raza",
    tamano: "pequeno",
    tipo: "cadela"
  }
  @invalid_attrs %{
    descricion: nil,
    eEspecial: false,
    eUrxente: false,
    idade: nil,
    madurez: nil,
    nome: nil,
    peso: nil,
    raza: nil,
    tamano: nil,
    tipo: "outro"
  }

  defp create_animal(_) do
    animal_fixture_var = animal_fixture()
    animal = Protectora.Animais.get_animal!(animal_fixture_var.id)

    %{animal: animal}
  end

  describe "Index" do
    setup [:create_animal]

    test "lists all animal", %{conn: conn, animal: animal} do
      {:ok, _index_live, html} = live(conn, Routes.animal_index_path(conn, :index))

      assert html =~ "Os nosos animais"
      assert html =~ animal.nome
    end

    test "saves new animal", %{conn: conn} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.animal_index_path(conn, :index))

      assert index_live |> element("a", "Engadir un animal") |> render_click() =~
               "Engadir un animal"

      assert_patch(index_live, Routes.animal_index_path(conn, :new))

      assert index_live
             |> form("#animal-form", animal: @invalid_attrs)
             |> render_change() =~ "non pode estar baleiro"

      {:ok, _, html} =
        index_live
        |> form("#animal-form", animal: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.animal_index_path(conn, :index))

      assert html =~ "Animal creado correctamente"
      assert html =~ "some nome"
    end

    test "deletes animal in listing", %{conn: conn, animal: animal} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, index_live, _html} = live(conn, Routes.animal_index_path(conn, :index))

      assert index_live |> element("a", "Borrar") |> render_click()
      refute has_element?(index_live, "#animal-#{animal.id}")
    end
  end

  describe "Show" do
    setup [:create_animal]

    test "displays animal", %{conn: conn, animal: animal} do
      {:ok, _show_live, html} = live(conn, Routes.animal_show_path(conn, :show, animal))

      assert html =~ animal.nome
      assert html =~ animal.descricion
    end

    # No longer available
    test "updates animal within modal", %{conn: conn, animal: animal} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, show_live, _html} = live(conn, Routes.animal_show_path(conn, :show, animal))

      assert show_live |> element("a", "Editar animal") |> render_click() =~
               "Editar Animal"

      assert_patch(show_live, Routes.animal_show_path(conn, :edit, animal))

      assert show_live
             |> form("#animal-form", animal: @invalid_attrs)
             |> render_change() =~ "non pode estar baleiro"

      {:ok, _, html} =
        show_live
        |> form("#animal-form", animal: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.animal_show_path(conn, :show, animal))

      assert html =~ "Animal actualizado correctamente"
      assert html =~ "Pequena cadela moi querida e cariñosa"
    end

    test "sends adoption", %{conn: conn, animal: animal} do
      {:ok, show_live, _html} = live(conn, Routes.animal_show_path(conn, :show, animal))

      assert show_live |> element("a", "Solicitar adopción") |> render_click() =~
               "Solicitar adopción"

      assert_patch(show_live, "/animal/" <> animal.id <> "/email")

      assert show_live
             |> form("#email-form",
               adoption_email: %{nome: nil, telefono: nil, email: nil, nota: nil}
             )
             |> render_submit() =~ "non pode estar baleiro"

      {:ok, _, html} =
        show_live
        |> form("#email-form",
          adoption_email: %{
            nome: "test suite",
            telefono: 986_660_754,
            email: "carla@udc.es",
            nota: nil
          }
        )
        |> render_submit()
        |> follow_redirect(conn, Routes.animal_show_path(conn, :show, animal))

      assert html =~ "Petición de adopción enviada"
    end
  end
end
