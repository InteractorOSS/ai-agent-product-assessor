defmodule AiAgentProjectAssessorWeb.AuthController do
  @moduledoc """
  Handles OAuth authentication with Interactor.

  Manages the OAuth 2.0 authorization code flow:
  1. Redirects user to Interactor authorization endpoint
  2. Receives callback with authorization code
  3. Exchanges code for access token
  4. Creates/updates local user record
  5. Establishes user session
  """

  use AiAgentProjectAssessorWeb, :controller

  alias AiAgentProjectAssessor.Accounts
  alias AiAgentProjectAssessor.InteractorClient.Auth
  alias AiAgentProjectAssessorWeb.Plugs.Auth, as: AuthPlug

  require Logger

  @doc """
  Initiates OAuth flow by redirecting to Interactor authorization endpoint.
  """
  def login(conn, _params) do
    config = get_oauth_config()
    state = generate_state()

    # Store state in session for verification
    conn = put_session(conn, :oauth_state, state)

    authorize_url =
      "#{config.auth_url}/oauth/authorize?" <>
        URI.encode_query(%{
          client_id: config.client_id,
          redirect_uri: config.redirect_uri,
          response_type: "code",
          scope: "openid profile email",
          state: state
        })

    redirect(conn, external: authorize_url)
  end

  @doc """
  Handles OAuth callback from Interactor.
  """
  def callback(conn, %{"code" => code, "state" => state}) do
    stored_state = get_session(conn, :oauth_state)

    if state != stored_state do
      Logger.warning("OAuth state mismatch")

      conn
      |> put_flash(:error, "Authentication failed. Please try again.")
      |> redirect(to: "/login")
    else
      conn = delete_session(conn, :oauth_state)
      handle_authorization_code(conn, code)
    end
  end

  def callback(conn, %{"error" => error, "error_description" => description}) do
    Logger.warning("OAuth error: #{error} - #{description}")

    conn
    |> put_flash(:error, "Authentication failed: #{description}")
    |> redirect(to: "/login")
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Invalid callback parameters")
    |> redirect(to: "/login")
  end

  @doc """
  Logs out the user.
  """
  def logout(conn, _params) do
    conn
    |> AuthPlug.log_out_user()
    |> put_flash(:info, "Logged out successfully")
    |> redirect(to: "/")
  end

  @doc """
  Development-only login via email.
  Creates or finds user by email and establishes session.
  """
  def dev_login(conn, %{"email" => email}) do
    if Application.get_env(:ai_agent_project_assessor, :dev_routes, false) do
      case get_or_create_dev_user(email) do
        {:ok, user} ->
          conn
          |> AuthPlug.log_in_user(user)
          |> put_flash(:info, "Welcome, #{user.name || user.email}!")
          |> redirect(to: "/dashboard")

        {:error, reason} ->
          Logger.error("Dev login failed: #{inspect(reason)}")

          conn
          |> put_flash(:error, "Login failed")
          |> redirect(to: "/login")
      end
    else
      conn
      |> put_flash(:error, "Development login is not enabled")
      |> redirect(to: "/login")
    end
  end

  defp get_or_create_dev_user(email) do
    case Accounts.get_user_by_email(email) do
      nil ->
        Accounts.create_user(%{
          interactor_id: "dev:#{email}",
          email: email,
          name: email |> String.split("@") |> hd()
        })

      user ->
        {:ok, user}
    end
  end

  # Private functions

  defp handle_authorization_code(conn, code) do
    config = get_oauth_config()

    case exchange_code_for_token(code, config) do
      {:ok, token_data} ->
        handle_token(conn, token_data, config)

      {:error, reason} ->
        Logger.error("Token exchange failed: #{inspect(reason)}")

        conn
        |> put_flash(:error, "Authentication failed. Please try again.")
        |> redirect(to: "/login")
    end
  end

  defp exchange_code_for_token(code, config) do
    url = "#{config.auth_url}/oauth/token"

    body = [
      grant_type: "authorization_code",
      client_id: config.client_id,
      client_secret: config.client_secret,
      code: code,
      redirect_uri: config.redirect_uri
    ]

    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]

    case Req.post(url, form: body, headers: headers) do
      {:ok, %Req.Response{status: 200, body: response}} ->
        {:ok, response}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:error, {:token_error, status, body}}

      {:error, reason} ->
        {:error, {:request_failed, reason}}
    end
  end

  defp handle_token(conn, token_data, config) do
    # Verify the ID token if present
    id_token = token_data["id_token"]
    access_token = token_data["access_token"]

    user_info =
      if id_token do
        case Auth.verify_token(id_token, config) do
          {:ok, claims} -> Auth.extract_user_info(claims)
          {:error, _} -> fetch_user_info(access_token, config)
        end
      else
        fetch_user_info(access_token, config)
      end

    case create_or_update_user(user_info) do
      {:ok, user} ->
        conn
        |> AuthPlug.log_in_user(user)
        |> put_flash(:info, "Welcome, #{user.name || user.email}!")
        |> redirect(to: "/")

      {:error, reason} ->
        Logger.error("User creation failed: #{inspect(reason)}")

        conn
        |> put_flash(:error, "Failed to create user account")
        |> redirect(to: "/login")
    end
  end

  defp fetch_user_info(access_token, config) do
    url = "#{config.auth_url}/oauth/userinfo"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    case Req.get(url, headers: headers) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        %{
          interactor_id: body["sub"],
          email: body["email"],
          name: body["name"]
        }

      _ ->
        %{interactor_id: nil, email: nil, name: nil}
    end
  end

  defp create_or_update_user(user_info) do
    if user_info.interactor_id do
      Accounts.get_or_create_user(user_info)
    else
      {:error, :missing_interactor_id}
    end
  end

  defp get_oauth_config do
    app_config =
      Application.get_env(
        :ai_agent_project_assessor,
        AiAgentProjectAssessor.InteractorClient,
        []
      )

    %{
      client_id: Keyword.get(app_config, :client_id),
      client_secret: Keyword.get(app_config, :client_secret),
      auth_url: Keyword.get(app_config, :auth_url, "https://auth.interactor.com"),
      redirect_uri: get_redirect_uri()
    }
  end

  defp get_redirect_uri do
    endpoint_config =
      Application.get_env(:ai_agent_project_assessor, AiAgentProjectAssessorWeb.Endpoint)

    host = get_in(endpoint_config, [:url, :host]) || "localhost"
    port = get_in(endpoint_config, [:http, :port]) || 4000
    scheme = get_in(endpoint_config, [:url, :scheme]) || "http"

    "#{scheme}://#{host}:#{port}/auth/interactor/callback"
  end

  defp generate_state do
    :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)
  end
end
