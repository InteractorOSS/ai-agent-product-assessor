defmodule AiAgentProjectAssessorWeb.Plugs.Auth do
  @moduledoc """
  Authentication plug for web requests.

  Handles user session management and authentication verification.
  Integrates with Interactor Auth for OAuth-based authentication.
  """

  import Plug.Conn
  import Phoenix.Controller

  alias AiAgentProjectAssessor.Accounts

  @doc """
  Fetches the current user from session and assigns to conn.
  """
  def fetch_current_user(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Accounts.get_user(user_id)
    assign(conn, :current_user, user)
  end

  @doc """
  Requires the user to be authenticated.
  Redirects to login if not authenticated.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  @doc """
  Redirects if user is already authenticated.
  Used for login pages.
  """
  def redirect_if_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: "/dashboard")
      |> halt()
    else
      conn
    end
  end

  @doc """
  Logs in a user by setting the session.
  """
  def log_in_user(conn, user) do
    conn
    |> renew_session()
    |> put_session(:user_id, user.id)
    |> assign(:current_user, user)
  end

  @doc """
  Logs out a user by clearing the session.
  """
  def log_out_user(conn) do
    conn
    |> renew_session()
    |> delete_session(:user_id)
    |> assign(:current_user, nil)
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end
end
