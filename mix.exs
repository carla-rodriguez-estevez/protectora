defmodule Protectora.MixProject do
  use Mix.Project

  def project do
    [
      app: :protectora,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers() ++ [:surface],
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Protectora.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"] ++ catalogues()
  defp elixirc_paths(:dev), do: ["lib"] ++ catalogues()
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.0-rc.0", override: true},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.6"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.6.3"},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:bcrypt_elixir, "~> 3.0"},
      {:timex, "~> 3.0"},
      # You can make use of it by running mix dialyzer
      {:dialyxir, "~> 1.0", only: [:dev], runtime: true},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      # styles library
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:surface, "~> 0.8.0"},
      {:surface_catalogue, "~> 0.5.0"},
      {:scrivener_ecto, "~> 2.0"},
      # authentication dependencies
      {:guardian, "~> 2.0"},
      {:guardian_db, "~> 2.0"},
      # mails
      {:gen_smtp, "~> 1.1.1"},
      {:hackney, "~> 1.18.0"},
      {:mail, ">= 0.0.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"],
      test: ["ecto.drop", "ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "test.ci": ["ecto.drop", "ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  def catalogues do
    [
      "priv/catalogue"
    ]
  end
end
