defmodule ProtectoraWeb.Auth.SetAccount do
  import Plug.Conn
  alias ProtectoraWeb.Auth.ErrorResponse
  alias Protectora.Voluntarios

  def init(_options) do
  end

  def call(conn, _options) do
    if conn.assigns[:account] do
      conn
    else
      account_id = get_session(conn, :account_id)

      case account_id do
        nil ->
          raise ErrorResponse.Unauthorized

        _ ->
          account = Voluntarios.get_voluntario!(account_id)

          cond do
            account_id && account -> assign(conn, :voluntario, account)
            true -> assign(conn, :voluntario, account)
          end
      end
    end
  end
end
