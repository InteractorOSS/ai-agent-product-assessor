defmodule AiAgentProjectAssessorWeb.LiveHelpers do
  @moduledoc """
  LiveView helper functions and hooks.

  Provides on_mount hooks for authentication and common assigns.

  ## Available hooks

  - `:fetch_current_user` - Fetches current user from session
  - `:require_authenticated_user` - Redirects to login if not authenticated
  - `:redirect_if_authenticated` - Redirects to home if already authenticated
  """

  import Phoenix.Component
  import Phoenix.LiveView

  alias AiAgentProjectAssessor.Accounts

  @doc """
  On mount hook implementations.

  - `:fetch_current_user` - Fetches current user from session
  - `:require_authenticated_user` - Redirects to login if not authenticated
  - `:redirect_if_authenticated` - Redirects to home if already authenticated
  """
  def on_mount(:fetch_current_user, _params, session, socket) do
    socket = fetch_current_user(socket, session)
    {:cont, socket}
  end

  def on_mount(:require_authenticated_user, _params, session, socket) do
    socket = fetch_current_user(socket, session)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      socket =
        socket
        |> put_flash(:error, "You must log in to access this page.")
        |> redirect(to: "/login")

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_authenticated, _params, session, socket) do
    socket = fetch_current_user(socket, session)

    if socket.assigns.current_user do
      {:halt, redirect(socket, to: "/")}
    else
      {:cont, socket}
    end
  end

  defp fetch_current_user(socket, session) do
    user_id = session["user_id"]
    user = user_id && Accounts.get_user(user_id)
    assign(socket, :current_user, user)
  end
end
