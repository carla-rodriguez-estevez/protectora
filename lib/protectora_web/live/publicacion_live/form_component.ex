defmodule ProtectoraWeb.PublicacionLive.FormComponent do
  use ProtectoraWeb, :live_component

  alias Protectora.Publicacions

  @impl true
  def update(%{publicacion: publicacion} = assigns, socket) do
    changeset = Publicacions.change_publicacion(publicacion)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"publicacion" => publicacion_params}, socket) do
    changeset =
      socket.assigns.publicacion
      |> Publicacions.change_publicacion(publicacion_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"publicacion" => publicacion_params}, socket) do
    save_publicacion(socket, socket.assigns.action, publicacion_params)
  end

  defp save_publicacion(socket, :edit, publicacion_params) do
    case Publicacions.update_publicacion(socket.assigns.publicacion, publicacion_params) do
      {:ok, _publicacion} ->
        {:noreply,
         socket
         |> put_flash(:info, "Publicacion updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_publicacion(socket, :new, publicacion_params) do
    case Publicacions.create_publicacion(publicacion_params) do
      {:ok, _publicacion} ->
        {:noreply,
         socket
         |> put_flash(:info, "Publicacion created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
