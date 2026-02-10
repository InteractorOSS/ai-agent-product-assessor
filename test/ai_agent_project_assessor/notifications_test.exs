defmodule AiAgentProjectAssessor.NotificationsTest do
  use AiAgentProjectAssessor.DataCase

  alias AiAgentProjectAssessor.Notifications
  import AiAgentProjectAssessor.Fixtures

  describe "send_export_ready/2" do
    test "sends email when user has email" do
      user = user_fixture(%{email: "test@example.com", name: "Test User"})

      assert :ok =
               Notifications.send_export_ready(user.id, %{
                 report_id: "report-123",
                 export_id: "export-456",
                 format: :pdf
               })
    end

    test "returns error when user not found" do
      assert {:error, :user_not_found} =
               Notifications.send_export_ready(Ecto.UUID.generate(), %{
                 report_id: "report-123",
                 export_id: "export-456",
                 format: :pdf
               })
    end
  end

  describe "send_export_failed/2" do
    test "sends failure notification" do
      user = user_fixture(%{email: "test@example.com"})

      assert :ok =
               Notifications.send_export_failed(user.id, %{
                 report_id: "report-123",
                 reason: "Conversion failed"
               })
    end
  end

  describe "send_assessment_complete/2" do
    test "sends completion notification" do
      user = user_fixture(%{email: "test@example.com", name: "Test User"})

      assert :ok =
               Notifications.send_assessment_complete(user.id, %{
                 session_id: "session-123",
                 report_id: "report-456"
               })
    end
  end
end
