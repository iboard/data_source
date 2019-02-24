defmodule DataSource.MixProject do
  use Mix.Project

  def project do
    [
      app: :data_source,
      version: "0.1.3",
      elixir: "~> 1.7",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: [
        main: "readme",
        logo: "assets/data_source.png",
        extras: ["README.md", "CHANGELOG.md", "LICENSE.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DataSource.Application, []}
    ]
  end

  def description,
    do: ~S"""
    DataSource provides an infinite stream of data and DataStage provides a GenStage-producer you can subscribe to in order to fetch data/events from the given source.
    """

  def package() do
    [
      name: "data_source",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["andreas@altendorfer.at"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/iboard/data_source",
        "Documentation" => "https://hexdocs.pm/data_source/readme.html"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19.0", only: :dev},
      {:gen_stage, ">= 0.0.0"}
    ]
  end
end
