defmodule ProtectoraWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :protectora,
    module: ProtectoraWeb.Auth.Guardian,
    error_handler: ProtectoraWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
