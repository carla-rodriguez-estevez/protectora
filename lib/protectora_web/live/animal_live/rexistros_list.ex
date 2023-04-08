defmodule ProtectoraWeb.AnimalLive.RexistrosList do
  use ProtectoraWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div id="gastos-list">

    <h1>Listing Rexistro</h1>

    <%= if @live_action in [:new, :edit] and @rexistro != nil do %>
    <.modal return_to={Routes.rexistro_show_path(@socket, :show, @animal)}>
      <.live_component
        module={ProtectoraWeb.RexistroLive.FormComponent}
        id={:new}
        title={@page_title}
        action={@live_action}
        rexistro={@rexistro}
        return_to={Routes.rexistro_show_path(@socket, :show, @animal)}
      />
    </.modal>
    <% end %>

    <table>
    <thead>
      <tr>
        <th>Titulo</th>
        <th>Descricion</th>
        <th>Prezo</th>

        <th></th>
      </tr>
    </thead>
    <tbody id="rexistro">
      <%= for rexistro <- @rexistro_collection do %>
        <tr id={"rexistro-#{rexistro.id}"}>
          <td><%= rexistro.titulo %></td>
          <td><%= rexistro.descricion %></td>
          <td><%= rexistro.prezo %></td>

          <td>
            <span><%= live_patch "Edit", to: Routes.rexistro_index_path(@socket, :edit, rexistro) %></span>
            <span><%= link "Delete", to: "#", phx_click: "delete-rexistro", phx_value_id: rexistro.id, data: [confirm: "Are you sure?"] %></span>
          </td>
        </tr>
      <% end %>
    </tbody>
    </table>

    <span><%= live_patch "New Rexistro", to: Routes.rexistro_index_path(@socket, :new) %></span>
    </div>
    """
  end
end
