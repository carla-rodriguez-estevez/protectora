defmodule ProtectoraWeb.PadrinamentoLive.FormComponent do
  use ProtectoraWeb, :live_component

  alias Protectora.Padrinamentos

  @impl true
  def update(assigns, socket) do
    changeset = Padrinamentos.change_padrinamento(assigns.padrinamento)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"padrinamento" => padrinamento_params}, socket) do
    changeset =
      socket.assigns.padrinamento
      |> Padrinamentos.change_padrinamento(padrinamento_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("validate", %{"colaborador" => padrinamento_params}, socket) do
    changeset =
      socket.assigns.padrinamento
      |> Padrinamentos.change_padrinamento(padrinamento_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"padrinamento" => padrinamento_params}, socket) do
    save_padrinamento(socket, socket.assigns.action, padrinamento_params)
  end

  def handle_event("save", %{"colaborador" => padrinamento_params}, socket) do
    save_padrinamento(socket, socket.assigns.action, padrinamento_params)
  end

  defp save_padrinamento(socket, :edit, padrinamento_params) do
    case Padrinamentos.update_padrinamento(socket.assigns.padrinamento, padrinamento_params) do
      {:ok, _padrinamento} ->
        {:noreply,
         socket
         |> put_flash(:info, "Padriñamento actualizado correctamente")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_padrinamento(socket, :new, padrinamento_params) do
    case Padrinamentos.create_padrinamento(padrinamento_params) do
      {:ok, _padrinamento} ->
        {:noreply,
         socket
         |> put_flash(:info, "Padriñamento creado correctamente")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_padrinamento(socket, :new_padrinamento, padrinamento_params) do
    case Padrinamentos.create_padrinamento(padrinamento_params) do
      {:ok, _padrinamento} ->
        {:noreply,
         socket
         |> put_flash(:info, "Padriñamento creado correctamente")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
