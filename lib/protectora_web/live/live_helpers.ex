defmodule ProtectoraWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a datetime using the browser based toLocaleString methods.
  You must include the datetime you want to use as value can optionally provide format
  - datetime (the full datetime)
  - date (just the date)
  - timeshort (just the time without seconds)
  - time (just the time with seconds)
  ## Examples
  <.datetime value="2022-04-14T22:00:00Z" format="datetime" />
  14/4/2022 22:00
  <.datetime value="2022-04-14T22:00:00Z" format="timeshort" />
  22:00
  """
  def datetime(%{value: datetime} = assigns) do
    format = Map.get(assigns, :format, "datetime")

    locale_fn =
      case format do
        "datetime" -> "toLocaleString([],{dateStyle: 'short', timeStyle: 'short'})"
        "date" -> "toLocaleDateString()"
        "timeshort" -> "toLocaleTimeString([],{timeStyle: 'short'})"
        "time" -> "toLocaleTimeString()"
        _ -> "toLocaleString()"
      end

    ~H"""
    <span class="datetime" id={assigns.id} phx-update="ignore" x-data={"{date: new Date('#{datetime}')}"} x-text={"date.#{locale_fn}"}>
    </span>
    """
  end

  def datetime(assigns) do
    ~H"""
    """
  end

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.voluntario_index_path(@socket, :index)}>
        <.live_component
          module={ProtectoraWeb.VoluntarioLive.FormComponent}
          id={@voluntario.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.voluntario_index_path(@socket, :index)}
          voluntario: @voluntario
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale max-w-6xl"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal()
          %>
        <% else %>
          <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>✖</a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end
