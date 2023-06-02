defmodule ProtectoraWeb.IndexLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Colaboradores.Colaborador
  alias Protectora.Colaboradores

  require Logger

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, user_token: Map.get(session, "user_token"), live_action: nil)}
  end

  @impl true
  def update(%{colaborador: colaborador} = assigns, socket) do
    changeset = Colaboradores.change_colaborador(colaborador)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Voluntario")
    |> assign(:colaborador, %Colaborador{})
  end

  defp apply_action(socket, _, _params) do
    socket
    |> assign(:colaborador, nil)
  end
end
