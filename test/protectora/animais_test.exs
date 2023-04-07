defmodule Protectora.AnimaisTest do
  use Protectora.DataCase

  alias Protectora.Animais

  describe "animal" do
    alias Protectora.Animais.Animal

    import Protectora.AnimaisFixtures

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

    test "list_animal/0 returns all animal" do
      animal = animal_fixture()
      assert Animais.list_animal() == [animal]
    end

    test "get_animal!/1 returns the animal with given id" do
      animal = animal_fixture()
      animal_db = Animais.get_animal!(animal.id)

      assert animal.id == animal_db.id
      assert animal.descricion == animal_db.descricion
      assert animal.eUrxente == animal_db.eUrxente
      assert animal.eEspecial == animal_db.eEspecial
      assert animal.idade == animal_db.idade
      assert animal.madurez == animal_db.madurez
      assert animal.nome == animal_db.nome
      assert animal.peso == animal_db.peso
      assert animal.raza == animal_db.raza
      assert animal.tamano == animal_db.tamano
      assert animal.tipo == animal_db.tipo
    end

    test "create_animal/1 with valid data creates a animal" do
      valid_attrs = %{
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

      assert {:ok, %Animal{} = animal} = Animais.create_animal(valid_attrs)
      assert animal.descricion == "some descricion"
      assert animal.eEspecial == true
      assert animal.eUrxente == true
      assert animal.idade == 2
      assert animal.madurez == "cachorro"
      assert animal.nome == "some nome"
      assert animal.peso == 2
      assert animal.raza == "some raza"
      assert animal.tamano == "pequeno"
      assert animal.tipo == "can"
    end

    test "create_animal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Animais.create_animal(@invalid_attrs)
    end

    test "update_animal/2 with valid data updates the animal" do
      animal = animal_fixture()

      update_attrs = %{
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

      assert {:ok, %Animal{} = animal} = Animais.update_animal(animal, update_attrs)
      assert animal.descricion == "Pequena cadela moi querida e cariñosa"
      assert animal.eEspecial == false
      assert animal.eUrxente == false
      assert animal.idade == 2
      assert animal.madurez == "cachorro"
      assert animal.nome == "Reita"
      assert animal.peso == 2
      assert animal.raza == "some raza"
      assert animal.tamano == "pequeno"
      assert animal.tipo == "cadela"
    end

    test "update_animal/2 with invalid data returns error changeset" do
      animal = animal_fixture()
      assert {:error, %Ecto.Changeset{}} = Animais.update_animal(animal, @invalid_attrs)
      animal_db = Animais.get_animal!(animal.id)

      assert animal.id == animal_db.id
      assert animal.descricion == animal_db.descricion
      assert animal.eUrxente == animal_db.eUrxente
      assert animal.eEspecial == animal_db.eEspecial
      assert animal.idade == animal_db.idade
      assert animal.madurez == animal_db.madurez
      assert animal.nome == animal_db.nome
      assert animal.peso == animal_db.peso
      assert animal.raza == animal_db.raza
      assert animal.tamano == animal_db.tamano
      assert animal.tipo == animal_db.tipo
    end

    test "delete_animal/1 deletes the animal" do
      animal = animal_fixture()
      assert {:ok, %Animal{}} = Animais.delete_animal(animal)
      assert nil == Animais.get_animal!(animal.id)
    end

    test "change_animal/1 returns a animal changeset" do
      animal = animal_fixture()
      assert %Ecto.Changeset{} = Animais.change_animal(animal)
    end
  end
end
