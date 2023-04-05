defmodule ProtectoraWeb.ColaboradorController do
  use ProtectoraWeb, :controller

  alias Protectora.Colaboradores
  alias Protectora.Colaboradores.Colaborador

  action_fallback ProtectoraWeb.FallbackController

  def index(conn, _params) do
    colaborador = Colaboradores.list_colaborador()
    render(conn, "index.json", colaborador: colaborador)
  end

  def create(conn, %{"colaborador" => colaborador_params}) do
    with {:ok, %Colaborador{} = colaborador} <- Colaboradores.create_colaborador(colaborador_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.colaborador_path(conn, :show, colaborador))
      |> render("show.json", colaborador: colaborador)
    end
  end

  def show(conn, %{"id" => id}) do
    colaborador = Colaboradores.get_colaborador!(id)
    render(conn, "show.json", colaborador: colaborador)
  end

  def update(conn, %{"id" => id, "colaborador" => colaborador_params}) do
    colaborador = Colaboradores.get_colaborador!(id)

    with {:ok, %Colaborador{} = colaborador} <- Colaboradores.update_colaborador(colaborador, colaborador_params) do
      render(conn, "show.json", colaborador: colaborador)
    end
  end

  def delete(conn, %{"id" => id}) do
    colaborador = Colaboradores.get_colaborador!(id)

    with {:ok, %Colaborador{}} <- Colaboradores.delete_colaborador(colaborador) do
      send_resp(conn, :no_content, "")
    end
  end
end
