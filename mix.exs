defmodule Avito.MixProject do
  use Mix.Project

  def project do
    [
      app: :avito,
      version: "0.1.0",
      elixir: "~> 1.7-dev",
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [
        espec: :test,
        vcr: :test, "vcr.delete": :test, "vcr.check": :test, "vcr.show": :test
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpotion, :plug, :ibrowse],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.1.0"},
      {:espec, "~> 1.5.0"},
      {:httpotion, "~> 3.1.0"},
      {:meeseeks, "~> 0.7.7"},
      {:exvcr, "~> 0.10", only: :test},
      {:relax_yaml, "~> 0.1.4"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
