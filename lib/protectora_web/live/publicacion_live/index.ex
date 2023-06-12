defmodule ProtectoraWeb.PublicacionLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Publicacions
  alias Protectora.Publicacions.Publicacion

  require Logger

  @impl true
  def mount(params, session, socket) do
    if connected?(socket), do: Publicacions.subscribe()

    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } =
      if connected?(socket) do
        Publicacions.list_publicacion_paginated(params)
      else
        %Scrivener.Page{}
      end

    assigns = [
      conn: socket,
      posts: entries,
      page_number: page_number || 0,
      page_size: page_size || 0,
      total_entries: total_entries || 0,
      total_pages: total_pages || 0,
      publicacion: %Publicacion{},
      live_action: :index,
      page_title: nil,
      user_token: Map.get(session, "user_token")
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(%{"posts" => page} = params, _url, socket) do
    assigns = get_and_assign_page(page)

    {:noreply, apply_action(assign(socket, assigns), socket.assigns.live_action, params)}
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

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   Logger.warn("Edito")
  #   Logger.warn(id)

  #   socket
  #   |> assign(:page_title, "Edit Publicacion")
  #   |> assign(:publicacion, Publicacions.get_publicacion!(id))
  # end

  defp apply_action(socket, :new, params) do
    socket
    |> assign(:page_title, "Nova Publicación")
    |> assign(:publicacion, %Publicacion{})
    |> assign(:live_action, :new)
    |> assign(:page_number, socket.assigns.page_number)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista Publicación")
    |> assign(:publicacion, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    publicacion = Publicacions.get_publicacion!(id)
    {:ok, _} = Publicacions.delete_publicacion(publicacion)

    {:noreply, assign(socket, [])}
  end

  def handle_event("nav", %{"page" => page}, socket) do
    {:noreply,
     push_redirect(socket,
       to: "/publicacion?posts=" <> page
     )}
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply,
     update(socket, :posts, fn posts ->
       [post | posts]
     end)}
  end

  @impl true

  def handle_info({:post_updated, post}, socket) do
    list = Enum.filter(socket.assigns.posts, fn el -> el.id != post.id end)

    {:noreply,
     update(socket, :posts, fn _posts ->
       list ++ [post]
     end)}
  end

  def handle_info({:post_deleted, post}, socket) do
    list = Enum.filter(socket.assigns.posts, fn el -> el.id != post.id end)

    assigns = [
      posts: list,
      publicacion: %Publicacion{}
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
    } = Publicacions.list_publicacion_paginated(page: page_number)

    [
      posts: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    ]
  end
end
