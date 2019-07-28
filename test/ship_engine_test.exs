defmodule ShipEngineTest do
  use ExUnit.Case
  doctest ShipEngine

  test "greets the world" do
    assert ShipEngine.hello() == :world
  end
end
