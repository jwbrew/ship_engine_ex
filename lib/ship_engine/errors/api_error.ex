defmodule ShipEngine.APIError do
  @moduledoc """
  API errors cover any other type of problem (e.g., a temporary problem with
  ShipEngine's servers) and are extremely uncommon.
  """
  defexception type: "api_error", message: nil
end
