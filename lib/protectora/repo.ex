defmodule Protectora.Repo do
  use Ecto.Repo,
    otp_app: :protectora,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 8
end
