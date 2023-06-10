defmodule ProtectoraWeb.RexistroLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Rexistros
  alias Protectora.Rexistros.Rexistro

  require Logger

  @impl true
  def mount(params, session, socket) do
    if connected?(socket), do: Rexistros.subscribe()

    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } =
      if connected?(socket) do
        Rexistros.list_rexistro_paginated(params)
      else
        %Scrivener.Page{}
      end

    assigns = [
      conn: socket,
      rexistro_collection: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages,
      rexistro: %Rexistro{},
      live_action: :index,
      page_title: "rexistro",
      user_token: Map.get(session, "user_token")
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(%{"rexistros" => page} = params, _url, socket) do
    assigns = get_and_assign_page(page, socket.assigns.live_action)

    {:noreply,
     apply_action(assign(socket, assigns), socket.assigns.live_action, %{
       "rexistros" => socket.assigns.page_number
     })}
  end

  def handle_params(%{"id" => id} = params, _url, socket) do
    if is_nil(socket.assigns.page_number) do
      assigns = get_and_assign_page(0, socket.assigns.live_action)
      {:noreply, apply_action(assign(socket, assigns), socket.assigns.live_action, params)}
    else
      assigns = get_and_assign_page(socket.assigns.page_number, socket.assigns.live_action)
      {:noreply, apply_action(assign(socket, assigns), socket.assigns.live_action, params)}
    end
  end

  def handle_params(params, _url, socket) do
    assigns = get_and_assign_page(0, socket.assigns.live_action)

    {:noreply,
     apply_action(assign(socket, assigns), socket.assigns.live_action, %{
       "rexistros" => socket.assigns.page_number
     })}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar rexistro")
    |> assign(:rexistro, Rexistros.get_rexistro!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Novo rexistro")
    |> assign(:rexistro, %Rexistro{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista de rexistros")
    |> assign(:rexistro, nil)
  end

  @impl true
  def handle_event("nav", %{"page" => page}, socket) do
    {:noreply,
     push_redirect(assign(socket, get_and_assign_page(page, socket.assigns.live_action)),
       to: "/rexistro?rexistros=" <> page
     )}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    rexistro = Rexistros.get_rexistro!(id)
    {:ok, _} = Rexistros.delete_rexistro(rexistro)

    {:noreply, assign(socket, :rexistro_collection, list_rexistro())}
  end

  @impl true
  def handle_info({:rexistro_created, rexistro}, socket) do
    {:noreply,
     update(socket, :rexistro_collection, fn rexistro_collection ->
       [rexistro | rexistro_collection]
     end)}
  end

  @impl true

  def handle_info({:rexistro_updated, rexistro}, socket) do
    list = Enum.filter(socket.assigns.rexistro_collection, fn el -> el.id != rexistro.id end)

    {:noreply,
     update(socket, :rexistro_collection, fn _rexistro_collection ->
       [rexistro | list]
     end)}
  end

  def handle_info({:rexistro_deleted, rexistro}, socket) do
    list = Enum.filter(socket.assigns.rexistro_collection, fn el -> el.id != rexistro.id end)

    assigns = [
      rexistro_collection: list
    ]

    {:noreply, assign(socket, assigns)}
  end

  defp list_rexistro do
    Rexistros.list_rexistro()
  end

  def get_and_assign_page(page, live_action) do
    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Rexistros.list_rexistro_paginated(page: page)

    [
      rexistro_collection: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages,
      live_action: live_action,
      rexistro: %Rexistro{}
    ]
  end
end
