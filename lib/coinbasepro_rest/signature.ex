defmodule Coinbase.Pro.REST.Signature do
  @moduledoc false

  @behaviour Tesla.Middleware

  @impl Tesla.Middleware
  def call(env, next, context) do
    env
    |> merge(context)
    |> Tesla.run(next)
  end

  defp merge(env, context) do
    uri = URI.parse(env.url)

    path =
      case uri.query do
        nil ->
          uri.path

        query ->
          "#{uri.path}?#{query}"
      end

    method =
      env.method
      |> to_string()
      |> String.upcase()

    signature_headers = generate_headers!(context, method, path, env.body)

    Map.update!(env, :headers, &(&1 ++ signature_headers))
  end

  defp generate_headers!(context, method, path, body) do
    timestamp =
      DateTime.now!("Etc/UTC")
      |> DateTime.to_unix()

    what = "#{timestamp}#{method}#{path}#{body}"
    signature = :crypto.hmac(:sha256, Base.decode64!(context.secret), what) |> Base.encode64()

    [
      {"CB-ACCESS-KEY", context.key},
      {"CB-ACCESS-SIGN", signature},
      {"CB-ACCESS-TIMESTAMP", to_string(timestamp)},
      {"CB-ACCESS-PASSPHRASE", context.passphrase}
    ]
  end
end
