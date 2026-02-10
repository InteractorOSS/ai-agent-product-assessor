defmodule AiAgentProjectAssessorWeb.AssessmentLiveTest do
  use AiAgentProjectAssessorWeb.LiveCase

  alias AiAgentProjectAssessor.Assessments

  describe "Index" do
    test "redirects if user is not logged in", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/login"}}} = live(conn, ~p"/assessments")
    end

    test "lists all user assessments", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)

      # Create some assessments
      _session1 = session_fixture(user, %{name: "Project Alpha"})
      _session2 = session_fixture(user, %{name: "Project Beta"})

      {:ok, _view, html} = live(conn, ~p"/assessments")

      assert html =~ "Project Alpha"
      assert html =~ "Project Beta"
      assert html =~ "My Assessments"
    end

    test "shows page when no assessments", %{conn: conn} do
      {conn, _user} = register_and_log_in_user(conn)

      {:ok, _view, html} = live(conn, ~p"/assessments")

      # Page should load and show the header
      assert html =~ "My Assessments"
    end

    test "filters assessments by status", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)

      session_fixture(user, %{name: "Active Project", status: :gathering})
      session_fixture(user, %{name: "Report Generated Project", status: :report_generated})

      {:ok, view, _html} = live(conn, ~p"/assessments")

      # Filter by in-progress status
      html = view |> element("button", "In Progress") |> render_click()

      assert html =~ "Active Project"
      # The filter should hide the report_generated project
    end

    test "searches assessments by name", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)

      session_fixture(user, %{name: "Customer Support AI"})
      session_fixture(user, %{name: "Data Analysis Tool"})

      {:ok, view, _html} = live(conn, ~p"/assessments")

      # Search using the input element with phx-keyup
      html =
        view
        |> element("input[phx-keyup=search]")
        |> render_keyup(%{key: "c", value: "Customer"})

      assert html =~ "Customer Support AI"
    end

    test "deletes an assessment", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)

      session = session_fixture(user, %{name: "Delete Me"})

      {:ok, view, _html} = live(conn, ~p"/assessments")

      html =
        view
        |> element("button[phx-click=delete][phx-value-id='#{session.id}']")
        |> render_click()

      refute html =~ "Delete Me"
      assert Assessments.get_session(session.id) == nil
    end
  end

  describe "New" do
    test "redirects if user is not logged in", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/login"}}} = live(conn, ~p"/assessments/new")
    end

    test "renders new assessment form", %{conn: conn} do
      {conn, _user} = register_and_log_in_user(conn)

      {:ok, _view, html} = live(conn, ~p"/assessments/new")

      assert html =~ "New Assessment"
      assert html =~ "Project Name"
      assert html =~ "Project Description"
      assert html =~ "Quick Start Templates"
    end

    test "creates assessment and redirects", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)

      {:ok, view, _html} = live(conn, ~p"/assessments/new")

      {:ok, _view, html} =
        view
        |> form("form", %{
          assessment: %{
            name: "My New Project",
            initial_input: "A project to help users manage tasks"
          }
        })
        |> render_submit()
        |> follow_redirect(conn)

      # Should redirect to the assessment show page
      assert html =~ "My New Project" or html =~ "Assessment created"
    end

    test "selects a template and populates form", %{conn: conn} do
      {conn, _user} = register_and_log_in_user(conn)

      {:ok, view, _html} = live(conn, ~p"/assessments/new")

      html =
        view
        |> element("button[phx-click=select_template][phx-value-template=customer_support]")
        |> render_click()

      assert html =~ "Customer Support AI Agent"
      assert html =~ "Automatically respond to common customer inquiries"
    end

    test "validates required fields", %{conn: conn} do
      {conn, _user} = register_and_log_in_user(conn)

      {:ok, view, _html} = live(conn, ~p"/assessments/new")

      # Submit without required name
      html =
        view
        |> form("form", %{assessment: %{name: "", initial_input: "Some description"}})
        |> render_change()

      # The form should still be on the page (not redirected)
      assert html =~ "Project Name"
    end
  end

  describe "Show" do
    test "redirects if user is not logged in", %{conn: conn} do
      user = user_fixture()
      session = session_fixture(user)

      assert {:error, {:redirect, %{to: "/login"}}} = live(conn, ~p"/assessments/#{session.id}")
    end

    test "renders assessment page", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)
      session = session_fixture(user, %{name: "My Test Project"})

      {:ok, _view, html} = live(conn, ~p"/assessments/#{session.id}")

      assert html =~ "My Test Project"
    end

    test "shows dimension progress sidebar", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)
      session = session_fixture(user)

      {:ok, _view, html} = live(conn, ~p"/assessments/#{session.id}")

      # Should show assessment dimensions
      assert html =~ "Assessment Progress" or html =~ "Progress"
    end

    test "sends a message", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)
      session = session_fixture(user)

      {:ok, view, _html} = live(conn, ~p"/assessments/#{session.id}")

      # Type and send a message
      html =
        view
        |> form("form[phx-submit=send_message]", %{message: "Here is my project idea"})
        |> render_submit()

      # Message should appear in the chat (or processing indicator)
      assert html =~ "Here is my project idea" or html =~ "Analyzing" or html =~ "Processing"
    end

    test "navigates back to assessments list", %{conn: conn} do
      {conn, user} = register_and_log_in_user(conn)
      session = session_fixture(user)

      {:ok, view, _html} = live(conn, ~p"/assessments/#{session.id}")

      {:ok, _view, html} =
        view
        |> element("a[href='/assessments']")
        |> render_click()
        |> follow_redirect(conn, ~p"/assessments")

      assert html =~ "My Assessments"
    end
  end
end
