defmodule Coinbase.Pro.REST.Response do
  @moduledoc """
  Module responsible for wrapping responses from the API.
  """
  @type t :: %__MODULE__{
          body: map() | list(map()),
          after: String.t() | nil,
          before: String.t() | nil
        }

  defstruct body: nil, after: nil, before: nil
end
