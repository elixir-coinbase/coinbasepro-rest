defmodule Coinbase.Pro.REST do
  @moduledoc """
  This package implements a low-level REST API of the
  [Coinbase Pro](https://docs.pro.coinbase.com/).
  Low-level means it is just a wrapper over HTTP library which handles
  authentication, request signing and has a few nice helper functions
  but you still have to construct URLs and interpret responses on
  your own.

  If you want to use a high-level API, see
  [elixir-coinbase/coinbasepro](https://github.com/elixir-coinbase/coinbasepro).

  ## Installation

  If [available in Hex](https://hex.pm/docs/publish), the package can be installed
  by adding `coinbasepro_rest` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:coinbasepro_rest, "~> 1.0"}
    ]
  end
  ```

  ## Additional dependencies

  As it uses [Tesla](https://github.com/teamon/tesla) underneath, you
  have to follow its installation instructions. Specifically, you have to
  install JSON library and you probably should install a HTTP client library
  as default HTTP client based on `httpc` does not validate SSL certificates.

  For example, add Jason and Hackney to the dependencies in `mix.exs`:

  ```elixir
  defp deps do
    [
      {:coinbasepro_rest, "~> 1.0"},
      {:hackney, "~> 1.16.0"},
      {:jason, ">= 1.0.0"}
    ]
  end
  ```

  Configure default adapter in `config/config.exs` (optional).

  ```elixir
  config :tesla, adapter: Tesla.Adapter.Hackney
  ```

  See [Tesla](https://github.com/teamon/tesla)'s README for list of
  supported HTTP and JSON libraries.

  ## Configuration

  ### Base URL

  By default, the API sends requests to the production API. If you want to
  use Sandbox, you can add the following to the `config/config.exs`:

  ```elixir
  config :coinbasepro_rest, :base_url, "https://api-public.sandbox.pro.coinbase.com"
  ```

  ### User Agent

  It is a good idea to override the default value of the User-Agent header added
  to the requests to something that clearly identifies your application name and
  version. If you want to do this, you can add the following to the `config/config.exs`:

  ```elixir
  config :coinbasepro_rest, :user_agent, "MyApp/1.0.0"
  ```

  ## Usage

  In order to issue GET request
  ```elixir
  alias Coinbase.Pro.REST.{Context,Request}
  # Obtain these values from Coinbase
  context = %Context{key: "...", secret: "...", passphrase: "..."}
  {:ok, response} = Request.get(context, "/orders?limit=10")
  ```

  ## Documentation

  The docs can be found at
  [https://hexdocs.pm/coinbasepro_rest](https://hexdocs.pm/coinbasepro_rest).


  ## License

  MIT

  ## Authors

  Marcin Lewandowski
  """
end
