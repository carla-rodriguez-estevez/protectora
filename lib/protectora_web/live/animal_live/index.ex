defmodule ProtectoraWeb.AnimalLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Animais
  alias Protectora.Animais.Animal

  require Logger

  defp list_animal(params, filters) do
    Animais.list_animal_paginated(params, filters)
  end

  @impl true
  def mount(params, session, socket) do
    if connected?(socket), do: Animais.subscribe()

    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } =
      if connected?(socket) do
        list_animal(params, %{"nome" => ""})
      else
        %Scrivener.Page{}
      end

    assigns = [
      conn: socket,
      animais: entries,
      page_number: page_number || 0,
      page_size: page_size || 0,
      total_entries: total_entries || 0,
      total_pages: total_pages || 0,
      page_title: nil,
      live_action: :index,
      animal: %Animal{},
      # filters: Map.get(params, "tamano", ""),
      filters: %{"nome" => ""},
      user_token: Map.get(session, "user_token")
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(%{"animais" => page}, _url, socket) do
    assigns = get_and_assign_page(page, socket.assigns.filters)

    {:noreply,
     apply_action(assign(socket, assigns), socket.assigns.live_action, %{"page" => page})}
  end

  def handle_params(params, _url, socket) do
    if is_nil(socket.assigns.page_number) do
      assigns = get_and_assign_page(0, socket.assigns.filters)
      {:noreply, apply_action(assign(socket, assigns), socket.assigns.live_action, params)}
    else
      assigns = get_and_assign_page(socket.assigns.page_number, %{"nome" => ""})
      {:noreply, apply_action(assign(socket, assigns), socket.assigns.live_action, params)}
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Engadir animal")
    |> assign(:animal, %Animal{})
    |> assign(:live_action, :new)
    |> assign(:filters, socket.assigns.filters)
    |> assign(:page_number, socket.assigns.page_number)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista animais")
    |> assign(:filters, socket.assigns.filters)
    |> assign(:animal, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    animal = Animais.get_animal!(id)
    {:ok, _} = Animais.delete_animal(animal)

    {:noreply, assign(socket, :animais, list_animal(socket.assigns, socket.assigns.filters))}
  end

  def handle_event("filter-form", filters, socket) do
    # Aplica los filtros al estado de la LiveView y obtén los registros paginados
    assigns = get_and_assign_page(socket.assigns.page_number, filters)

    # Actualiza los registros y la paginación en el estado de la LiveView
    new_socket = assign(socket, assigns)

    {:noreply, new_socket}
  end

  def handle_event("nav", %{"page" => page}, socket) do
    new_socket = assign(socket, filter: socket.assigns.filters)

    {:noreply, push_patch(new_socket, to: "/animal?animais=" <> page, replace: true)}
  end

  # "animal/?animais=" <> page

  @impl true
  def handle_info({:animal_created, animal}, socket) do
    {:noreply,
     update(socket, :animais, fn animais ->
       [animal | animais]
     end)}
  end

  @impl true

  def handle_info({:animal_updated, animal}, socket) do
    list = Enum.filter(socket.assigns.animais, fn el -> el.id != animal.id end)

    {:noreply,
     update(socket, :animais, fn _animais ->
       [animal | list]
     end)}
  end

  def handle_info({:animal_deleted, animal}, socket) do
    list = Enum.filter(socket.assigns.animais, fn el -> el.id != animal.id end)

    assigns = [
      animais: list
    ]

    {:noreply, assign(socket, assigns)}
  end

  def get_and_assign_page(page_number, filters) do
    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Animais.list_animal_paginated([page: page_number], filters)

    [
      animais: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages,
      filters: filters
    ]
  end
end
