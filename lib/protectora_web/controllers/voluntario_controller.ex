defmodule ProtectoraWeb.VoluntarioController do
  use ProtectoraWeb, :controller

  alias Protectora.Voluntarios
  alias Protectora.Voluntarios.Voluntario

  action_fallback ProtectoraWeb.FallbackController

  def index(conn, _params) do
    voluntario = Voluntarios.list_voluntario()
    render(conn, "index.json", voluntario: voluntario)
  end

  def create(conn, %{"voluntario" => voluntario_params}) do
    with {:ok, %Voluntario{} = voluntario} <- Voluntarios.create_voluntario(voluntario_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.voluntario_path(conn, :show, voluntario))
      |> render("show.json", voluntario: voluntario)
    end
  end

  def show(conn, %{"id" => id}) do
    voluntario = Voluntarios.get_voluntario!(id)
    render(conn, "show.json", voluntario: voluntario)
  end

  def update(conn, %{"id" => id, "voluntario" => voluntario_params}) do
    voluntario = Voluntarios.get_voluntario!(id)

    with {:ok, %Voluntario{} = voluntario} <- Voluntarios.update_voluntario(voluntario, voluntario_params) do
      render(conn, "show.json", voluntario: voluntario)
    end
  end

  def delete(conn, %{"id" => id}) do
    voluntario = Voluntarios.get_voluntario!(id)

    with {:ok, %Voluntario{}} <- Voluntarios.delete_voluntario(voluntario) do
      send_resp(conn, :no_content, "")
    end
  end
end
