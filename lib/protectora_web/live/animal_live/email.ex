defmodule ProtectoraWeb.AnimalLive.Email do
  use ProtectoraWeb, :live_component
  import Swoosh.Email
  alias Protectora.Animais.AdoptionEmail

  alias Protectora.Mailer
  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div  class="w-full " >
    <h3 class="flex justify-center items-center  text-xl font-extrabold underline underline-offset-3 decoration-8 decoration-blue-400 ">Enviar petición de adopción</h3>

    <.form  class="flex flex-col mt-4 gap-4 max-w-5xl " let={f} for={@user} phx-target={@myself} phx-submit="send-email" id="email-form">

    <%= label f, :nome, "Indique o seu nome", class: "font-extrabold" %>
    <%= text_input f, :nome %>
    <%= error_tag f, :nome %>

    <%= label f, :telefono, "Indique o seu teléfono de contacto", class: "font-extrabold" %>
    <%= number_input f, :telefono, class: "font-extrabold"%>
    <%= error_tag f, :telefono %>

    <%= label f, :email, "Indique o seu email", class: "font-extrabold" %>
    <%= text_input f, :email %>
    <%= error_tag f, :email %>

    <%= label f, :nota, "Indique neste espazo a información a maiores ou os detalles que vexa precisos ó persoal da protectora", class: "font-extrabold" %>
    <%= textarea f, :nota, style: "height: 180px"  %>
    <%= error_tag f, :nota %>

    <div class="inline-flex text-white mb-4 bg-teal-500 border-0 py-2 px-6 focus:outline-none hover:bg-teal-600 rounded text-lg max-w-fit">
    <%= submit "Enviar petición" %>
    </div>
    </.form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     assign(socket,
       user: Protectora.Animais.AdoptionEmail.changeset(%AdoptionEmail{}),
       animal: assigns.animal,
       return_to: assigns.return_to
     )}
  end

  @impl true
  def handle_event("send-email", %{"adoption_email" => user}, socket) do
    case Protectora.Animais.AdoptionEmail.changeset(%AdoptionEmail{}, user) do
      %Ecto.Changeset{action: nil, changes: _, errors: [], data: _, valid?: true} ->
        deliver_adoption_request(user, socket.assigns.animal)

        {:noreply,
         socket
         |> put_flash(:info, "Petición de adopción enviada")
         |> push_redirect(to: socket.assigns.return_to)}

      changeset ->
        {:noreply, assign(socket, user: %{changeset | action: :insert})}
    end
  end

  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Protectora", "protectoratfg@gmail.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  def deliver_adoption_request(
        %{
          "email" => email,
          "nome" => nome,
          "nota" => nota,
          "telefono" => telefono
        },
        animal
      ) do
    return =
      deliver("protectoratfg@gmail.com", "Ten unha nova adopción esperando", """

      ==============================

      Ten unha petición de adopción de:

      Nome: #{nome}
      Email de contacto: #{email}
      Teléfono: #{telefono}

      O nome do animal polo que se pregunta é:
      #{animal.nome}
      https://protectoratfg.gigalixirapp.com/animal/#{animal.id}


      O solicitante quere facer saber o seguinte: #{nota}

      ==============================

      Póñase en contacto con esta persoa cando poda ou comuníquese a outro voluntario.

      Por favor non responda a esta mensaxe, de precisar algunha axuda contacte coa organización.

      ==============================
      """)

    return
  end
end
