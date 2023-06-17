defmodule ProtectoraWeb.AnimalLiveTest do
  use ProtectoraWeb.ConnCase

  import Phoenix.LiveViewTest
  import Protectora.AnimaisFixtures
  alias Protectora.Accounts
  alias ProtectoraWeb.UserAuth
  import Protectora.AccountsFixtures
  import Protectora.PadrinamentosFixtures
  import Protectora.RexistrosFixtures

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

  defp create_padrinamento(_) do
    padrinamento = padrinamento_fixture()
    %{padrinamento: padrinamento}
  end

  defp create_rexistro() do
    rexistro = rexistro_fixture()
    rexistro
  end

  defp create_animal_images() do
    animal_fixture_var =
      animal_fixture_images([
        "priv/static/animais/5d18f2ac-ae55-4b40-b11b-9f0d5d977bc8-images.jpeg"
      ])

    Protectora.Animais.get_animal!(animal_fixture_var.id)
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

    test "saves new animal with images", %{conn: conn} do
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
        |> form("#animal-form",
          animal: %{
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
          },
          photo: "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"
        )
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
    setup [:create_padrinamento]

    test "displays animal", %{conn: conn, animal: animal} do
      {:ok, _show_live, html} = live(conn, Routes.animal_show_path(conn, :show, animal))

      assert html =~ animal.nome
      assert html =~ animal.descricion
    end

    test "displays animal with images", %{conn: conn} do
      animal = create_animal_images()

      {:ok, show_live, html} = live(conn, Routes.animal_show_path(conn, :show, animal))

      assert html =~ animal.nome
      assert html =~ animal.descricion

      assert show_live |> element("#images") != nil
    end

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

    test "create rexistro", %{conn: conn, animal: animal} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      {:ok, show_live, _html} = live(conn, Routes.animal_show_path(conn, :show, animal))

      assert show_live |> element("a", "Engadir") |> render_click() =~
               "Engadir rexistro"

      assert_patch(show_live, "/animal/" <> animal.id <> "/rexistro/new")

      assert show_live
             |> form("#rexistro-form",
               rexistro: %{
                 titulo: nil,
                 descricion: nil,
                 prezo: nil
               }
             )
             |> render_submit() =~ "non pode estar baleiro"

      {:ok, _, html} =
        show_live
        |> form("#rexistro-form",
          rexistro: %{
            titulo: "proba",
            descricion: "proba",
            prezo: 10
          }
        )
        |> render_submit()
        |> follow_redirect(conn, Routes.animal_show_path(conn, :show, animal))

      assert html =~ "Rexistro creado correctamente"
    end

    test "update rexistro", %{conn: conn} do
      conn =
        conn
        |> Map.replace!(:secret_key_base, ProtectoraWeb.Endpoint.config(:secret_key_base))
        |> init_test_session(%{})

      token = Protectora.Accounts.generate_user_session_token(user_fixture())

      conn =
        conn
        |> put_session(:user_token, token)

      rexistro = create_rexistro()
      animal = Protectora.Animais.get_animal!(rexistro.animal_id)

      {:ok, show_live, _html} = live(conn, Routes.animal_show_path(conn, :show, animal))

      assert show_live |> element("#edit", "Editar") |> render_click() =~
               "Editar"

      assert_patch(show_live, "/animal/" <> rexistro.id <> "/rexistro/edit")

      assert show_live
             |> form("#rexistro-form",
               rexistro: %{
                 titulo: nil,
                 descricion: nil,
                 prezo: nil
               }
             )
             |> render_submit() =~ "non pode estar baleiro"

      {:ok, _, html} =
        show_live
        |> form("#rexistro-form",
          rexistro: %{
            titulo: "proba",
            descricion: "proba",
            prezo: 10
          }
        )
        |> render_submit()
        |> follow_redirect(conn, Routes.animal_show_path(conn, :show, animal))

      assert html =~ "Rexistro actualizado correctamente"
    end
  end
end
