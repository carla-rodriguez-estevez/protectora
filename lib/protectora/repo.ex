defmodule Protectora.Repo do
  use Ecto.Repo,
    otp_app: :protectora,
    adapter: Ecto.Adapters.Postgres
end
