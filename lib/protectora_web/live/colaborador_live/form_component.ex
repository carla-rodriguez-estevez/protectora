defmodule ProtectoraWeb.ColaboradorLive.FormComponent do
  use ProtectoraWeb, :live_component

  alias Protectora.Colaboradores
  require Logger
  @impl true
  def update(%{colaborador: colaborador} = assigns, socket) do
    changeset = Colaboradores.change_colaborador(colaborador)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"colaborador" => colaborador_params}, socket) do
    changeset =
      socket.assigns.colaborador
      |> Colaboradores.change_colaborador(colaborador_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"colaborador" => colaborador_params}, socket) do
    save_colaborador(socket, socket.assigns.action, colaborador_params)
  end

  defp save_colaborador(socket, :edit, colaborador_params) do
    case Colaboradores.update_colaborador(socket.assigns.colaborador, colaborador_params) do
      {:ok, _colaborador} ->
        {:noreply,
         socket
         |> put_flash(:info, "Colaborador updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_colaborador(socket, :new, colaborador_params) do
    case Colaboradores.create_colaborador(colaborador_params) do
      {:ok, _colaborador} ->
        {:noreply,
         socket
         |> put_flash(:info, "Colaborador created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
