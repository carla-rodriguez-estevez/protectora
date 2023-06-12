defmodule ProtectoraWeb.PublicacionLive.Show do
  use ProtectoraWeb, :live_view

  alias Protectora.Publicacions

  @impl true
  def mount(_params, session, socket) do
    assigns = [
      page_title: "Mostar Publicación",
      user_token: Map.get(session, "user_token")
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    publicacion = Publicacions.get_publicacion!(id)

    image =
      if length(publicacion.imaxe_publicacion) > 0 do
        Enum.at(publicacion.imaxe_publicacion, 0)
      else
        nil
      end

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:publicacion, publicacion)
     |> assign(:index_image, 0)
     |> assign(:current_image, image)}
  end

  @impl true
  def handle_event("prev", _, socket) do
    images = socket.assigns.publicacion.imaxe_publicacion
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
    images = socket.assigns.publicacion.imaxe_publicacion
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

  defp page_title(:show), do: "Mostar Publicación"
  defp page_title(:edit), do: "Editar Publicación"
end
