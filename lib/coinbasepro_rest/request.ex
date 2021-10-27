defmodule Coinbase.Pro.REST.Request do
  @moduledoc """
  Module responsible for wrapping logic of the HTTP requests
  issues to the Coinbase Pro API.

  ## Example

  ```elixir
  alias Coinbase.Pro.REST.{Context,Request}
  # Obtain these values from Coinbase
  context = %Context{key: "...", secret: "...", passphrase: "..."}
  {:ok, response} = Request.get(context, "/orders?limit=10")
  ```
  """

  alias Coinbase.Pro.REST.{Context, Response, Signature}

  @doc """
  Issues a signed GET request to the Coinbase Pro REST API.

  On success it returns `{:ok, response}` where response is
  a `Response` struct.

  On error it returns either `{:error, {:http, reason}}` when
  underlying HTTP call has failed or `{:error, {:code, code, body}}`
  when the HTTP call suceeded but it returned unexpected status
  code.
  """
  @spec get(Context.t(), Tesla.Env.url(), [Tesla.option()]) ::
          {:ok, Response.t()}
          | {:error, {:http, any}}
          | {:error, {:code, pos_integer, any}}
  def get(context, path, opts \\ []) do
    client(context)
    |> Tesla.get(path, opts)
    |> make_response()
  end

  @doc """
  Works similarly to `get/3` but issues multiple requests
  to handle pagination and fetch the whole collection.
  """
  @spec get_all(Context.t(), Tesla.Env.url(), [Tesla.option()]) ::
          {:ok, Response.t()}
          | {:error, {:http, any}}
          | {:error, {:code, pos_integer, any}}
  def get_all(context, path, opts \\ []) do
    do_get_all(context, path, opts, nil, [])
  end

  defp do_get_all(context, path, opts, pagination_after, acc) do
    case get(context, overwrite_query(path, "after", pagination_after), opts) do
      {:ok, %Response{body: body, after: nil} = response} ->
        {:ok, %Response{response | body: acc ++ body}}

      {:ok, %Response{body: body, after: pagination_after}} ->
        do_get_all(context, path, opts, pagination_after, acc ++ body)

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp overwrite_query(path, param, value) do
    uri = URI.parse(path)

    new_query =
      case uri.query do
        nil ->
          case value do
            nil ->
              path

            value ->
              %{param => value}
              |> URI.encode_query()
          end

        query ->
          case value do
            nil ->
              query
              |> URI.decode_query()
              |> Map.delete(param)
              |> URI.encode_query()

            value ->
              query
              |> URI.decode_query()
              |> Map.put(param, value)
              |> URI.encode_query()
          end
      end

    uri
    |> Map.put(:query, new_query)
    |> URI.to_string()
  end

  @doc """
  Issues a signed POST request to the Coinbase Pro REST API.

  On success it returns `{:ok, response}` where response is
  a `Response` struct.

  On error it returns either `{:error, {:http, reason}}` when
  underlying HTTP call has failed or `{:error, {:code, code, body}}`
  when the HTTP call suceeded but it returned unexpected status
  code.
  """
  @spec post(Context.t(), Tesla.Env.url(), [Tesla.option()]) ::
          {:ok, Response.t()}
          | {:error, {:http, any}}
          | {:error, {:code, pos_integer, any}}
  def post(context, path, body, opts \\ []) do
    client(context)
    |> Tesla.post(path, body, opts)
    |> make_response()
  end

  @spec post(Context.t(), Tesla.Env.url(), [Tesla.option()]) ::
    {:ok, Response.t()}
    | {:error, {:http, any}}
    | {:error, {:code, pos_integer, any}}
  def delete(context, path, body, opts \\ []) do
  client(context)
  |> Tesla.delete(path, body, opts)
  |> make_response()
  end

  defp make_response(response) do
    case response do
      {:ok, %Tesla.Env{status: 200, body: body, headers: headers}} ->
        pagination_after =
          case headers |> List.keyfind("cb-after", 0) do
            {"cb-after", value} ->
              value

            nil ->
              nil
          end

        pagination_before =
          case headers |> List.keyfind("cb-before", 0) do
            {"cb-before", value} ->
              value

            nil ->
              nil
          end

        {:ok, %Response{body: body, after: pagination_after, before: pagination_before}}

      {:ok, %Tesla.Env{status: status, body: body}} ->
        {:error, {:code, status, body}}

      {:error, reason} ->
        {:error, {:http, reason}}
    end
  end

  defp client(context) do
    Tesla.client([
      {Tesla.Middleware.BaseUrl,
       Application.get_env(:coinbasepro_rest, :base_url, "https://api.pro.coinbase.com")},
      {Tesla.Middleware.Headers,
       [
         {"user-agent",
          Application.get_env(:coinbasepro_rest, :user_agent, default_user_agent!())}
       ]},
      Tesla.Middleware.JSON,
      {Signature, context}
    ])
  end

  defp default_user_agent! do
    lib_version =
      case :application.get_key(:coinbasepro_rest, :vsn) do
        {:ok, vsn} ->
          List.to_string(vsn)

        :undefined ->
          "dev"
      end

    "coinbasepro #{lib_version} (Elixir #{System.version()})"
  end
end
