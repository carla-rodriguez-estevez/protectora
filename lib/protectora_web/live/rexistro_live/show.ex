defmodule ProtectoraWeb.RexistroLive.Show do
  use ProtectoraWeb, :live_view

  alias Protectora.Rexistros

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:rexistro, Rexistros.get_rexistro!(id))}
  end

  defp page_title(:show), do: "Ensinar Rexistro"
  defp page_title(:edit), do: "Editar Rexistro"
end
