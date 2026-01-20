# Interactor Guides

This directory contains integration guides and documentation for Interactor-specific features and services.

## Auto-Synced Documentation

Some files in this directory are automatically synchronized from external Interactor repositories to ensure you always have the latest integration guidance.

### Synced Files

| File | Source Repository | Sync Frequency |
|------|-------------------|----------------|
| `interactor-authentication.md` | [`pulzze/account-server`](https://github.com/pulzze/account-server/blob/main/docs/integration-guide.md) | Daily at 6am UTC |

### How Auto-Sync Works

1. **Automated Daily Sync:**
   - GitHub Actions workflow runs daily at 6am UTC
   - Checks for updates in the source repository
   - If changes detected, fetches latest content and updates metadata
   - Commits changes automatically to `main` branch

2. **Change Detection:**
   - Compares commit SHAs between local metadata and upstream repository
   - Only syncs when actual changes are detected
   - Skips unnecessary commits when content is up-to-date

3. **Metadata Tracking:**
   - Each synced file has a corresponding `.{filename}-meta.json` file
   - Contains source commit SHA, sync timestamp, content hash
   - Used for change detection and audit trail

4. **Failure Handling:**
   - Workflow failures automatically create GitHub issues
   - Issues include error details and troubleshooting steps
   - Manual sync commands provided in issue body

---

## Manual Sync

You can manually trigger a sync at any time using the provided script.

### Basic Usage

```bash
# Interactive mode - select component
./scripts/setup/sync-external-docs.sh

# Sync specific component
./scripts/setup/sync-external-docs.sh interactor-auth

# Preview changes without applying
./scripts/setup/sync-external-docs.sh --dry-run interactor-auth

# Verbose output with detailed logging
./scripts/setup/sync-external-docs.sh --verbose interactor-auth
```

### Available Components

- **`interactor-auth`** - Interactor authentication integration guide

### Script Options

| Option | Description |
|--------|-------------|
| `--dry-run` | Preview changes without modifying files |
| `--preserve-local` | Smart merge mode (preserves local modifications) |
| `--verbose` | Show detailed output including API calls and diffs |
| `-h, --help` | Display usage information |

---

## Triggering Workflow Manually

You can manually trigger the sync workflow via GitHub Actions:

1. Navigate to **Actions** tab in GitHub
2. Select **"Sync External Documentation"** workflow
3. Click **"Run workflow"**
4. Configure options:
   - **Target branch:** `main` (default) or create feature branch
   - **Create PR:** Check to create pull request instead of direct push
5. Click **"Run workflow"**

---

## Understanding Metadata Files

Each synced document has a corresponding metadata file (prefixed with `.` and suffixed with `-meta.json`).

### Example: `.interactor-auth-meta.json`

```json
{
  "source_repo": "pulzze/account-server",
  "source_path": "docs/integration-guide.md",
  "source_commit": "abc123def456...",
  "synced_at": "2026-01-19T06:00:00Z",
  "synced_by": "github-actions[bot]",
  "content_sha256": "789ghi012jkl...",
  "upstream_url": "https://github.com/pulzze/account-server/blob/main/docs/integration-guide.md"
}
```

### Metadata Fields

| Field | Description |
|-------|-------------|
| `source_repo` | GitHub repository in format `owner/repo` |
| `source_path` | Path to source file within repository |
| `source_commit` | Full SHA of the commit that was synced |
| `synced_at` | ISO 8601 timestamp of sync operation |
| `synced_by` | User or bot that performed sync |
| `content_sha256` | SHA256 hash of synced content for integrity verification |
| `upstream_url` | Direct link to source file on GitHub |

---

## Troubleshooting

### Sync Fails with "Failed to fetch upstream commit SHA"

**Cause:** Repository is private or GitHub token lacks access.

**Solution:**
1. Verify repository access permissions
2. For private repositories, ensure `GITHUB_TOKEN` has `repo` scope
3. Test access: `curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/pulzze/account-server`

### Sync Fails with "HTTP 404"

**Cause:** Source file has been moved or deleted in upstream repository.

**Solution:**
1. Verify file still exists at source location
2. Check if path changed in source repository
3. Update configuration in `scripts/setup/sync-external-docs.sh` if needed

### Sync Fails with "HTTP 301 (Moved Permanently)"

**Cause:** Repository or file has been relocated.

**Solution:**
1. Check source repository for redirects
2. Update `source_path` in script configuration
3. Manually verify correct URL

### "Already up to date" but content looks outdated

**Cause:** Metadata file may be corrupted or out of sync.

**Solution:**
```bash
# Remove metadata file to force fresh sync
rm docs/i/guides/.interactor-auth-meta.json

# Run sync again
./scripts/setup/sync-external-docs.sh interactor-auth
```

### Local modifications are being overwritten

**Cause:** Auto-sync commits directly, overwriting local changes.

**Solution:**
1. Use `--preserve-local` mode for smart merging (future feature)
2. Alternatively, create workflow with `create_pr: true` to review changes first
3. For permanent local customization, consider forking the source document

---

## Adding New External Docs

To add additional external documents to the sync system:

1. **Update script configuration** in `scripts/setup/sync-external-docs.sh`:
   ```bash
   declare -A EXTERNAL_DOCS=(
     ["interactor-auth"]="pulzze/account-server|docs/integration-guide.md|docs/i/guides/interactor-authentication.md|docs/i/guides/.interactor-auth-meta.json"
     ["new-doc"]="owner/repo|path/to/source.md|docs/i/guides/target.md|docs/i/guides/.target-meta.json"
   )
   ```

2. **Update workflow** in `.github/workflows/sync-external-docs.yml`:
   - Add new job for the component
   - Follow existing job structure

3. **Create initial metadata:**
   ```bash
   ./scripts/setup/sync-external-docs.sh new-doc
   ```

4. **Update this README** with new component details

5. **Test thoroughly** before committing:
   ```bash
   # Test dry-run
   ./scripts/setup/sync-external-docs.sh --dry-run new-doc

   # Test actual sync
   ./scripts/setup/sync-external-docs.sh new-doc
   ```

---

## Best Practices

### ✅ Do

- Review auto-synced changes via commit history
- Keep metadata files committed alongside content
- Use manual sync before major releases to ensure latest docs
- Monitor GitHub Actions for sync failures
- Test sync script locally before modifying configuration

### ❌ Don't

- Don't manually edit auto-synced documentation files (changes will be overwritten)
- Don't delete metadata files (needed for change detection)
- Don't modify workflow without testing via workflow dispatch first
- Don't ignore sync failure issues - investigate promptly

---

## Workflow Files

### `.github/workflows/sync-external-docs.yml`

Main workflow for automated daily sync. Features:
- Daily schedule at 6am UTC
- Manual trigger via workflow dispatch
- Change detection before fetching
- Automatic metadata generation
- Failure notifications via GitHub Issues

### `scripts/setup/sync-external-docs.sh`

Manual sync script for developers. Features:
- Interactive component selection
- Dry-run mode for previewing changes
- Colored output with status indicators
- Git commit automation with detailed messages
- Cross-platform (macOS and Linux)

---

## Security Considerations

### Repository Access

- Workflow uses `GITHUB_TOKEN` with repository scope
- For private repositories, token must have `repo` access
- Consider using machine account for production workflows

### Content Integrity

- SHA256 hashing verifies content integrity
- Metadata tracking provides audit trail
- Failed integrity checks abort sync

### Rate Limiting

- GitHub API: 5000 requests/hour with token (more than sufficient)
- Raw content fetching: No rate limits via CDN
- Workflow implements retry with exponential backoff

---

## Support

For issues with:
- **Sync system itself:** Create issue in this repository
- **Source documentation content:** Contact source repository maintainers
- **Authentication/access:** Verify with repository administrators

---

## Changelog

### 2026-01-19 - Initial Implementation

- Created auto-sync system for external documentation
- Added GitHub Actions workflow with daily schedule
- Implemented manual sync script with dry-run mode
- Established metadata tracking system
- Configured Interactor authentication guide as first synced doc

---

_This directory and its sync system are part of the Interactor product development template._
