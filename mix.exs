defmodule Langchain.MixProject do
  use Mix.Project

  def project do
    [
      app: :langchain,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Langchain.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  def deps do
    [
      {:dotenvy, "~> 0.8.0"},
      {:langchain, "~> 0.1.0"}
    ]
  end

  # defp releases do
  #   [
  #     langchain: [
  #       include_executables_for: [:unix],
  #       steps: [:assemble, :tar],
  #       overlays: ["envs/", "priv/", "config/"]
  #     ]
  #   ]
  # end
end
