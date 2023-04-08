defmodule ProtectoraWeb.RexistroController do
  use ProtectoraWeb, :controller

  alias Protectora.Rexistros
  alias Protectora.Rexistros.Rexistro

  action_fallback ProtectoraWeb.FallbackController

  def index(conn, _params) do
    rexistro = Rexistros.list_rexistro()
    render(conn, "index.json", rexistro: rexistro)
  end

  def create(conn, %{"rexistro" => rexistro_params}) do
    with {:ok, %Rexistro{} = rexistro} <- Rexistros.create_rexistro(rexistro_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.rexistro_path(conn, :show, rexistro))
      |> render("show.json", rexistro: rexistro)
    end
  end

  def show(conn, %{"id" => id}) do
    rexistro = Rexistros.get_rexistro!(id)
    render(conn, "show.json", rexistro: rexistro)
  end

  def update(conn, %{"id" => id, "rexistro" => rexistro_params}) do
    rexistro = Rexistros.get_rexistro!(id)

    with {:ok, %Rexistro{} = rexistro} <- Rexistros.update_rexistro(rexistro, rexistro_params) do
      render(conn, "show.json", rexistro: rexistro)
    end
  end

  def delete(conn, %{"id" => id}) do
    rexistro = Rexistros.get_rexistro!(id)

    with {:ok, %Rexistro{}} <- Rexistros.delete_rexistro(rexistro) do
      send_resp(conn, :no_content, "")
    end
  end
end
