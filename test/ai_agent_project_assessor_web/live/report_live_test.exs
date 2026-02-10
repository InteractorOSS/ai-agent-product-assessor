defmodule AiAgentProjectAssessorWeb.ReportLiveTest do
  use AiAgentProjectAssessorWeb.LiveCase

  alias AiAgentProjectAssessor.Reports

  describe "Show" do
    test "redirects if user is not logged in", %{conn: conn} do
      user = user_fixture()
      session = session_fixture(user)
      report = report_fixture(session)

      assert {:error, {:redirect, %{to: "/login"}}} = live(conn, ~p"/reports/#{report.id}")
    end

    test "renders report with sections", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)
      session = session_fixture(user)
      report = report_fixture(session)

      {:ok, _view, html} = live(conn, ~p"/reports/#{report.id}")

      assert html =~ "Report Sections"
      assert html =~ "Executive Summary"
      assert html =~ "This is a test summary"
    end

    test "navigates between sections", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)
      session = session_fixture(user)
      report = report_fixture(session)

      {:ok, view, _html} = live(conn, ~p"/reports/#{report.id}")

      html =
        view
        |> element("button[phx-click=select_section][phx-value-section=problem_statement]")
        |> render_click()

      assert html =~ "Test problem statement"
    end

    test "toggles edit mode", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)
      session = session_fixture(user)
      report = report_fixture(session)

      {:ok, view, _html} = live(conn, ~p"/reports/#{report.id}")

      html = view |> element("button", "Edit Section") |> render_click()

      assert html =~ "Done Editing"
      assert html =~ "tiptap-editor" or html =~ "TipTapEditor"
    end

    test "shows export menu", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)
      session = session_fixture(user)
      report = report_fixture(session)

      {:ok, view, _html} = live(conn, ~p"/reports/#{report.id}")

      html = view |> element("button[phx-click=toggle_export_menu]") |> render_click()

      assert html =~ "PDF Document"
      assert html =~ "Word Document"
      assert html =~ "HTML Page"
      assert html =~ "Markdown"
    end

    test "initiates export", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)
      session = session_fixture(user)
      report = report_fixture(session)

      {:ok, view, _html} = live(conn, ~p"/reports/#{report.id}")

      # Open export menu first
      view |> element("button[phx-click=toggle_export_menu]") |> render_click()

      # Click PDF export
      html = view |> element("button[phx-click=export][phx-value-format=pdf]") |> render_click()

      assert html =~ "Exporting" or html =~ "export started"
    end

    test "shows version history", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)
      session = session_fixture(user)
      report = report_fixture(session)

      # Create a version
      Reports.create_version(report, %{description: "Initial version"})

      {:ok, view, _html} = live(conn, ~p"/reports/#{report.id}")

      html = view |> element("button", "Version History") |> render_click()

      assert html =~ "Version History"
      assert html =~ "Version" or html =~ "Initial version"
    end

    test "shows suitability score", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)
      session = session_fixture(user)
      report = report_fixture(session, %{suitability_score: 85.5})

      {:ok, _view, html} = live(conn, ~p"/reports/#{report.id}")

      assert html =~ "Score"
      assert html =~ "86" or html =~ "85"
    end
  end
end
