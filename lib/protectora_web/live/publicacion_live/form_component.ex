defmodule ProtectoraWeb.PublicacionLive.FormComponent do
  use ProtectoraWeb, :live_component

  require Logger

  alias Protectora.Publicacions
  alias Protectora.Publicacions.Publicacion

  def upload_directory do
    Application.get_env(:protectora, :publicacions_directory)
  end

  def local_path(id, filename) do
    [upload_directory(), "#{id}-#{filename}"]
    |> Path.join()
  end


  @impl true
  def mount(socket) do
    {:ok, allow_upload(socket, :photo, accept: ~w(.png .jpeg .jpg), max_entries: 8,  max_file_size: 2_000_000)}
  end

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

  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end

  defp save_publicacion(socket, :edit, publicacion_params) do
    case Publicacions.update_publicacion(socket.assigns.publicacion, publicacion_params, &consume_upload_photos(socket, &1)) do
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
    case Publicacions.create_publicacion(publicacion_params, &consume_photos(socket, &1)) do
      {:ok, _publicacion} ->
        {:noreply,
         socket
         |> put_flash(:info, "Publicacion created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  defp put_photo_urls(socket, %Publicacion{} = post) do
    {completed, []} = uploaded_entries(socket, :photo)

    urls =
      for entry <- completed do
       # IO.inspect entry
        Routes.static_path(socket, "/publicacions/#{entry.uuid}.#{ext(entry)}")
      end

    %Publicacion{post | imaxe_publicacion: urls}
  end

  def consume_photos(socket,  %Publicacion{} = post) do
    consume_uploaded_entries(socket, :photo,  fn meta, entry ->

      dest =  local_path(entry.uuid, entry.client_name)
      File.cp!(meta.path, dest)

      path_name = String.replace(dest, "priv/static", "")
      {:ok, path_name}

    end)

  end

  def consume_upload_photos(socket,  %Publicacion{} = post) do
    {completed, []} = uploaded_entries(socket, :photo)

    case completed do
      [h | _] -> Enum.each(post.imaxe_publicacion, fn el -> File.rm!(Path.join(["priv/static", el.path_imaxe])) end)
      [] -> {:ok, []}
    end

    consume_uploaded_entries(socket, :photo,  fn meta, entry ->

      dest =  local_path(entry.uuid, entry.client_name)
      File.cp!(meta.path, dest)

      path_name = String.replace(dest, "priv/static", "")
      {:ok, path_name}

    end)

  end

end
