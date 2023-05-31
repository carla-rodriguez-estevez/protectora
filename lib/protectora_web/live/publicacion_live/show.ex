defmodule ProtectoraWeb.PublicacionLive.Show do
  use ProtectoraWeb, :live_view

  alias Protectora.Publicacions

  @impl true
  def mount(_params, session, socket) do
    assigns = [
      page_title: "Mostar Publicación",
      user_token: Map.get(session, "user_token")
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:publicacion, Publicacions.get_publicacion!(id))}
  end

  defp page_title(:show), do: "Mostar Publicación"
  defp page_title(:edit), do: "Editar Publicación"
end
