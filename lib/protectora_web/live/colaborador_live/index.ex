defmodule ProtectoraWeb.ColaboradorLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Colaboradores
  alias Protectora.Colaboradores.Colaborador

  require Logger

  @impl true
  def mount(params, _session, socket) do
    if connected?(socket), do: Colaboradores.subscribe()

    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } =
      if connected?(socket) do
        Colaboradores.list_colaborador_paginated(params)
      else
        %Scrivener.Page{}
      end

    assigns = [
      conn: socket,
      colaboradores: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages,
      colaborador: nil,
      page_title: "Mostar colaboradores",
      live_action: socket.assigns.live_action
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(%{"colaboradores" => page} = params, _url, socket) do
    assigns = get_and_assign_page(page, socket.assigns.live_action)

    {:noreply,
     apply_action(assign(socket, assigns), socket.assigns.live_action, %{
       "colaboradores" => socket.assigns.page_number
     })}
  end

  def handle_params(%{"id" => id} = params, _url, socket) do
    assigns = get_and_assign_page(0, socket.assigns.live_action)

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_params(params, _url, socket) do
    assigns = get_and_assign_page(0, socket.assigns.live_action)

    {:noreply,
     apply_action(assign(socket, assigns), socket.assigns.live_action, %{
       "colaboradores" => socket.assigns.page_number
     })}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar colaborador")
    |> assign(:live_action, :edit)
    |> assign(:colaborador, Colaboradores.get_colaborador!(id))
    |> assign(:page_number, socket.assigns.page_number)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista de colaboradores")
    |> assign(:live_action, :index)
    |> assign(:colaborador, nil)
  end

  def handle_event("nav", %{"page" => page}, socket) do
    {:noreply,
     push_redirect(assign(socket, get_and_assign_page(page, socket.assigns.live_action)),
       to: "/colaborador?colaboradores=" <> page
     )}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    colaborador = Colaboradores.get_colaborador!(id)
    {:ok, _} = Colaboradores.delete_colaborador(colaborador)

    {:noreply,
     assign(socket, get_and_assign_page(socket.assigns.page_number, socket.assigns.live_action))}
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

  def get_and_assign_page(page, live_action) do
    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Colaboradores.list_colaborador_paginated(page: page)

    [
      colaboradores: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages,
      live_action: live_action,
      colaborador: %Colaborador{}
    ]
  end
end
