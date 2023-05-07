defmodule ProtectoraWeb.AnimalLive.FormComponent do
  use ProtectoraWeb, :live_component

  alias Protectora.Animais
  alias Protectora.Animais.{Animal, ImaxeAnimal}

  require Logger

  def upload_directory do
    Application.get_env(:protectora, :animais_directory)
  end

  def local_path(id, filename) do
    [upload_directory(), "#{id}-#{filename}"]
    |> Path.join()
  end

  @impl true
  def mount(socket) do
    {:ok,
     allow_upload(socket, :photo,
       accept: ~w(.png .jpeg .jpg),
       max_entries: 8,
       max_file_size: 2_000_000
     )}
  end

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

  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end

  defp save_animal(socket, :edit, animal_params) do
    case Animais.update_animal(
           socket.assigns.animal,
           animal_params,
           &consume_upload_photos(socket, &1)
         ) do
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
    case Animais.create_animal(animal_params, &consume_photos(socket, &1)) do
      {:ok, animal} ->
        {:noreply,
         socket
         |> put_flash(:info, "Animal created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  defp put_photo_urls(socket, %Animal{} = animal) do
    {completed, []} = uploaded_entries(socket, :photo)

    urls =
      for entry <- completed do
        # IO.inspect entry
        Routes.static_path(socket, "/animais/#{entry.uuid}.#{ext(entry)}")
      end

    %Animal{animal | imaxe_animal: urls}
  end

  def consume_photos(socket, %Animal{} = animal) do
    consume_uploaded_entries(socket, :photo, fn meta, entry ->
      dest = local_path(entry.uuid, entry.client_name)
      File.cp!(meta.path, dest)

      path_name = String.replace(dest, "priv/static", "")
      {:ok, path_name}
    end)
  end

  def consume_upload_photos(socket, %Animal{} = animal) do
    {completed, []} = uploaded_entries(socket, :photo)

    case completed do
      [h | _] ->
        Enum.each(animal.imaxe_animal, fn el ->
          File.rm(Path.join(["priv/static", el.path_imaxe]))
        end)

      [] ->
        {:ok, []}
    end

    consume_uploaded_entries(socket, :photo, fn meta, entry ->
      dest = local_path(entry.uuid, entry.client_name)
      File.cp!(meta.path, dest)

      path_name = String.replace(dest, "priv/static", "")
      {:ok, path_name}
    end)
  end
end
