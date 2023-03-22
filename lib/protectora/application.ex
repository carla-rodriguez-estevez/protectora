defmodule Protectora.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Protectora.Repo,
      # Start the Telemetry supervisor
      ProtectoraWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Protectora.PubSub},
      # Start the Endpoint (http/https)
      ProtectoraWeb.Endpoint
      # Start a worker by calling: Protectora.Worker.start_link(arg)
      # {Protectora.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Protectora.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ProtectoraWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
