defmodule ProtectoraWeb.RexistroLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Rexistros
  alias Protectora.Rexistros.Rexistro

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :rexistro_collection, list_rexistro())}
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

  defp list_rexistro do
    Rexistros.list_rexistro()
  end
end
