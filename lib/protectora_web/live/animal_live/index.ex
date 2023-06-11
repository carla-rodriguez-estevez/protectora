defmodule ProtectoraWeb.AnimalLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Animais
  alias Protectora.Animais.Animal

  defp list_animal(params) do
    Animais.list_animal_paginated(params)
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
        list_animal(params)
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
      user_token: Map.get(session, "user_token")
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(%{"animais" => page}, _url, socket) do
    assigns = get_and_assign_page(page)

    {:noreply,
     apply_action(assign(socket, assigns), socket.assigns.live_action, %{"page" => page})}
  end

  def handle_params(params, _url, socket) do
    if is_nil(socket.assigns.page_number) do
      assigns = get_and_assign_page(0)
      {:noreply, apply_action(assign(socket, assigns), socket.assigns.live_action, params)}
    else
      assigns = get_and_assign_page(socket.assigns.page_number)
      {:noreply, apply_action(assign(socket, assigns), socket.assigns.live_action, params)}
    end
  end

  # No longer used in this page
  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Editar animal")
  #   |> assign(:animal, Animais.get_animal!(id))
  #   |> assign(:live_action, :edit)
  #   |> assign(:page_number, socket.assigns.page_number)
  # end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Engadir animal")
    |> assign(:animal, %Animal{})
    |> assign(:live_action, :edit)
    |> assign(:page_number, socket.assigns.page_number)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista animais")
    |> assign(:animal, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    animal = Animais.get_animal!(id)
    {:ok, _} = Animais.delete_animal(animal)

    {:noreply, assign(socket, :animais, list_animal(socket.assigns))}
  end

  def handle_event("nav", %{"page" => page}, socket) do
    {:noreply,
     push_redirect(socket,
       to: "/animal?animais=" <> page
     )}
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

  def get_and_assign_page(page_number) do
    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Animais.list_animal_paginated(page: page_number)

    [
      animais: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    ]
  end
end
