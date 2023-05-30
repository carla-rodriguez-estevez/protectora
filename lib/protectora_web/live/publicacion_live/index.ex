defmodule ProtectoraWeb.PublicacionLive.Index do
  use ProtectoraWeb, :live_view
  require Logger

  alias Protectora.Publicacions
  alias Protectora.Publicacions.Publicacion

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Publicacions.subscribe()

    assigns = [
      posts: list_publicacion(),
      user_token: Map.get(session, "user_token")
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Publicacion")
    |> assign(:publicacion, Publicacions.get_publicacion!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Publicacion")
    |> assign(:publicacion, %Publicacion{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Publicacion")
    |> assign(:publicacion, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    publicacion = Publicacions.get_publicacion!(id)
    {:ok, _} = Publicacions.delete_publicacion(publicacion)

    {:noreply, assign(socket, [])}
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
      posts: list
    ]

    {:noreply, assign(socket, assigns)}
  end

  defp list_publicacion do
    Publicacions.list_publicacion()
  end
end
