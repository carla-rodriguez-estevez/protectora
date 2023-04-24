defmodule ProtectoraWeb.AnimalLive.PadrinamentosList do
  use ProtectoraWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
      <div id='padrin@s'>
    <h1>Listing Padrinamento</h1>

    <%= if @live_action in [:new, :edit] and @padrinamento != nil do %>
    <.modal return_to={Routes.padrinamento_index_path(@socket, :index)}>
    <.live_component
      module={ProtectoraWeb.PadrinamentoLive.FormComponent}
      id={@padrinamento.id || :new}
      title={@page_title}
      action={@live_action}
      padrinamento={@padrinamento}
      return_to={Routes.padrinamento_index_path(@socket, :index)}
    />
    </.modal>
    <% end %>

    <table>
    <thead>
    <tr>
      <th>Perioricidade</th>
      <th>Catidade aporte</th>

      <th></th>
    </tr>
    </thead>
    <tbody id="padrinamento">
    <%= for padrinamento <- @padrinamento_collection do %>
      <tr id={"padrinamento-#{padrinamento.id}"}>
        <td><%= padrinamento.perioricidade %></td>
        <td><%= padrinamento.catidade_aporte %></td>

        <td>
          <span><%= live_redirect "Show", to: Routes.padrinamento_show_path(@socket, :show, padrinamento) %></span>
          <span><%= live_patch "Edit", to: Routes.padrinamento_index_path(@socket, :edit, padrinamento) %></span>
          <span><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: padrinamento.id, data: [confirm: "Are you sure?"] %></span>
        </td>
      </tr>
    <% end %>
    </tbody>
    </table>

    <span><%= live_patch "New Padrinamento", to: Routes.padrinamento_index_path(@socket, :new) %></span>

      </div>
    """
  end
end
