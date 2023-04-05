defmodule ProtectoraWeb.ColaboradorLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Colaboradores
  alias Protectora.Colaboradores.Colaborador

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :colaborador_collection, list_colaborador())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Colaborador")
    |> assign(:colaborador, Colaboradores.get_colaborador!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Colaborador")
    |> assign(:colaborador, %Colaborador{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Colaborador")
    |> assign(:colaborador, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    colaborador = Colaboradores.get_colaborador!(id)
    {:ok, _} = Colaboradores.delete_colaborador(colaborador)

    {:noreply, assign(socket, :colaborador_collection, list_colaborador())}
  end

  defp list_colaborador do
    Colaboradores.list_colaborador()
  end
end
