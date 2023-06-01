defmodule ProtectoraWeb.VoluntarioLive.Show do
  use ProtectoraWeb, :live_view

  alias Protectora.Voluntarios

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:voluntario, Voluntarios.get_voluntario!(id))}
  end

  defp page_title(:show), do: "Ensinar Voluntario"
  defp page_title(:edit), do: "Editar Voluntario"
end
