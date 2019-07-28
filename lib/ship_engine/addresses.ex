defmodule ShipEngine.Addresses do
  use ShipEngine.API, [:get, :create, endpoint: "addresses"]

  def recognize(data, opts \\ []) do
    ShipEngine.request(:put, "addresses/recognize", data, opts)
  end

  def validate(data, opts \\ []) when is_list(data) do
    ShipEngine.request(:post, "addresses/validate", data, opts)
  end

  def validate(data, opts) do
    case validate([data], opts) do
      {:ok, [resp]} ->
        {:ok, resp}

      x ->
        x
    end
  end
end
