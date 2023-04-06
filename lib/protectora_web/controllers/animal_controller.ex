defmodule ProtectoraWeb.AnimalController do
  use ProtectoraWeb, :controller

  alias Protectora.Animais
  alias Protectora.Animais.Animal

  action_fallback ProtectoraWeb.FallbackController

  def index(conn, _params) do
    animal = Animais.list_animal()
    render(conn, "index.json", animal: animal)
  end

  def create(conn, %{"animal" => animal_params}) do
    with {:ok, %Animal{} = animal} <- Animais.create_animal(animal_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.animal_path(conn, :show, animal))
      |> render("show.json", animal: animal)
    end
  end

  def show(conn, %{"id" => id}) do
    animal = Animais.get_animal!(id)
    render(conn, "show.json", animal: animal)
  end

  def update(conn, %{"id" => id, "animal" => animal_params}) do
    animal = Animais.get_animal!(id)

    with {:ok, %Animal{} = animal} <- Animais.update_animal(animal, animal_params) do
      render(conn, "show.json", animal: animal)
    end
  end

  def delete(conn, %{"id" => id}) do
    animal = Animais.get_animal!(id)

    with {:ok, %Animal{}} <- Animais.delete_animal(animal) do
      send_resp(conn, :no_content, "")
    end
  end
end
