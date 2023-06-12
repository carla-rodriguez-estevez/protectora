defmodule ProtectoraWeb.AnimalLive.PadrinamentosList do
  use ProtectoraWeb, :live_component
  alias Protectora.Padrinamentos
  alias Protectora.Padrinamentos.Padrinamento

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
      <div id='padrin@s'>

    <%= if @live_action in [:new_padrinamento, :edit_padrinamento] do %>
    <%= if !is_nil(@animal) do%>
    <.modal return_to={Routes.animal_show_path(@socket, :show, @animal)}>
    <.live_component
      module={ProtectoraWeb.PadrinamentoLive.FormComponent}
      id={ :new}
      title={@page_title}
      action={@live_action}
      padrinamento={@padrinamento}
      return_to={Routes.animal_show_path(@socket, :show, @animal)}
    />
    </.modal>
    <% end %>
    <% end %>
      <%= if @user_token do %>

    <div class=" flex flex-col justify-center">
    <div class="flex justify-center items-center">

    <h1 class="mt-3 text-xl sm:text-2xl font-extrabold leading-none tracking-tight text-gray-900  dark:text-white">Padriños</h1>
        </div>



    <div class="relative overflow-x-auto p-6">
    <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400 p-4 rounded-lg">
    <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
    <tr>
      <th scope="col" class="px-6 py-3">Email</th>
      <th scope="col" class="hidden md:table-cell px-6 py-3">Perioricidade </th>
      <th scope="col" class="hidden md:table-cell px-6 py-3">Perfil de colaborador</th>

      <th scope="col" class="px-6 py-3"></th>
      <th scope="col" class="px-6 py-3"></th>
    </tr>
    </thead>
    <tbody id="padrinamento">
    <%= for padrinamento <- @padrinamento_collection do %>
      <tr class="bg-white border-b dark:bg-gray-900 dark:border-gray-700" id={"padrinamento-#{padrinamento.id}"}>
        <td scope="row"  class="px-6 py-4 font-medium bg-gray-50 text-gray-900 whitespace-nowrap dark:text-white"><%= padrinamento.colaborador.email %></td>
        <td scope="row" class="hidden md:table-cell px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white"><%= padrinamento.perioricidade %></td>
        <td scope="row" class="hidden md:table-cell px-6 py-4 font-medium text-gray-900 whitespace-nowrap  dark:text-white bg-gray-50"><%= live_patch padrinamento.colaborador.nome, to: "/colaborador/" <> padrinamento.colaborador.id %></td>
        <td scope="row"  class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white underline underline-offset-3 decoration-2 decoration-black-400 "><span><%= live_redirect "Ver detalle ", to: Routes.padrinamento_show_path(@socket, :show, padrinamento) %></span></td>

        <td scope="row"  class="flex flex-col px-6 py-4 bg-gray-50 font-medium text-gray-900 whitespace-nowrap dark:text-white">

          <span class="underline underline-offset-3 decoration-2 decoration-black-400 "><%= live_patch "Editar", to: Routes.animal_show_path(@socket, :edit_padrinamento, @animal) %></span>
          <span class="underline underline-offset-3 decoration-2 decoration-black-400 "><%= link "Eliminar", to: "#", phx_click: "delete", phx_value_id: padrinamento.id, data: [confirm: "Está seguro de realizar este borrado permanente?"] %></span>
        </td>
      </tr>
    <% end %>
    </tbody>
    </table>
    </div>
    </div>
    <% end %>
    <div class="flex justify-center items-center">
      <span class="text-white bg-gray-800 hover:bg-gray-900 focus:outline-none focus:ring-4 focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 mr-2 mb-2 dark:bg-gray-800 dark:hover:bg-gray-700 dark:focus:ring-gray-700 dark:border-gray-700 mt-8"><%= live_patch "Convertirse en padriño", to: Routes.animal_show_path(@socket, :new_padrinamento,  @animal.id) %></span>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    if is_nil(assigns.padrinamento) do
      {:ok,
       socket
       |> assign(assigns)
       |> assign(:animal, assigns.animal)
       |> assign(:padrinamento, %Padrinamento{animal_id: assigns.animal.id})
       |> assign(:changeset, %Padrinamento{})}
    else
      changeset = Padrinamentos.change_padrinamento(assigns.padrinamento)

      {:ok,
       socket
       |> assign(assigns)
       |> assign(:padrinamento, changeset)
       |> assign(:animal, assigns.animal)
       |> assign(:changeset, changeset)}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new_padrinamento, _params) do
    socket
    |> assign(:page_title, "Novo Padrinamento")
    |> assign(:live_action, :new_padrinamento)
    |> assign(:animal, socket.assigns.animal)
    |> assign(:padrinamento, %Padrinamento{})
  end
end
