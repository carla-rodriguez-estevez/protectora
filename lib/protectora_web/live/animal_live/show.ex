defmodule ProtectoraWeb.AnimalLive.Show do
  use ProtectoraWeb, :live_view

  alias Protectora.Animais
  alias Protectora.Padrinamentos.Padrinamento

  require Logger

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, user_token: Map.get(session, "user_token"))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:animal, Animais.get_animal!(id))}
  end

  @impl true

  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new_padrinamento, _params) do
    socket
    |> assign(:page_title, "New Padrinamento")
    |> assign(:live_action, :new_padrinamento)
    |> assign(:padrinamento, %Padrinamento{})
  end

  defp apply_action(socket, :edit_padrinamento, _params) do
    Logger.warn("Nuevo padrino update antes")

    socket
    |> assign(:page_title, "Editar Padrinamento")
    |> assign(:live_action, :edit_padrinamento)
    |> assign(:padrinamento, socket.assigns.padrinamento)
  end

  defp page_title(:show), do: "Show Animal"
  defp page_title(:edit), do: "Edit Animal"
  defp page_title(:new_padrinamento), do: "Novo padriñamento"
  defp page_title(:edit_padrinamento), do: "Editar padriñamento"
end
