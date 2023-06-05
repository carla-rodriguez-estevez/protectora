defmodule ProtectoraWeb.AnimalLive.Show do
  use ProtectoraWeb, :live_view

  alias Protectora.Animais

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, :user_token, Map.get(session, "user_token"))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:animal, Animais.get_animal!(id))}
  end

  defp page_title(:show), do: "Show Animal"
  defp page_title(:edit), do: "Edit Animal"
end
