defmodule AiAgentProjectAssessor.Notifications do
  @moduledoc """
  Notification system for sending emails and in-app notifications.

  Handles various notification types including:
  - Export completion notifications
  - Assessment completion notifications
  - Report generation notifications
  """

  import Swoosh.Email

  alias AiAgentProjectAssessor.Accounts
  alias AiAgentProjectAssessor.Mailer

  require Logger

  @from_email {"AI Assessment Tool", "noreply@assessor.example.com"}

  @doc """
  Sends notification when export is ready for download.
  """
  def send_export_ready(user_id, %{report_id: report_id, export_id: export_id, format: format}) do
    with {:ok, user} <- get_user(user_id),
         email when not is_nil(email) <- user.email do
      new()
      |> to({user.name || "User", email})
      |> from(@from_email)
      |> subject("Your #{format_name(format)} Export is Ready")
      |> html_body(export_ready_html(user, format, report_id, export_id))
      |> text_body(export_ready_text(user, format, report_id))
      |> deliver()

      Logger.info("Export ready notification sent", user_id: user_id, export_id: export_id)
      :ok
    else
      {:error, :user_not_found} ->
        Logger.warning("Cannot send notification - user not found", user_id: user_id)
        {:error, :user_not_found}

      nil ->
        Logger.warning("Cannot send notification - no email", user_id: user_id)
        {:error, :no_email}
    end
  end

  @doc """
  Sends notification when export generation fails.
  """
  def send_export_failed(user_id, %{report_id: report_id, reason: reason}) do
    with {:ok, user} <- get_user(user_id),
         email when not is_nil(email) <- user.email do
      new()
      |> to({user.name || "User", email})
      |> from(@from_email)
      |> subject("Export Generation Failed")
      |> html_body(export_failed_html(user, report_id, reason))
      |> text_body(export_failed_text(user, report_id, reason))
      |> deliver()

      Logger.info("Export failed notification sent", user_id: user_id, report_id: report_id)
      :ok
    else
      _ ->
        {:error, :cannot_send}
    end
  end

  @doc """
  Sends notification when assessment is complete and report is ready.
  """
  def send_assessment_complete(user_id, %{session_id: session_id, report_id: report_id}) do
    with {:ok, user} <- get_user(user_id),
         email when not is_nil(email) <- user.email do
      new()
      |> to({user.name || "User", email})
      |> from(@from_email)
      |> subject("Your AI Assessment Report is Ready!")
      |> html_body(assessment_complete_html(user, session_id, report_id))
      |> text_body(assessment_complete_text(user, report_id))
      |> deliver()

      Logger.info("Assessment complete notification sent",
        user_id: user_id,
        session_id: session_id
      )

      :ok
    else
      _ ->
        {:error, :cannot_send}
    end
  end

  # Private functions

  defp get_user(user_id) do
    case Accounts.get_user(user_id) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end

  defp deliver(email) do
    case Mailer.deliver(email) do
      {:ok, _} -> {:ok, :sent}
      {:error, reason} -> {:error, reason}
    end
  end

  defp format_name(:pdf), do: "PDF"
  defp format_name(:docx), do: "Word Document"
  defp format_name(:html), do: "HTML"
  defp format_name(:markdown), do: "Markdown"
  defp format_name(other), do: to_string(other) |> String.upcase()

  # Email templates

  defp export_ready_html(user, format, report_id, export_id) do
    """
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #1a1a1a; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #4CD964 0%, #3DBF55 100%); color: white; padding: 30px; border-radius: 12px 12px 0 0; }
        .content { background: #f9fafb; padding: 30px; border-radius: 0 0 12px 12px; }
        .button { display: inline-block; background: #4CD964; color: white; padding: 12px 24px; border-radius: 9999px; text-decoration: none; font-weight: 600; }
        .footer { text-align: center; margin-top: 20px; color: #6b7280; font-size: 14px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1 style="margin: 0;">Your Export is Ready!</h1>
        </div>
        <div class="content">
          <p>Hi #{user.name || "there"},</p>
          <p>Great news! Your <strong>#{format_name(format)}</strong> export has been generated and is ready for download.</p>
          <p style="text-align: center; margin: 30px 0;">
            <a href="/reports/#{report_id}/exports/#{export_id}/download" class="button">
              Download #{format_name(format)}
            </a>
          </p>
          <p>This export will be available for download for 7 days.</p>
        </div>
        <div class="footer">
          <p>AI Agent Project Assessor</p>
        </div>
      </div>
    </body>
    </html>
    """
  end

  defp export_ready_text(user, format, report_id) do
    """
    Hi #{user.name || "there"},

    Great news! Your #{format_name(format)} export has been generated and is ready for download.

    Download your export: /reports/#{report_id}

    This export will be available for download for 7 days.

    ---
    AI Agent Project Assessor
    """
  end

  defp export_failed_html(user, report_id, reason) do
    """
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #1a1a1a; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #FF3B30; color: white; padding: 30px; border-radius: 12px 12px 0 0; }
        .content { background: #f9fafb; padding: 30px; border-radius: 0 0 12px 12px; }
        .button { display: inline-block; background: #4CD964; color: white; padding: 12px 24px; border-radius: 9999px; text-decoration: none; font-weight: 600; }
        .footer { text-align: center; margin-top: 20px; color: #6b7280; font-size: 14px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1 style="margin: 0;">Export Generation Failed</h1>
        </div>
        <div class="content">
          <p>Hi #{user.name || "there"},</p>
          <p>Unfortunately, we encountered an issue while generating your export.</p>
          <p><strong>Error:</strong> #{reason}</p>
          <p style="text-align: center; margin: 30px 0;">
            <a href="/reports/#{report_id}" class="button">
              Try Again
            </a>
          </p>
          <p>If this problem persists, please contact support.</p>
        </div>
        <div class="footer">
          <p>AI Agent Project Assessor</p>
        </div>
      </div>
    </body>
    </html>
    """
  end

  defp export_failed_text(user, report_id, reason) do
    """
    Hi #{user.name || "there"},

    Unfortunately, we encountered an issue while generating your export.

    Error: #{reason}

    You can try again at: /reports/#{report_id}

    If this problem persists, please contact support.

    ---
    AI Agent Project Assessor
    """
  end

  defp assessment_complete_html(user, _session_id, report_id) do
    """
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #1a1a1a; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #4CD964 0%, #3DBF55 100%); color: white; padding: 30px; border-radius: 12px 12px 0 0; }
        .content { background: #f9fafb; padding: 30px; border-radius: 0 0 12px 12px; }
        .button { display: inline-block; background: #4CD964; color: white; padding: 12px 24px; border-radius: 9999px; text-decoration: none; font-weight: 600; }
        .feature-list { margin: 20px 0; padding: 0; list-style: none; }
        .feature-list li { padding: 8px 0; padding-left: 24px; position: relative; }
        .feature-list li::before { content: "✓"; position: absolute; left: 0; color: #4CD964; font-weight: bold; }
        .footer { text-align: center; margin-top: 20px; color: #6b7280; font-size: 14px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1 style="margin: 0;">Your Assessment Report is Ready!</h1>
        </div>
        <div class="content">
          <p>Hi #{user.name || "there"},</p>
          <p>Congratulations! Your AI project assessment is complete and your comprehensive report is ready to view.</p>

          <p>Your report includes:</p>
          <ul class="feature-list">
            <li>Project viability score</li>
            <li>Detailed feasibility analysis</li>
            <li>Technical requirements breakdown</li>
            <li>Risk assessment and mitigation strategies</li>
            <li>Resource estimation</li>
            <li>Implementation roadmap</li>
          </ul>

          <p style="text-align: center; margin: 30px 0;">
            <a href="/reports/#{report_id}" class="button">
              View Your Report
            </a>
          </p>
        </div>
        <div class="footer">
          <p>AI Agent Project Assessor</p>
        </div>
      </div>
    </body>
    </html>
    """
  end

  defp assessment_complete_text(user, report_id) do
    """
    Hi #{user.name || "there"},

    Congratulations! Your AI project assessment is complete and your comprehensive report is ready to view.

    Your report includes:
    - Project viability score
    - Detailed feasibility analysis
    - Technical requirements breakdown
    - Risk assessment and mitigation strategies
    - Resource estimation
    - Implementation roadmap

    View your report: /reports/#{report_id}

    ---
    AI Agent Project Assessor
    """
  end
end
