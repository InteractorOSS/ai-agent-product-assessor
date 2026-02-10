defmodule AiAgentProjectAssessor.Reports do
  @moduledoc """
  The Reports context.

  Handles report management, version history, and exports.
  """

  import Ecto.Query, warn: false
  alias AiAgentProjectAssessor.Repo
  alias AiAgentProjectAssessor.Reports.{Report, Version, Export}

  # ============================================================================
  # Reports
  # ============================================================================

  @doc """
  Gets a report by session ID.

  ## Examples

      iex> get_report_by_session("session-uuid")
      %Report{}

  """
  def get_report_by_session(session_id) do
    Repo.get_by(Report, session_id: session_id)
  end

  @doc """
  Gets a report by session ID with preloads.

  ## Examples

      iex> get_report_by_session_with_preloads("session-uuid")
      %Report{versions: [...], exports: [...]}

  """
  def get_report_by_session_with_preloads(session_id) do
    Report
    |> where([r], r.session_id == ^session_id)
    |> preload([:versions, :exports])
    |> Repo.one()
  end

  @doc """
  Gets a single report.

  ## Examples

      iex> get_report!("valid-uuid")
      %Report{}

  """
  def get_report!(id), do: Repo.get!(Report, id)

  @doc """
  Gets a report with preloads.

  ## Examples

      iex> get_report_with_preloads!("valid-uuid")
      %Report{session: %Session{}, versions: [...]}

  """
  def get_report_with_preloads!(id) do
    Report
    |> where([r], r.id == ^id)
    |> preload([:session, :versions, :exports])
    |> Repo.one!()
  end

  @doc """
  Creates a report for a session.

  ## Examples

      iex> create_report(%{session_id: "...", content: %{...}})
      {:ok, %Report{}}

  """
  def create_report(attrs \\ %{}) do
    %Report{}
    |> Report.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a report.

  ## Examples

      iex> update_report(report, %{content: %{...}})
      {:ok, %Report{}}

  """
  def update_report(%Report{} = report, attrs) do
    report
    |> Report.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a specific section of a report.

  ## Examples

      iex> update_section(report, "executive_summary", "New content...")
      {:ok, %Report{}}

  """
  def update_section(%Report{} = report, section_key, content) do
    updated_content = Map.put(report.content, section_key, content)
    update_report(report, %{content: updated_content})
  end

  @doc """
  Reorders report sections.

  ## Examples

      iex> reorder_sections(report, ["section1", "section2", ...])
      {:ok, %Report{}}

  """
  def reorder_sections(%Report{} = report, new_order) do
    update_report(report, %{section_order: new_order})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking report changes.
  """
  def change_report(%Report{} = report, attrs \\ %{}) do
    Report.update_changeset(report, attrs)
  end

  # ============================================================================
  # Versions
  # ============================================================================

  @doc """
  Lists all versions for a report.

  Versions are ordered by version number descending (newest first).

  ## Examples

      iex> list_versions(report_id)
      [%Version{}, ...]

  """
  def list_versions(report_id) do
    Version
    |> where([v], v.report_id == ^report_id)
    |> order_by([v], desc: v.version_number)
    |> Repo.all()
  end

  @doc """
  Gets a single version.

  ## Examples

      iex> get_version!("valid-uuid")
      %Version{}

  """
  def get_version!(id), do: Repo.get!(Version, id)

  @doc """
  Gets the latest version for a report.

  ## Examples

      iex> get_latest_version(report_id)
      %Version{}

  """
  def get_latest_version(report_id) do
    Version
    |> where([v], v.report_id == ^report_id)
    |> order_by([v], desc: v.version_number)
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Gets the next version number for a report.

  ## Examples

      iex> next_version_number(report_id)
      2

  """
  def next_version_number(report_id) do
    case get_latest_version(report_id) do
      nil -> 1
      version -> version.version_number + 1
    end
  end

  @doc """
  Creates a version snapshot of the current report state.

  ## Examples

      iex> create_version(report, %{description: "Added risk section"})
      {:ok, %Version{}}

  """
  def create_version(%Report{} = report, attrs \\ %{}) do
    version_attrs =
      Map.merge(attrs, %{
        report_id: report.id,
        content: report.content,
        section_order: report.section_order,
        version_number: next_version_number(report.id)
      })

    %Version{}
    |> Version.create_changeset(version_attrs)
    |> Repo.insert()
  end

  @doc """
  Restores a report to a previous version.

  Creates a new version with the restored content.

  ## Examples

      iex> restore_version(report, version_id)
      {:ok, %Report{}}

  """
  def restore_version(%Report{} = report, version_id) do
    version = get_version!(version_id)

    Repo.transaction(fn ->
      # Create a version of the current state before restoring
      {:ok, _} =
        create_version(report, %{
          description: "Before restore to v#{version.version_number}",
          change_summary: "Auto-saved before restore"
        })

      # Update the report with the version content
      {:ok, updated_report} =
        update_report(report, %{
          content: version.content,
          section_order: version.section_order
        })

      # Create a new version for the restored state
      {:ok, _} =
        create_version(updated_report, %{
          description: "Restored from v#{version.version_number}",
          change_summary: "Restored to previous version"
        })

      updated_report
    end)
  end

  # ============================================================================
  # Exports
  # ============================================================================

  @doc """
  Lists all exports for a report.

  ## Examples

      iex> list_exports(report_id)
      [%Export{}, ...]

  """
  def list_exports(report_id) do
    Export
    |> where([e], e.report_id == ^report_id)
    |> order_by([e], desc: e.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single export.

  ## Examples

      iex> get_export!("valid-uuid")
      %Export{}

  """
  def get_export!(id), do: Repo.get!(Export, id)

  @doc """
  Creates an export record.

  ## Examples

      iex> create_export(%{report_id: "...", format: :pdf, file_path: "/exports/..."})
      {:ok, %Export{}}

  """
  def create_export(attrs \\ %{}) do
    %Export{}
    |> Export.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets the most recent export of a specific format for a report.

  ## Examples

      iex> get_latest_export(report_id, :pdf)
      %Export{}

  """
  def get_latest_export(report_id, format) do
    Export
    |> where([e], e.report_id == ^report_id and e.format == ^format)
    |> order_by([e], desc: e.inserted_at)
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Deletes old exports, keeping the most recent N per format.

  ## Examples

      iex> cleanup_old_exports(report_id, 5)
      {count, nil}

  """
  def cleanup_old_exports(report_id, keep_count \\ 5) do
    for format <- Export.formats() do
      exports_to_keep =
        Export
        |> where([e], e.report_id == ^report_id and e.format == ^format)
        |> order_by([e], desc: e.inserted_at)
        |> limit(^keep_count)
        |> select([e], e.id)
        |> Repo.all()

      Export
      |> where([e], e.report_id == ^report_id and e.format == ^format)
      |> where([e], e.id not in ^exports_to_keep)
      |> Repo.delete_all()
    end
  end
end
