defmodule ProtectoraWeb.RexistroLive.FormComponent do
  use ProtectoraWeb, :live_component

  alias Protectora.Rexistros
  alias Protectora.Rexistros.Rexistro

  require Logger

  @impl true
  def update(%{rexistro: rexistro} = assigns, socket) do
    changeset = Rexistros.change_rexistro(rexistro, %{animal_id: assigns.rexistro.id})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:animal, assigns.rexistro.animal_id)
     |> assign(:rexistro, assigns.rexistro)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"rexistro" => rexistro_params}, socket) do
    changeset =
      socket.assigns.rexistro
      |> Rexistros.change_rexistro(rexistro_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"rexistro" => rexistro_params}, socket) do
    save_rexistro(socket, socket.assigns.action, rexistro_params)
  end

  defp save_rexistro(socket, :edit, rexistro_params) do
    case Rexistros.update_rexistro(socket.assigns.rexistro, rexistro_params) do
      {:ok, _rexistro} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rexistro updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_rexistro(socket, :edit_rexistro, rexistro_params) do
    case Rexistros.update_rexistro(socket.assigns.rexistro, rexistro_params) do
      {:ok, _rexistro} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rexistro updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_rexistro(socket, :new, rexistro_params) do
    case Rexistros.create_rexistro(rexistro_params) do
      {:ok, _rexistro} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rexistro created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_rexistro(socket, :new_rexistro, rexistro_params) do
    case Rexistros.create_rexistro(%{
           animal_id: socket.assigns.animal,
           titulo: rexistro_params["titulo"],
           descricion: rexistro_params["descricion"],
           prezo: rexistro_params["prezo"]
         }) do
      {:ok, _rexistro} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rexistro created successfully correct")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
