defmodule AiAgentProjectAssessorWeb.DashboardLiveTest do
  use AiAgentProjectAssessorWeb.LiveCase

  describe "Dashboard" do
    test "redirects if user is not logged in", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/login"}}} = live(conn, ~p"/dashboard")
    end

    test "renders dashboard with stats", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)

      # Create some assessments
      session_fixture(user, %{status: :gathering})
      session_fixture(user, %{status: :report_generated})
      session_fixture(user, %{status: :report_generated})

      {:ok, _view, html} = live(conn, ~p"/dashboard")

      assert html =~ "Welcome back"
      assert html =~ "Total Assessments"
      # Should show 3 total assessments
      assert html =~ "3"
    end

    test "shows empty state for new users", %{conn: conn} do
      {conn, _user} = register_and_log_in_user(conn)

      {:ok, _view, html} = live(conn, ~p"/dashboard")

      # Should show welcome and getting started info
      assert html =~ "Welcome"
      assert html =~ "Start Assessment" or html =~ "New Assessment"
    end

    test "shows recent assessments", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)

      session_fixture(user, %{name: "Recent Project 1"})
      session_fixture(user, %{name: "Recent Project 2"})

      {:ok, _view, html} = live(conn, ~p"/dashboard")

      assert html =~ "Recent Project 1" or html =~ "Recent Assessments"
    end

    test "quick action navigates to new assessment", %{conn: conn} do
      {conn, _user} = register_and_log_in_user(conn)

      {:ok, view, _html} = live(conn, ~p"/dashboard")

      # Navigate directly using the link href
      {:ok, _view, html} =
        view
        |> element("a[href='/assessments/new']", "Create Assessment")
        |> render_click()
        |> follow_redirect(conn, ~p"/assessments/new")

      assert html =~ "New Assessment"
    end
  end
end
