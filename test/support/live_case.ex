defmodule AiAgentProjectAssessorWeb.LiveCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require testing LiveViews.

  Provides helpers for authenticated LiveView testing.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint AiAgentProjectAssessorWeb.Endpoint

      use AiAgentProjectAssessorWeb, :verified_routes

      import Plug.Conn
      import Phoenix.ConnTest
      import Phoenix.LiveViewTest
      import AiAgentProjectAssessorWeb.LiveCase
      import AiAgentProjectAssessor.Fixtures
    end
  end

  setup tags do
    AiAgentProjectAssessor.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Logs in a user and returns the authenticated conn with current_user assigned.
  """
  def log_in_user(conn, user) do
    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_id, user.id)
    |> Plug.Conn.put_session(:live_socket_id, "users_sessions:#{user.id}")
    |> Plug.Conn.assign(:current_user, user)
  end

  @doc """
  Returns a tuple with {conn, user} where conn is authenticated.
  """
  def register_and_log_in_user(conn) do
    user = AiAgentProjectAssessor.Fixtures.user_fixture()
    {log_in_user(conn, user), user}
  end
end
