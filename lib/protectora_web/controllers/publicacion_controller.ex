defmodule ProtectoraWeb.PublicacionController do
  use ProtectoraWeb, :controller

  alias Protectora.Publicacions
  alias Protectora.Publicacions.Publicacion

  action_fallback ProtectoraWeb.FallbackController

  def index(conn, _params) do
    publicacion = Publicacions.list_publicacion()
    render(conn, "index.json", publicacion: publicacion)
  end

  def create(conn, %{"publicacion" => publicacion_params}) do
    with {:ok, %Publicacion{} = publicacion} <- Publicacions.create_publicacion(publicacion_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.publicacion_path(conn, :show, publicacion))
      |> render("show.json", publicacion: publicacion)
    end
  end

  def show(conn, %{"id" => id}) do
    publicacion = Publicacions.get_publicacion!(id)
    render(conn, "show.json", publicacion: publicacion)
  end

  def update(conn, %{"id" => id, "publicacion" => publicacion_params}) do
    publicacion = Publicacions.get_publicacion!(id)

    with {:ok, %Publicacion{} = publicacion} <- Publicacions.update_publicacion(publicacion, publicacion_params) do
      render(conn, "show.json", publicacion: publicacion)
    end
  end

  def delete(conn, %{"id" => id}) do
    publicacion = Publicacions.get_publicacion!(id)

    with {:ok, %Publicacion{}} <- Publicacions.delete_publicacion(publicacion) do
      send_resp(conn, :no_content, "")
    end
  end
end
