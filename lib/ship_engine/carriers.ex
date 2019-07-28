defmodule ShipEngine.Carriers do
  use ShipEngine.API, [:get, :update, :create, :list, :delete, endpoint: "carriers"]
end
