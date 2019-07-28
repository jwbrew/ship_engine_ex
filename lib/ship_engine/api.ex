defmodule ShipEngine.API do
  defmacro __using__(opts) do
    quote do
      if :create in unquote(opts) do
        @doc """
        Create a(n) #{__MODULE__ |> to_string |> String.split(".") |> List.last()}
        """
        def create(data, opts \\ []) do
          ShipEngine.request(:post, unquote(opts[:endpoint]), data, opts)
        end
      end

      if :get in unquote(opts) do
        @doc """
        Retrive a(n) #{__MODULE__ |> to_string |> String.split(".") |> List.last()} by its ID
        """
        def get(id, opts \\ []) when is_bitstring(id) do
          resource_url = Path.join(unquote(opts[:endpoint]), id)
          ShipEngine.request(:get, resource_url, [], opts)
        end
      end

      if :update in unquote(opts) do
        @doc """
        Update a(n) #{__MODULE__ |> to_string |> String.split(".") |> List.last()}
        """
        def update(id, data, opts \\ []) when is_bitstring(id) do
          resource_url = Path.join(unquote(opts[:endpoint]), id)
          ShipEngine.request(:post, resource_url, data, opts)
        end
      end

      if :list in unquote(opts) do
        @doc """
        List all #{__MODULE__ |> to_string |> String.split(".") |> List.last()}s
        """
        def list(pagination_opts \\ [], opts \\ []) when is_list(pagination_opts) do
          ShipEngine.request(:get, unquote(opts[:endpoint]), pagination_opts, opts)
        end
      end

      if :delete in unquote(opts) do
        @doc """
        Delete a(n) #{__MODULE__ |> to_string |> String.split(".") |> List.last()}
        """
        def delete(id, data \\ [], opts \\ []) when is_bitstring(id) do
          resource_url = Path.join(unquote(opts[:endpoint]), id)
          ShipEngine.request(:delete, resource_url, data, opts)
        end
      end
    end
  end
end
