defmodule ProtectoraWeb.ColaboradorLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Colaboradores
  alias Protectora.Colaboradores.Colaborador

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Colaboradores.subscribe()

    assigns = [
      colaboradores: list_colaborador()
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Colaborador")
    |> assign(:colaborador, Colaboradores.get_colaborador!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Novo Colaborador")
    |> assign(:colaborador, %Colaborador{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista de colaboradores")
    |> assign(:colaborador, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    colaborador = Colaboradores.get_colaborador!(id)
    {:ok, _} = Colaboradores.delete_colaborador(colaborador)

    {:noreply, assign(socket, :colaboradores, list_colaborador())}
  end

  @impl true
  def handle_info({:colaborador_created, colaborador}, socket) do
    {:noreply,
     update(socket, :colaboradores, fn colaboradores ->
       [colaborador | colaboradores]
     end)}
  end

  @impl true

  def handle_info({:colaborador_updated, colaborador}, socket) do
    list = Enum.filter(socket.assigns.colaboradores, fn el -> el.id != colaborador.id end)

    {:noreply,
     update(socket, :colaboradores, fn _colaboradores ->
       [colaborador | list]
     end)}
  end

  def handle_info({:colaborador_deleted, colaborador}, socket) do
    list = Enum.filter(socket.assigns.colaboradores, fn el -> el.id != colaborador.id end)

    assigns = [
      colaboradores: list
    ]

    {:noreply, assign(socket, assigns)}
  end

  defp list_colaborador do
    Colaboradores.list_colaborador()
  end
end
