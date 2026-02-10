defmodule AiAgentProjectAssessor.InteractorClient.Auth do
  @moduledoc """
  Interactor Authentication module.

  Handles OAuth 2.0 client credentials flow for server-to-server
  communication with Interactor services.

  ## Token Flow

  1. Application exchanges client credentials for access token
  2. Token is cached and reused until near expiration
  3. Token is automatically refreshed when needed

  ## Configuration

  Requires the following environment variables:
  - `INTERACTOR_CLIENT_ID`: OAuth client ID
  - `INTERACTOR_CLIENT_SECRET`: OAuth client secret
  - `INTERACTOR_URL`: Auth server URL (default: https://auth.interactor.com)
  """

  require Logger

  @token_endpoint "/api/v1/oauth/token"
  @default_timeout 30_000

  @type token_response :: %{
          access_token: String.t(),
          token_type: String.t(),
          expires_in: integer(),
          expires_at: DateTime.t()
        }

  @doc """
  Fetches an access token using client credentials flow.

  ## Examples

      iex> Auth.fetch_token(%{client_id: "...", client_secret: "...", auth_url: "..."})
      {:ok, %{access_token: "...", expires_at: ~U[...]}}

      iex> Auth.fetch_token(%{client_id: "invalid", ...})
      {:error, :unauthorized}

  """
  @spec fetch_token(map()) :: {:ok, token_response()} | {:error, term()}
  def fetch_token(config) do
    try do
      url = build_token_url(config)
      body = build_token_body(config)
      headers = [{"Content-Type", "application/json"}]

      case Req.post(url, json: body, headers: headers, receive_timeout: @default_timeout) do
        {:ok, %Req.Response{status: 200, body: %{"data" => response_body}}} ->
          # Response wrapped in "data" key
          {:ok, parse_token_response(response_body)}

        {:ok, %Req.Response{status: 200, body: %{"access_token" => _} = response_body}} ->
          # Response directly contains token (no "data" wrapper)
          {:ok, parse_token_response(response_body)}

        {:ok, %Req.Response{status: 401}} ->
          Logger.error("Interactor auth failed: unauthorized")
          {:error, :unauthorized}

        {:ok, %Req.Response{status: status, body: body}} ->
          Logger.error("Interactor auth failed: status=#{status}, body=#{inspect(body)}")
          {:error, {:auth_failed, status, body}}

        {:error, reason} ->
          Logger.error("Interactor auth request failed: #{inspect(reason)}")
          {:error, {:request_failed, reason}}
      end
    rescue
      e ->
        Logger.warning("Interactor auth configuration error: #{inspect(e)}")
        {:error, :not_configured}
    end
  end

  @doc """
  Verifies a JWT token from Interactor.

  Uses Joken with JWKS for RS256 token verification.

  ## Examples

      iex> Auth.verify_token("eyJ...")
      {:ok, %{sub: "user-uuid", email: "user@example.com", ...}}

      iex> Auth.verify_token("invalid")
      {:error, :invalid_token}

  """
  @spec verify_token(String.t(), map()) :: {:ok, map()} | {:error, term()}
  def verify_token(token, config \\ %{}) do
    jwks_url = get_jwks_url(config)

    # Use JokenJwks to verify the token
    case verify_with_jwks(token, jwks_url) do
      {:ok, claims} ->
        {:ok, claims}

      {:error, reason} ->
        Logger.warning("Token verification failed: #{inspect(reason)}")
        {:error, :invalid_token}
    end
  end

  @doc """
  Extracts user info from a verified token.

  ## Examples

      iex> Auth.extract_user_info(%{"sub" => "123", "email" => "user@example.com"})
      %{interactor_id: "123", email: "user@example.com", name: nil}

  """
  @spec extract_user_info(map()) :: map()
  def extract_user_info(claims) do
    %{
      interactor_id: claims["sub"],
      email: claims["email"],
      name: claims["name"]
    }
  end

  # Private functions

  defp build_token_url(config) do
    auth_url = Map.get(config, :auth_url, "https://auth.interactor.com")
    "#{auth_url}#{@token_endpoint}"
  end

  defp build_token_body(config) do
    client_id = Map.get(config, :client_id)
    client_secret = Map.get(config, :client_secret)

    if is_nil(client_id) or is_nil(client_secret) do
      Logger.warning("Interactor credentials not configured (INTERACTOR_AUTH_CLIENT_ID/INTERACTOR_AUTH_CLIENT_SECRET)")
      raise "Missing Interactor credentials"
    end

    %{
      grant_type: "client_credentials",
      client_id: client_id,
      client_secret: client_secret
    }
  end

  defp parse_token_response(body) do
    expires_in = body["expires_in"] || 3600
    expires_at = DateTime.add(DateTime.utc_now(), expires_in, :second)

    %{
      access_token: body["access_token"],
      token_type: body["token_type"] || "Bearer",
      expires_in: expires_in,
      expires_at: expires_at
    }
  end

  defp get_jwks_url(config) do
    auth_url = Map.get(config, :auth_url, "https://auth.interactor.com")
    Map.get(config, :jwks_url, "#{auth_url}/oauth/jwks")
  end

  defp verify_with_jwks(token, jwks_url) do
    # Define a Joken signer that uses JWKS
    # This is a simplified implementation - in production you'd want
    # to cache the JWKS keys

    with {:ok, %Req.Response{status: 200, body: jwks}} <- Req.get(jwks_url),
         {:ok, claims} <- do_verify_token(token, jwks) do
      {:ok, claims}
    else
      {:ok, %Req.Response{status: status}} ->
        {:error, {:jwks_fetch_failed, status}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp do_verify_token(token, jwks) do
    # Parse the token header to get the key ID (kid)
    case Joken.peek_header(token) do
      {:ok, %{"kid" => kid, "alg" => "RS256"}} ->
        # Find the matching key in JWKS
        case find_key(jwks, kid) do
          {:ok, key} ->
            signer = Joken.Signer.create("RS256", key)
            Joken.verify(token, signer)

          :error ->
            {:error, :key_not_found}
        end

      {:ok, _} ->
        {:error, :unsupported_algorithm}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp find_key(%{"keys" => keys}, kid) do
    case Enum.find(keys, &(&1["kid"] == kid)) do
      nil -> :error
      key -> {:ok, key}
    end
  end

  defp find_key(_, _), do: :error
end
