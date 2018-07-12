defmodule Avito.MixProject do
  use Mix.Project

  def project do
    [
      app: :importer,
      version: "0.0.1",
      elixir: "~> 1.6.6",
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [
        espec: :test,
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:espec, "~> 1.5.0"},
      {:fs, "~> 3.4.0"},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
