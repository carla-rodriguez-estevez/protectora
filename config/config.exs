# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :protectora,
  ecto_repos: [Protectora.Repo]

# Configures the endpoint
config :protectora, ProtectoraWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gu3sEtXclDRNVbhXyalez5owbxAgwCbAb6sPJAVMV4IimKnKMz6QXj8ICS0LubwQ",
  render_errors: [
    view: ProtectoraWeb.ErrorView,
    accepts: ~w(html json),
    layout: false
  ],
  pubsub_server: Protectora.PubSub,
  live_view: [signing_salt: "ePM3bvx8"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# # at the `config/runtime.exs`.
# config :protectora, Protectora.Mailer,
#   adapter: Swoosh.Adapters.Gmail,
#   access_token:
#     {:system,
#      "ya29.a0AWY7CkkUDAIlEdMUUYNhZ_4M-i1jnkP7nD5E44Gakc802Ti8aD_3UZ8X1PUa_Dg0qahgHWJdQsjRvRYg4re9WOQf_KxTU910UZmPtGM09FfT8gTHz1DdQG4CzND700mVQlhZJ89JJN3zjmDpGoR4BNFIicqRaCgYKAdQSARMSFQG1tDrp-CtppWcJpLufDADTicVrYA0163"}
config :protectora, Protectora.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: "smtp.gmail.com",
  port: 587,
  username: "protectoratfg@gmail.com",
  password: "wgnhbaqsjyylcvvm",
  tls: :always,
  ssl: false

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, Swoosh.ApiClient.Hackney

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ],
  catalogue: [
    args:
      ~w(../deps/surface_catalogue/assets/js/app.js --bundle --target=es2016 --minify --outdir=../priv/static/assets/catalogue),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind
config :tailwind,
  version: "3.3.1",
  default: [
    args: ~w(
    --config=tailwind.config.js
    --input=css/app.css
    --output=../priv/static/assets/app.css
  ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :protectora, ProtectoraWeb.Auth.Guardian,
  issuer: "protectora",
  secret_key: "69RZzj1zqLfOUNulDQILDR7yfBxFJIw1tQG8XKIPSIr12+D8SMQ9TdCpD8FVZTNg"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :guardian, Guardian.DB,
  repo: Protectora.Repo,
  schema_name: "guardian_tokens",
  sweep_interval: 60

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
