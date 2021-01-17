defmodule Coinbase.Pro.REST.MixProject do
  use Mix.Project

  def project do
    [
      app: :coinbasepro_rest,
      version: "1.0.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,

      description: description(),
      deps: deps(),
      package: package(),
      source_url: "https://github.com/elixir-coinbase/coinbasepro_rest",
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
    ]
  end

  defp description do
    "Low-level implementation of the Coinbase Pro REST API."
  end

  defp package do
    [
      maintainers: ["Marcin Lewandowski"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/elixir-coinbase/coinbasepro_rest"}
    ]
  end
end
