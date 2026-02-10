defmodule AiAgentProjectAssessorWeb.WebhookController do
  @moduledoc """
  Handles webhooks from Interactor services.

  Receives and processes events for:
  - Workflow state changes
  - Agent message completions
  - Assessment status updates

  ## Security

  All webhooks are verified using HMAC-SHA256 signatures to ensure
  they originate from Interactor.
  """

  use AiAgentProjectAssessorWeb, :controller

  alias AiAgentProjectAssessor.Assessments

  require Logger

  @webhook_secret_env "INTERACTOR_WEBHOOK_SECRET"

  @doc """
  Handles incoming webhooks from Interactor.
  """
  def handle(conn, params) do
    with :ok <- verify_signature(conn),
         {:ok, event} <- parse_event(params) do
      process_event(event)

      conn
      |> put_status(:ok)
      |> json(%{status: "received"})
    else
      {:error, :invalid_signature} ->
        Logger.warning("Webhook signature verification failed")

        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid signature"})

      {:error, reason} ->
        Logger.error("Webhook processing failed: #{inspect(reason)}")

        conn
        |> put_status(:bad_request)
        |> json(%{error: "Processing failed"})
    end
  end

  # Signature Verification

  defp verify_signature(conn) do
    secret = System.get_env(@webhook_secret_env)

    # Skip verification in dev if no secret configured
    if is_nil(secret) do
      if Application.get_env(:ai_agent_project_assessor, :dev_routes, false) do
        Logger.debug("Webhook signature verification skipped (dev mode)")
        :ok
      else
        {:error, :invalid_signature}
      end
    else
      do_verify_signature(conn, secret)
    end
  end

  defp do_verify_signature(conn, secret) do
    signature = get_req_header(conn, "x-interactor-signature") |> List.first()
    timestamp = get_req_header(conn, "x-interactor-timestamp") |> List.first()

    if signature && timestamp do
      body = conn.assigns[:raw_body] || ""
      payload = "#{timestamp}.#{body}"
      expected = :crypto.mac(:hmac, :sha256, secret, payload) |> Base.encode16(case: :lower)

      if secure_compare(signature, "sha256=#{expected}") do
        :ok
      else
        {:error, :invalid_signature}
      end
    else
      {:error, :invalid_signature}
    end
  end

  defp secure_compare(a, b) when byte_size(a) == byte_size(b) do
    :crypto.hash_equals(a, b)
  end

  defp secure_compare(_, _), do: false

  # Event Parsing

  defp parse_event(params) do
    case params do
      %{"event_type" => type, "data" => data} ->
        {:ok, %{type: type, data: data}}

      _ ->
        {:error, :invalid_event_format}
    end
  end

  # Event Processing

  defp process_event(%{type: "workflow.state_changed", data: data}) do
    Logger.info("Processing workflow state change: #{inspect(data)}")

    workflow_instance_id = data["instance_id"]
    new_state = data["new_state"]
    workflow_data = data["data"] || %{}

    case Assessments.get_session_by_workflow_id(workflow_instance_id) do
      nil ->
        Logger.warning("Session not found for workflow: #{workflow_instance_id}")

      session ->
        update_session_from_workflow(session, new_state, workflow_data)
    end
  end

  defp process_event(%{type: "workflow.completed", data: data}) do
    Logger.info("Processing workflow completion: #{inspect(data)}")

    workflow_instance_id = data["instance_id"]

    case Assessments.get_session_by_workflow_id(workflow_instance_id) do
      nil ->
        Logger.warning("Session not found for workflow: #{workflow_instance_id}")

      session ->
        Assessments.transition_status(session, :ready_for_report)
    end
  end

  defp process_event(%{type: "agent.message_completed", data: data}) do
    Logger.info("Processing agent message completion: #{inspect(data)}")
    # Could be used for real-time updates via PubSub
    room_id = data["room_id"]

    if room_id do
      Phoenix.PubSub.broadcast(
        AiAgentProjectAssessor.PubSub,
        "room:#{room_id}",
        {:message_completed, data}
      )
    end
  end

  defp process_event(%{type: type, data: _data}) do
    Logger.debug("Ignoring unhandled event type: #{type}")
  end

  # Session Updates

  defp update_session_from_workflow(session, state, workflow_data) do
    confidence = get_in(workflow_data, ["confidence_scores", "overall"]) || session.confidence
    dimensions_complete = workflow_data["dimensions_complete"] || session.dimensions_complete

    new_status =
      case state do
        "gathering_info" -> :gathering
        "ready_for_report" -> :ready_for_report
        "generating_report" -> :ready_for_report
        "report_ready" -> :report_generated
        "editing" -> :editing
        "exported" -> :exported
        _ -> session.status
      end

    Assessments.update_session(session, %{
      status: new_status,
      confidence: confidence,
      dimensions_complete: dimensions_complete,
      metadata: Map.merge(session.metadata || %{}, %{"workflow_data" => workflow_data})
    })
  end
end
