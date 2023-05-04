defmodule ProtectoraWeb.AnimalLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Animais
  alias Protectora.Animais.Animal

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Animais.subscribe()

    assigns = [
      animais: list_animal()
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Animal")
    |> assign(:animal, Animais.get_animal!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Animal")
    |> assign(:animal, %Animal{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Animal")
    |> assign(:animal, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    animal = Animais.get_animal!(id)
    {:ok, _} = Animais.delete_animal(animal)

    {:noreply, assign(socket, :animais, list_animal())}
  end

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

  defp list_animal do
    Animais.list_animal_paginated()
  end
end
