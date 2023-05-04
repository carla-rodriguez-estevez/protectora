defmodule ProtectoraWeb.AnimalLiveTest do
  use ProtectoraWeb.ConnCase

  import Phoenix.LiveViewTest
  import Protectora.AnimaisFixtures

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

      assert html =~ "Listing Animal"
      assert html =~ animal.nome
    end

    test "saves new animal", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.animal_index_path(conn, :index))

      assert index_live |> element("a", "New Animal") |> render_click() =~
               "New Animal"

      assert_patch(index_live, Routes.animal_index_path(conn, :new))

      assert index_live
             |> form("#animal-form", animal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#animal-form", animal: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.animal_index_path(conn, :index))

      assert html =~ "Animal created successfully"
      assert html =~ "some nome"
    end

    test "updates animal in listing", %{conn: conn, animal: animal} do
      {:ok, index_live, _html} = live(conn, Routes.animal_index_path(conn, :index))

      assert index_live |> element("a", "Editar") |> render_click() =~
               "Edit Animal"

      assert_patch(index_live, Routes.animal_index_path(conn, :edit, animal))

      assert index_live
             |> form("#animal-form", animal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#animal-form", animal: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.animal_index_path(conn, :index))

      assert html =~ "Animal updated successfully"
      assert html =~ "Reita"
    end

    test "deletes animal in listing", %{conn: conn, animal: animal} do
      {:ok, index_live, _html} = live(conn, Routes.animal_index_path(conn, :index))

      assert index_live |> element("a", "Borrar") |> render_click()
      refute has_element?(index_live, "#animal-#{animal.id}")
    end
  end

  describe "Show" do
    setup [:create_animal]

    test "displays animal", %{conn: conn, animal: animal} do
      {:ok, _show_live, html} = live(conn, Routes.animal_show_path(conn, :show, animal))

      assert html =~ "Show Animal"
      assert html =~ animal.descricion
    end

    test "updates animal within modal", %{conn: conn, animal: animal} do
      {:ok, show_live, _html} = live(conn, Routes.animal_show_path(conn, :show, animal))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Animal"

      assert_patch(show_live, Routes.animal_show_path(conn, :edit, animal))

      assert show_live
             |> form("#animal-form", animal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#animal-form", animal: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.animal_show_path(conn, :show, animal))

      assert html =~ "Animal updated successfully"
      assert html =~ "Pequena cadela moi querida e cariñosa"
    end
  end
end
