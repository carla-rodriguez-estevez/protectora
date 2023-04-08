defmodule ProtectoraWeb.RexistroLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Rexistros
  alias Protectora.Rexistros.Rexistro

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Rexistros.subscribe()

    assigns = [
      rexistro_collection: list_rexistro()
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Rexistro")
    |> assign(:rexistro, Rexistros.get_rexistro!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Rexistro")
    |> assign(:rexistro, %Rexistro{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Rexistro")
    |> assign(:rexistro, nil)
  end

  @impl true
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
end
