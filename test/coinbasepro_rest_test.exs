defmodule CoinbaseproRestTest do
  use ExUnit.Case
  doctest CoinbaseproRest

  test "greets the world" do
    assert CoinbaseproRest.hello() == :world
  end
end
