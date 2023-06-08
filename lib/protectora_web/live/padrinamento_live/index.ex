defmodule ProtectoraWeb.PadrinamentoLive.Index do
  use ProtectoraWeb, :live_view

  alias Protectora.Padrinamentos
  alias Protectora.Padrinamentos.Padrinamento

  require Logger

  @impl true
  def mount(params, session, socket) do
    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } =
      if connected?(socket) do
        Padrinamentos.list_padrinamento_paginated(params)
      else
        %Scrivener.Page{}
      end

    assigns = [
      conn: socket,
      padrinamento_collection: entries,
      page_number: page_number || 0,
      page_size: page_size || 0,
      total_entries: total_entries || 0,
      total_pages: total_pages || 0,
      padrinamento: %Padrinamento{},
      live_action: :index,
      page_title: "Padriñamentos",
      user_token: Map.get(session, "user_token")
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(%{"padrinamentos" => page}, _url, socket) do
    assigns = get_and_assign_page(page, socket.assigns.live_action)

    {:noreply,
     apply_action(socket, socket.assigns.live_action, %{"page" => socket.assigns.page_number})}

    {:noreply, assign(socket, assigns)}
  end

  def handle_params(%{"id" => id} = params, _url, socket) do
    assigns = get_and_assign_page(0, socket.assigns.live_action)

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_params(params, _url, socket) do
    assigns = get_and_assign_page(0, socket.assigns.live_action)

    {:noreply,
     apply_action(assign(socket, assigns), socket.assigns.live_action, %{
       "padrinamentos" => socket.assigns.page_number
     })}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar padriñamento")
    |> assign(:live_action, :edit)
    |> assign(:page_number, socket.assigns.page_number)
    |> assign(:padrinamento, Padrinamentos.get_padrinamento!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Novo padriñamento")
    |> assign(:live_action, :new)
    |> assign(:padrinamento, %Padrinamento{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Padriñamentos")
    |> assign(:padrinamento, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    padrinamento = Padrinamentos.get_padrinamento!(id)
    {:ok, _} = Padrinamentos.delete_padrinamento(padrinamento)

    {:noreply,
     assign(socket, get_and_assign_page(socket.assigns.page_number, socket.assigns.live_action))}
  end

  def handle_event("nav", %{"page" => page}, socket) do
    {:noreply,
     push_redirect(assign(socket, get_and_assign_page(page, socket.assigns.live_action)),
       to: "/padrinamento?padrinamentos=" <> page
     )}
  end

  defp list_padrinamento do
    Padrinamentos.list_padrinamento()
  end

  def get_and_assign_page(page_number, live_action) do
    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Padrinamentos.list_padrinamento_paginated(page: page_number)

    [
      padrinamento_collection: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      live_action: live_action,
      total_pages: total_pages
    ]
  end
end
