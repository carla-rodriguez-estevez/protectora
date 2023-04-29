defmodule ProtectoraWeb.AnimalController do
  use ProtectoraWeb, :controller

  alias Protectora.Animais
  alias Protectora.Animais.Animal
  require Logger

  action_fallback(ProtectoraWeb.FallbackController)

  def upload_directory do
    Application.get_env(:protectora, :animais_directory)
  end

  defp process_images_inner(imaxes, id, nombres, n) do
    case imaxes do
      [] ->
        nombres

      [h | t] ->
        "data:image/gif;base64," <> raw = h

        File.write!(
          upload_directory() <> "/" <> id <> Integer.to_string(n) <> ".jpg",
          Base.decode64!(raw)
        )

        process_images_inner(
          t,
          id,
          ["/animais/" <> id <> Integer.to_string(n) <> ".jpg" | nombres],
          n + 1
        )
    end
  end

  defp process_images(imaxes, id, nombres, n) do
    process_images_inner(imaxes, id, nombres, n)
  end

  def index(conn, _params) do
    animal = Animais.list_animal()
    render(conn, "index.json", animal: animal)
  end

  def create(conn, %{"animal" => animal_params, "imaxes" => imaxes}) do
    with {:ok, animal_created} <-
           Animais.create_animal(animal_params, fn animal_result ->
             process_images(imaxes, animal_result.id, [], 0)
           end) do
      case animal_created do
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> put_view(ProtectoraWeb.ChangesetView)
          |> render("error.json", changeset: changeset)

        {_, animal} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.animal_path(conn, :show, animal))
          |> render("created.json", animal: animal)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    animal = Animais.get_animal!(id)
    render(conn, "show.json", animal: animal)
  end

  defp update_imaxes(animal, imaxes) do
    case imaxes do
      [] ->
        imaxes

      list ->
        Enum.each(animal.imaxe_animal, fn el ->
          File.rm!(Path.join(["priv/static", el.path_imaxe]))
        end)

        photos = process_images(list, animal.id, [], 0)
        photos
    end
  end

  def update(conn, %{"id" => id, "animal" => animal_params, "imaxes" => imaxes}) do
    animal = Animais.get_animal!(id)

    with {:ok, animal_updated} <-
           Animais.update_animal(animal, animal_params, fn animal_result ->
             update_imaxes(animal_result, imaxes)
           end) do
      case animal_updated do
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> put_view(ProtectoraWeb.ChangesetView)
          |> render("error.json", changeset: changeset)

        {_, updated} ->
          render(conn, "show.json", animal: updated)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    animal = Animais.get_animal!(id)

    with {:ok, _} <- Animais.delete_animal(animal) do
      send_resp(conn, :no_content, "")
    end
  end
end
