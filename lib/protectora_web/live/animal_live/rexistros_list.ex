defmodule ProtectoraWeb.AnimalLive.RexistrosList do
  use ProtectoraWeb, :live_component
  alias Protectora.Rexistros
  alias Protectora.Rexistros.Rexistro

  @impl true
  def update(assigns, socket) do
    case assigns.live_action do
      :new_rexistro ->
        {:ok,
         socket
         |> assign(assigns)
         |> assign(:animal, assigns.animal)
         |> assign(:rexistro, %Rexistro{animal_id: assigns.animal.id})
         |> assign(:changeset, %Rexistro{})}

      :edit_rexistro ->
        {:ok,
         socket
         |> assign(assigns)
         |> assign(:rexistro, Rexistros.get_rexistro!(assigns.rexistro))
         |> assign(:animal, assigns.animal)
         |> assign(
           :changeset,
           Rexistros.change_rexistro(Rexistros.get_rexistro!(assigns.rexistro))
         )}

      _ ->
        {:ok,
         socket
         |> assign(assigns)
         |> assign(:animal, assigns.animal)
         |> assign(:rexistro, nil)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="gastos-list">

    <div class=" flex flex-col justify-center">
    <div class="flex justify-center items-center">

    <h1 class="mt-3 text-xl sm:text-2xl font-extrabold leading-none tracking-tight text-gray-900  dark:text-white">Rexistros</h1>
        </div>

    <%= if @live_action in [:new_rexistro, :edit_rexistro] and @rexistro != nil do %>
    <.modal return_to={Routes.animal_show_path(@socket, :show, @animal)}>
      <.live_component
        module={ProtectoraWeb.RexistroLive.FormComponent}
        id={@live_action}
        title={@page_title}
        action={@live_action}
        rexistro={@rexistro}
        return_to={Routes.animal_show_path(@socket, :show, @animal)}
      />
    </.modal>
    <% end %>

    <div class="relative overflow-x-auto p-6">
    <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400 p-4 rounded-lg">
    <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
      <tr>
        <th scope="col" class="px-6 py-3">Título</th>
        <th scope="col" class="hidden md:table-cell px-6 py-3">Descrición</th>
        <th scope="col" class="px-6 py-3">Prezo</th>

        <th scope="col" class="px-6 py-3"></th>
        <th scope="col" class="hidden md:table-cell px-6 py-3"></th>

      </tr>
    </thead>
    <tbody id="rexistro">
      <%= for rexistro <- @rexistro_collection do %>
        <tr class="bg-white border-b dark:bg-gray-900 dark:border-gray-700" id={"rexistro-#{rexistro.id}"}>
          <td scope="row"  class="px-6 py-4 font-medium bg-gray-50 text-gray-900 whitespace-nowrap dark:text-white"><%= rexistro.titulo %></td>
          <td scope="row"  class="hidden md:table-cell px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white w-18 truncate long-cell"><%= rexistro.descricion %></td>
          <td scope="row"  class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white "><%= rexistro.prezo %>€</td>
          <td scope="row"  class="hidden md:table-cell px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white underline underline-offset-3 decoration-2 decoration-black-400 "><span><%= live_redirect "Ver detalle ", to: Routes.rexistro_show_path(@socket, :show, rexistro) %></span></td>
          <td scope="row"  class="flex flex-col px-6 py-4 bg-gray-50 font-medium text-gray-900 whitespace-nowrap dark:text-white">
            <span class="underline underline-offset-3 decoration-2 decoration-black-400 "><%= live_patch "Editar", to:  Routes.animal_show_path(@socket, :edit_rexistro,  rexistro)  %></span>
            <span class="underline underline-offset-3 decoration-2 decoration-black-400 "><%= link "Eliminar", to: "#", phx_click: "delete-rexistro", phx_value_id: rexistro.id, data: [confirm: "Está seguro de querer realizar esta acción?"] %></span>
          </td>
        </tr>
      <% end %>
    </tbody>
    </table>
    </div>
    </div>

    <span><%= live_patch "New Rexistro", to: Routes.animal_show_path(@socket, :new_rexistro,  @animal.id)%></span>
    </div>
    """
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new_rexistro, _params) do
    socket
    |> assign(:page_title, "Novo rexistro")
    |> assign(:live_action, :new_rexistro)
    |> assign(:animal, socket.assigns.animal)
    |> assign(:rexistro, %Rexistro{animal_id: socket.assigns.animal.id})
  end

  defp apply_action(socket, :edit_rexistro, _params) do
    socket
    |> assign(:page_title, "Editar rexistro")
    |> assign(:live_action, :edit_rexistro)
    |> assign(:animal, socket.assigns.animal)
    |> assign(:rexistro, %Rexistro{})
  end
end
