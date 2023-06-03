defmodule ProtectoraWeb.ColaboradorLive.Show do
  use ProtectoraWeb, :live_view

  alias Protectora.Colaboradores

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:colaborador, Colaboradores.get_colaborador!(id))}
  end

  defp page_title(:show), do: "Detalles colaborador"
  defp page_title(:edit), do: "Editar colaborador"
end
