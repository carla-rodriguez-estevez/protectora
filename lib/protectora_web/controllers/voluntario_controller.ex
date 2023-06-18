defmodule ProtectoraWeb.VoluntarioController do
  use ProtectoraWeb, :controller

  alias Protectora.Voluntarios
  alias Protectora.Voluntarios.Voluntario
  alias ProtectoraWeb.{Auth.Guardian, Auth.ErrorResponse}

  action_fallback(ProtectoraWeb.FallbackController)

  plug(:is_authorized_account when action in [:update, :delete])

  defp is_authorized_account(conn, _opts) do
    if conn.assigns.voluntario.id do
      conn
    else
      raise ErrorResponse.Forbidden
    end
  end

  def index(conn, _params) do
    voluntario = Voluntarios.list_voluntario()
    render(conn, "index.json", voluntario: voluntario)
  end

  def create(conn, %{"voluntario" => voluntario_params}) do
    with {:ok, %Voluntario{} = voluntario} <- Voluntarios.create_voluntario(voluntario_params) do
      authorize_account(conn, voluntario.email, voluntario_params["contrasinal"])
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    authorize_account(conn, email, password)
  end

  defp authorize_account(conn, email, hash_password) do
    case Guardian.authenticate(email, hash_password) do
      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:created)
        |> render("voluntario_token.json", %{voluntario: account, token: token})

      {:error, :unauthorized} ->
        raise ErrorResponse.Unauthorized, message: "Email ou contrasinal incorrecta"

      {:error, :unauthored} ->
        raise ErrorResponse.Unauthorized, message: "Email ou contrasinal incorrecta"
    end
  end

  def show(conn, %{"id" => id}) do
    voluntario = Voluntarios.get_voluntario!(id)
    render(conn, "show.json", voluntario: voluntario)
  end

  def update(conn, %{"id" => id, "voluntario" => voluntario_params}) do
    voluntario = Voluntarios.get_voluntario!(id)

    with {:ok, %Voluntario{} = voluntario} <-
           Voluntarios.update_voluntario(voluntario, voluntario_params) do
      render(conn, "show.json", voluntario: voluntario)
    end
  end

  def delete(conn, %{"id" => id}) do
    voluntario = Voluntarios.get_voluntario!(id)

    with {:ok, %Voluntario{}} <- Voluntarios.delete_voluntario(voluntario) do
      send_resp(conn, :no_content, "")
    end
  end
end
