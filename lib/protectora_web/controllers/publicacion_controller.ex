defmodule ProtectoraWeb.PublicacionController do
  use ProtectoraWeb, :controller

  require Logger
  alias Protectora.Publicacions
  alias Protectora.Publicacions.Publicacion

  action_fallback ProtectoraWeb.FallbackController

  def upload_directory do
    Application.get_env(:protectora, :publicacions_directory)
  end

  def index(conn, _params) do
    publicacion = Publicacions.list_publicacion()
    render(conn, "index.json", publicacion: publicacion)
  end


  defp create_completed({:ok, publicacion}, conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.publicacion_path(conn, :show, publicacion))
      |> render("show.json", publicacion: publicacion)

  end

  defp create_completed(publicacion, conn) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.publicacion_path(conn, :show, publicacion))
      |> render("show.json", publicacion: publicacion)

  end

  defp process_images_inner(imaxes, id, nombres, n) do
    case imaxes do
        [] -> nombres
        [h | t] ->  "data:image/gif;base64," <> raw = h
                    File.write!(upload_directory() <> "/" <> id <> Integer.to_string(n) <> ".jpg" , Base.decode64!(raw))
                    process_images_inner(t, id, ["/publicacions/" <> id <> Integer.to_string(n) <> ".jpg" | nombres], n + 1)
      end
  end

  defp process_images(imaxes, id, nombres, n) do
     process_images_inner(imaxes, id, nombres, n)
  end

  def create(conn, %{"publicacion" => publicacion_params, "imaxes" => imaxes}) do

    with {:ok,  publicacion } <- Publicacions.create_publicacion(publicacion_params, fn publicacion_result -> process_images(imaxes, publicacion_result.id, [], 0) end) do
      create_completed(publicacion, conn)
    end
  end

  def show(conn, %{"id" => id}) do
    publicacion = Publicacions.get_publicacion!(id)
    render(conn, "publicacion_completa.json", publicacion: publicacion)
  end

  def update(conn, %{"id" => id, "publicacion" => publicacion_params}) do
    publicacion = Publicacions.get_publicacion!(id)

    with {:ok, %Publicacion{} = publicacion} <- Publicacions.update_publicacion(publicacion, publicacion_params) do
      render(conn, "show.json", publicacion: publicacion)
    end
  end

  def delete(conn, %{"id" => id}) do
    publicacion = Publicacions.get_publicacion!(id)

    with {:ok, _} <- Publicacions.delete_publicacion(publicacion) do
      send_resp(conn, :no_content, "")
    end
  end
end
