defmodule ProtectoraWeb.PublicacionLive.Show do
  use ProtectoraWeb, :live_view

  alias Protectora.Publicacions

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:publicacion, Publicacions.get_publicacion!(id))}
  end

  defp page_title(:show), do: "Show Publicacion"
  defp page_title(:edit), do: "Edit Publicacion"
end
