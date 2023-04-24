defmodule ProtectoraWeb.PadrinamentoLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Padrinamentos
  alias Protectora.Padrinamentos.Padrinamento

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :padrinamento_collection, list_padrinamento())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Padrinamento")
    |> assign(:padrinamento, Padrinamentos.get_padrinamento!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Padrinamento")
    |> assign(:padrinamento, %Padrinamento{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Padrinamento")
    |> assign(:padrinamento, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    padrinamento = Padrinamentos.get_padrinamento!(id)
    {:ok, _} = Padrinamentos.delete_padrinamento(padrinamento)

    {:noreply, assign(socket, :padrinamento_collection, list_padrinamento())}
  end

  defp list_padrinamento do
    Padrinamentos.list_padrinamento()
  end
end
