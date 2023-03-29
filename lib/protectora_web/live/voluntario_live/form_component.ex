defmodule ProtectoraWeb.VoluntarioLive.FormComponent do
  use ProtectoraWeb, :live_component

  alias Protectora.Voluntarios

  @impl true
  def update(%{voluntario: voluntario} = assigns, socket) do
    changeset = Voluntarios.change_voluntario(voluntario)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"voluntario" => voluntario_params}, socket) do
    changeset =
      socket.assigns.voluntario
      |> Voluntarios.change_voluntario(voluntario_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"voluntario" => voluntario_params}, socket) do
    save_voluntario(socket, socket.assigns.action, voluntario_params)
  end

  defp save_voluntario(socket, :edit, voluntario_params) do
    case Voluntarios.update_voluntario(socket.assigns.voluntario, voluntario_params) do
      {:ok, _voluntario} ->
        {:noreply,
         socket
         |> put_flash(:info, "Voluntario updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_voluntario(socket, :new, voluntario_params) do
    case Voluntarios.create_voluntario(voluntario_params) do
      {:ok, _voluntario} ->
        {:noreply,
         socket
         |> put_flash(:info, "Voluntario created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
