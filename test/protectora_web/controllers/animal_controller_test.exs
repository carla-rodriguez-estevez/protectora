defmodule ProtectoraWeb.AnimalControllerTest do
  use ProtectoraWeb.ConnCase

  import Protectora.AnimaisFixtures

  alias Protectora.Animais.Animal

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
    tipo: "can"
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
    eEspecial: nil,
    eUrxente: nil,
    idade: nil,
    madurez: nil,
    nome: nil,
    peso: nil,
    raza: nil,
    tamano: nil,
    tipo: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all animal", %{conn: conn} do
      conn = get(conn, Routes.animal_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create animal" do
    test "renders animal when data is valid", %{conn: conn} do
      conn = post(conn, Routes.animal_path(conn, :create), animal: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.animal_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "descricion" => "some descricion",
               "eEspecial" => true,
               "eUrxente" => true,
               "idade" => 2,
               "madurez" => "cachorro",
               "nome" => "some nome",
               "peso" => 2,
               "raza" => "some raza",
               "tamano" => "pequeno",
               "tipo" => "can"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.animal_path(conn, :create), animal: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update animal" do
    setup [:create_animal]

    test "renders animal when data is valid", %{conn: conn, animal: %Animal{id: id} = animal} do
      conn = put(conn, Routes.animal_path(conn, :update, animal), animal: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.animal_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "descricion" => "Pequena cadela moi querida e cariñosa",
               "eEspecial" => false,
               "eUrxente" => false,
               "idade" => 2,
               "madurez" => "cachorro",
               "nome" => "Reita",
               "peso" => 2,
               "raza" => "some raza",
               "tamano" => "pequeno",
               "tipo" => "cadela"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, animal: animal} do
      conn = put(conn, Routes.animal_path(conn, :update, animal), animal: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete animal" do
    setup [:create_animal]

    test "deletes chosen animal", %{conn: conn, animal: animal} do
      conn = delete(conn, Routes.animal_path(conn, :delete, animal))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.animal_path(conn, :show, animal))
      end
    end
  end

  defp create_animal(_) do
    animal = animal_fixture()
    %{animal: animal}
  end
end
