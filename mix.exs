defmodule Coinbase.Pro.REST.MixProject do
  use Mix.Project

  def project do
    [
      app: :coinbasepro_rest,
      version: "1.0.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.4"}
    ]
  end
end
