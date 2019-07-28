defmodule ShipEngine do
  @default_api_endpoint "https://api.shipengine.com/v1/"

  alias ShipEngine.{
    APIConnectionError,
    APIError,
    AuthenticationError,
    InvalidRequestError,
    RateLimitError
  }

  @missing_api_key_error_message """
    The api_key settings is required to use ShipEngine. Please include your
    ShipEngine api key in your application config file like so:
      config :ship_engine, api_key: YOUR_API_KEY
    Alternatively, you can also set the secret key as an environment variable:
      SHIP_ENGINE_API_KEY=YOUR_API_KEY
  """

  defp get_api_key do
    System.get_env("SHIP_ENGINE_API_KEY") ||
      Application.get_env(:ship_engine, :api_key) ||
      raise AuthenticationError, message: @missing_api_key_error_message
  end

  defp get_api_endpoint do
    System.get_env("SHIP_ENGINE_API_ENDPOINT") ||
      Application.get_env(:ship_engine, :api_endpoint) ||
      @default_api_endpoint
  end

  defp request_body(nil), do: ""
  defp request_body(data), do: Jason.encode!(data)

  defp request_url(endpoint) do
    Path.join(get_api_endpoint(), endpoint)
  end

  defp create_headers() do
    [
      {"api-key", get_api_key()},
      {"accept", "application/json"},
      {"content-type", "application/json"}
    ]
  end

  def request(action, endpoint, data, _opts) when action in [:get, :post, :put, :delete] do
    HTTPoison.request(action, request_url(endpoint), request_body(data), create_headers())
    |> handle_response
  end

  defp handle_response({:ok, %{body: body, status_code: 200}}) do
    {:ok, process_response_body(body)}
  end

  defp handle_response({:ok, %{body: body, status_code: code}}) do
    message =
      body
      |> process_response_body
      |> Map.fetch!("error")
      |> Map.fetch!("message")

    error_struct =
      case code do
        code when code in [400, 404] ->
          %InvalidRequestError{message: message}

        401 ->
          %AuthenticationError{message: message}

        429 ->
          %RateLimitError{message: message}

        _ ->
          %APIError{message: message}
      end

    {:error, error_struct}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    %APIConnectionError{message: "Network Error: #{reason}"}
  end

  defp process_response_body(body) do
    Jason.decode!(body)
  end
end
