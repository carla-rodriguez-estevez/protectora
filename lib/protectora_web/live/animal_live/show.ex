defmodule ProtectoraWeb.AnimalLive.Show do
  use ProtectoraWeb, :live_view

  alias Protectora.Animais
  alias Protectora.Padrinamentos.Padrinamento
  alias Protectora.Padrinamentos
  alias Protectora.Rexistros
  alias Protectora.Rexistros.Rexistro

  require Logger
  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, user_token: Map.get(session, "user_token"))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    animal = Animais.get_animal!(id)

    image =
      if length(animal.imaxe_animal) > 0 do
        Enum.at(animal.imaxe_animal, 0)
      else
        nil
      end

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:rexistro, nil)
     |> assign(:current_image, image)
     |> assign(:index_image, 0)
     |> assign(:animal, animal)}
  end

  @impl true

  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new_padrinamento, _params) do
    socket
    |> assign(:page_title, "Novo Padriñamento")
    |> assign(:live_action, :new_padrinamento)
    |> assign(:padrinamento, %Padrinamento{})
  end

  defp apply_action(socket, :edit_padrinamento, _params) do
    socket
    |> assign(:page_title, "Editar Padriñamento")
    |> assign(:live_action, :edit_padrinamento)
    |> assign(:padrinamento, socket.assigns.padrinamento)
  end

  defp apply_action(socket, :new_rexistro, _params) do
    socket
    |> assign(:page_title, "Novo rexistro")
    |> assign(:live_action, :new_rexistro)
    |> assign(:animal, socket.assigns.animal)
    |> assign(:rexistro, %Rexistro{})
  end

  defp apply_action(socket, :edit_rexistro, %{"idrexistro" => id}) do
    rexistro = Rexistros.get_rexistro!(id)

    socket
    |> assign(:rexistro, id)
    |> assign(:page_title, "Editar Padriñamento")
    |> assign(:live_action, :edit_rexistro)
    |> assign(:animal, Animais.get_animal!(rexistro.animal.id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    padrinamento = Padrinamentos.get_padrinamento!(id)
    {:ok, _} = Padrinamentos.delete_padrinamento(padrinamento)

    {:noreply, assign(socket, :animal, Animais.get_animal!(socket.assigns.animal.id))}
  end

  @impl true
  def handle_event("delete-rexistro", %{"id" => id}, socket) do
    rexistro = Rexistros.get_rexistro!(id)
    {:ok, _} = Rexistros.delete_rexistro(rexistro)

    {:noreply, assign(socket, :animal, Animais.get_animal!(socket.assigns.animal.id))}
  end

  @impl true
  def handle_event("prev", _, socket) do
    images = socket.assigns.animal.imaxe_animal
    images_length = length(images)

    index = socket.assigns.index_image

    if index == 0 do
      {:noreply,
       socket
       |> assign(
         index_image: images_length - 1,
         current_image: Enum.at(images, images_length - 1)
       )}
    else
      {:noreply,
       socket
       |> assign(index_image: index - 1, current_image: Enum.at(images, index - 1))}
    end
  end

  def handle_event("next", _, socket) do
    images = socket.assigns.animal.imaxe_animal
    images_length = length(images) - 1

    index = socket.assigns.index_image

    if index == images_length do
      {:noreply,
       socket
       |> assign(index_image: 0, current_image: Enum.at(images, 0))}
    else
      {:noreply,
       socket
       |> assign(index_image: index + 1, current_image: Enum.at(images, index + 1))}
    end
  end

  defp page_title(:show), do: "Ensinar Animal"
  defp page_title(:edit), do: "Editar Animal"
  defp page_title(:new_padrinamento), do: "Novo padriñamento"
  defp page_title(:edit_padrinamento), do: "Editar padriñamento"
  defp page_title(:new_rexistro), do: "Novo rexistro"
  defp page_title(:edit_rexistro), do: "Editar rexistro"
end
