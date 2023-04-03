defmodule ProtectoraWeb.VoluntarioLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Voluntarios
  alias Protectora.Voluntarios.Voluntario

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :voluntario_collection, list_voluntario())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Voluntario")
    |> assign(:voluntario, Voluntarios.get_voluntario!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Voluntario")
    |> assign(:voluntario, %Voluntario{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Voluntario")
    |> assign(:voluntario, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    voluntario = Voluntarios.get_voluntario!(id)
    {:ok, _} = Voluntarios.delete_voluntario(voluntario)

    {:noreply, assign(socket, :voluntario_collection, list_voluntario())}
  end

  defp list_voluntario do
    Voluntarios.list_voluntario()
  end
end
