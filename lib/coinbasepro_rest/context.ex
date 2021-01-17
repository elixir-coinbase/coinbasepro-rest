defmodule Coinbase.Pro.REST.Context do
  @moduledoc """
  This module is currently responsible for storing authentication
  information used to issue requests.
  """

  @type t :: %__MODULE__{
          key: String.t(),
          secret: String.t(),
          passphrase: String.t()
        }

  defstruct key: nil, secret: nil, passphrase: nil
end
