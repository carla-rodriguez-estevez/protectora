defmodule ProtectoraWeb.UserSessionController do
  use ProtectoraWeb, :controller

  alias Protectora.Accounts
  alias ProtectoraWeb.UserAuth
  require Logger

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    user = Accounts.get_user_by_email_and_password(email, password)

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Contrasinal ou email incorrecto")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Sesión pechada correctamente")
    |> UserAuth.log_out_user()
  end
end
