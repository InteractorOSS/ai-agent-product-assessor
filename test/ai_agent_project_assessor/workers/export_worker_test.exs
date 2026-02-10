defmodule AiAgentProjectAssessor.Workers.ExportWorkerTest do
  use AiAgentProjectAssessor.DataCase
  use Oban.Testing, repo: AiAgentProjectAssessor.Repo

  alias AiAgentProjectAssessor.Workers.ExportWorker
  import AiAgentProjectAssessor.Fixtures

  describe "enqueue/3" do
    test "creates a job with valid format" do
      user = user_fixture()
      session = session_fixture(user)
      report = report_fixture(session)

      assert {:ok, %Oban.Job{}} = ExportWorker.enqueue(report.id, :pdf)
    end

    test "creates a job with user_id option" do
      user = user_fixture()
      session = session_fixture(user)
      report = report_fixture(session)

      assert {:ok, %Oban.Job{args: args}} =
               ExportWorker.enqueue(report.id, :pdf, user_id: user.id)

      assert args["user_id"] == user.id
    end

    test "supports all formats" do
      user = user_fixture()
      session = session_fixture(user)
      report = report_fixture(session)

      for format <- [:pdf, :docx, :html, :markdown] do
        assert {:ok, %Oban.Job{}} = ExportWorker.enqueue(report.id, format)
      end
    end
  end

  describe "perform/1" do
    test "generates markdown export" do
      user = user_fixture()
      session = session_fixture(user)
      report = report_fixture(session)

      assert {:ok, _export_id} =
               perform_job(ExportWorker, %{
                 "report_id" => report.id,
                 "format" => "markdown"
               })
    end

    test "returns error for non-existent report" do
      assert {:error, :report_not_found} =
               perform_job(ExportWorker, %{
                 "report_id" => Ecto.UUID.generate(),
                 "format" => "pdf"
               })
    end

    test "generates HTML export with fallback" do
      user = user_fixture()
      session = session_fixture(user)
      report = report_fixture(session)

      # This should use the fallback HTML generator if Pandoc isn't available
      result =
        perform_job(ExportWorker, %{
          "report_id" => report.id,
          "format" => "html"
        })

      assert {:ok, _export_id} = result
    end
  end
end
