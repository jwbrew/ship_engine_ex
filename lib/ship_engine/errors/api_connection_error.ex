defmodule ShipEngine.APIConnectionError do
  @moduledoc """
  Failure to connect to ShipEngine's API.
  """
  defexception type: "api_connection_error", message: nil
end
