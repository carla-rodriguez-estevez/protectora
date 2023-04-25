defmodule ProtectoraWeb.PadrinamentoController do
  use ProtectoraWeb, :controller

  alias Protectora.Padrinamentos
  alias Protectora.Padrinamentos.Padrinamento

  action_fallback ProtectoraWeb.FallbackController

  def index(conn, _params) do
    padrinamento = Padrinamentos.list_padrinamento()
    render(conn, "index.json", padrinamento: padrinamento)
  end

  def create(conn, %{"padrinamento" => padrinamento_params}) do
    with {:ok, %Padrinamento{} = padrinamento} <-
           Padrinamentos.create_padrinamento_simple(padrinamento_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.padrinamento_path(conn, :show, padrinamento))
      |> render("show.json", padrinamento: padrinamento)
    end
  end

  def show(conn, %{"id" => id}) do
    padrinamento = Padrinamentos.get_padrinamento!(id)
    render(conn, "show.json", padrinamento: padrinamento)
  end

  def update(conn, %{"id" => id, "padrinamento" => padrinamento_params}) do
    padrinamento = Padrinamentos.get_padrinamento!(id)

    with {:ok, %Padrinamento{} = padrinamento} <-
           Padrinamentos.update_padrinamento_simple(padrinamento, padrinamento_params) do
      render(conn, "show.json", padrinamento: padrinamento)
    end
  end

  def delete(conn, %{"id" => id}) do
    padrinamento = Padrinamentos.get_padrinamento!(id)

    with {:ok, %Padrinamento{}} <- Padrinamentos.delete_padrinamento(padrinamento) do
      send_resp(conn, :no_content, "")
    end
  end
end
