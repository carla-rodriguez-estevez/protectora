defmodule ProtectoraWeb.PadrinamentoLive.Show do
  use ProtectoraWeb, :live_view

  alias Protectora.Padrinamentos

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:padrinamento, Padrinamentos.get_padrinamento!(id))}
  end

  defp page_title(:show), do: "Show Padrinamento"
  defp page_title(:edit), do: "Edit Padrinamento"
end
