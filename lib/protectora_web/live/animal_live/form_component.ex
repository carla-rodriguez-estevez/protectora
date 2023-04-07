defmodule ProtectoraWeb.AnimalLive.FormComponent do
  use ProtectoraWeb, :live_component

  alias Protectora.Animais

  @impl true
  def update(%{animal: animal} = assigns, socket) do
    changeset = Animais.change_animal(animal)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"animal" => animal_params}, socket) do
    changeset =
      socket.assigns.animal
      |> Animais.change_animal(animal_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"animal" => animal_params}, socket) do
    save_animal(socket, socket.assigns.action, animal_params)
  end

  defp save_animal(socket, :edit, animal_params) do
    case Animais.update_animal(socket.assigns.animal, animal_params) do
      {:ok, _animal} ->
        {:noreply,
         socket
         |> put_flash(:info, "Animal updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_animal(socket, :new, animal_params) do
    case Animais.create_animal(animal_params) do
      {:ok, _animal} ->
        {:noreply,
         socket
         |> put_flash(:info, "Animal created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
