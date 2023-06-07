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

    <h1>Listing Padrinamento</h1>
    <table>
    <thead>
    <tr>
      <th>Perioricidade</th>
      <th>Cantidade aporte</th>

      <th></th>
    </tr>
    </thead>
    <tbody id="padrinamento">
    <%= for padrinamento <- @padrinamento_collection do %>
      <tr id={"padrinamento-#{padrinamento.id}"}>
        <td><%= padrinamento.perioricidade %></td>
        <td><%= padrinamento.cantidade_aporte %></td>

        <td>
          <span><%= live_redirect "Show", to: Routes.padrinamento_show_path(@socket, :show, padrinamento) %></span>
          <span><%= live_patch "Edit", to: Routes.animal_show_path(@socket, :edit_padrinamento, @animal) %></span>
          <span><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: padrinamento.id, data: [confirm: "Are you sure?"] %></span>
        </td>
      </tr>
    <% end %>
    </tbody>
    </table>
    <% end %>
        <span><%= live_patch "New Padrinamento", to: Routes.animal_show_path(@socket, :new_padrinamento,  @animal.id) %></span>
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
    |> assign(:page_title, "New Padrinamento")
    |> assign(:live_action, :new_padrinamento)
    |> assign(:animal, socket.assigns.animal)
    |> assign(:padrinamento, %Padrinamento{})
  end
end
