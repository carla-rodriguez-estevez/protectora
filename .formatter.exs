# project_root/.formatter.exs

[
  import_deps: [:ecto, :phoenix, :surface],
  inputs: [
    "mix.exs",
    "*.{ex,exs}",
    "priv/*/seeds.exs",
    "{config,lib,test}/**/*.{ex,exs}",
    "{lib,test}/**/*.sface"
  ],
  subdirectories: ["priv/*/migrations"],
  plugins: [Surface.Formatter.Plugin]
]
