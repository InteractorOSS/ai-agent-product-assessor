#!/bin/bash

# Sync External Documentation Script
# Manually sync documentation from external repositories
#
# Usage:
#   ./sync-external-docs.sh                    # Interactive mode
#   ./sync-external-docs.sh interactor-auth   # Direct sync
#   ./sync-external-docs.sh --dry-run         # Preview only
#   ./sync-external-docs.sh --preserve-local  # Smart merge mode

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# External docs configuration
declare -A EXTERNAL_DOCS=(
  ["interactor-auth"]="pulzze/account-server|docs/integration-guide.md|docs/i/guides/interactor-authentication.md|docs/i/guides/.interactor-auth-meta.json"
)

# Flags
DRY_RUN=false
PRESERVE_LOCAL=false
VERBOSE=false

# Functions

print_header() {
  echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║${NC}  Sync External Documentation                                  ${BLUE}║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
  echo ""
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
  echo -e "${RED}❌ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

check_dependencies() {
  local missing_deps=()

  if ! command -v curl &> /dev/null; then
    missing_deps+=("curl")
  fi

  if ! command -v jq &> /dev/null; then
    missing_deps+=("jq")
  fi

  if ! command -v git &> /dev/null; then
    missing_deps+=("git")
  fi

  if [ ${#missing_deps[@]} -ne 0 ]; then
    print_error "Missing required dependencies: ${missing_deps[*]}"
    echo ""
    echo "Install with:"
    echo "  macOS: brew install ${missing_deps[*]}"
    echo "  Ubuntu/Debian: sudo apt-get install ${missing_deps[*]}"
    exit 1
  fi
}

show_usage() {
  cat << EOF
Usage: $(basename "$0") [OPTIONS] [COMPONENT]

Sync documentation from external repositories.

COMPONENTS:
  interactor-auth    Interactor authentication guide

OPTIONS:
  --dry-run          Preview changes without modifying files
  --preserve-local   Preserve local modifications (smart merge)
  --verbose          Show detailed output
  -h, --help         Show this help message

EXAMPLES:
  $(basename "$0")                          # Interactive mode
  $(basename "$0") interactor-auth          # Sync specific component
  $(basename "$0") --dry-run interactor-auth  # Preview changes

EOF
}

check_upstream_version() {
  local repo="$1"
  local meta_file="$2"

  print_info "Checking upstream version for $repo..."

  # Fetch upstream commit SHA
  local upstream_sha
  upstream_sha=$(curl -s "https://api.github.com/repos/$repo/commits/main" | jq -r '.sha')

  if [ -z "$upstream_sha" ] || [ "$upstream_sha" = "null" ]; then
    print_error "Failed to fetch upstream commit SHA from $repo"
    return 1
  fi

  # Read local SHA from metadata
  local local_sha="none"
  if [ -f "$meta_file" ]; then
    local_sha=$(jq -r '.source_commit' "$meta_file" 2>/dev/null || echo "none")
  fi

  if [ "$VERBOSE" = true ]; then
    echo "  Upstream SHA: $upstream_sha"
    echo "  Local SHA: $local_sha"
  fi

  # Return values via global variables
  UPSTREAM_SHA="$upstream_sha"
  LOCAL_SHA="$local_sha"

  if [ "$upstream_sha" = "$local_sha" ]; then
    return 0  # Up to date
  else
    return 1  # Changes available
  fi
}

fetch_content() {
  local repo="$1"
  local source_path="$2"
  local target_file="$3"
  local upstream_sha="$4"

  print_info "Fetching content from $repo/$source_path..."

  local raw_url="https://raw.githubusercontent.com/$repo/$upstream_sha/$source_path"

  if [ "$DRY_RUN" = true ]; then
    print_info "DRY RUN: Would fetch from $raw_url"
    return 0
  fi

  # Create target directory if needed
  local target_dir
  target_dir=$(dirname "$target_file")
  mkdir -p "$target_dir"

  # Fetch content
  local http_status
  http_status=$(curl -s -w "%{http_code}" -o "$target_file" "$raw_url")

  if [ "$http_status" != "200" ]; then
    print_error "Failed to fetch content (HTTP $http_status)"
    return 1
  fi

  # Verify file has content
  if [ ! -s "$target_file" ]; then
    print_error "Downloaded file is empty"
    return 1
  fi

  local line_count
  line_count=$(wc -l < "$target_file")
  print_success "Content fetched successfully ($line_count lines)"

  return 0
}

update_metadata() {
  local repo="$1"
  local source_path="$2"
  local target_file="$3"
  local meta_file="$4"
  local upstream_sha="$5"

  print_info "Updating metadata..."

  if [ "$DRY_RUN" = true ]; then
    print_info "DRY RUN: Would update $meta_file"
    return 0
  fi

  # Calculate content hash
  local content_sha
  if command -v sha256sum &> /dev/null; then
    content_sha=$(sha256sum "$target_file" | cut -d' ' -f1)
  else
    # macOS fallback
    content_sha=$(shasum -a 256 "$target_file" | cut -d' ' -f1)
  fi

  # Get current user info
  local synced_by
  synced_by=$(git config user.name 2>/dev/null || echo "$(whoami)")

  # Generate metadata JSON
  jq -n \
    --arg repo "$repo" \
    --arg path "$source_path" \
    --arg commit "$upstream_sha" \
    --arg synced "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --arg synced_by "$synced_by" \
    --arg sha "$content_sha" \
    --arg url "https://github.com/$repo/blob/main/$source_path" \
    '{
      source_repo: $repo,
      source_path: $path,
      source_commit: $commit,
      synced_at: $synced,
      synced_by: $synced_by,
      content_sha256: $sha,
      upstream_url: $url
    }' > "$meta_file"

  print_success "Metadata updated"

  if [ "$VERBOSE" = true ]; then
    cat "$meta_file"
  fi

  return 0
}

show_preview() {
  local target_file="$1"

  print_info "Preview of changes:"
  echo ""

  if git diff --no-index --color=always /dev/null "$target_file" 2>/dev/null | tail -n +5; then
    :
  else
    print_warning "Unable to show diff (file may be new)"
    echo "File will be created at: $target_file"
  fi

  echo ""
}

confirm_action() {
  local prompt="$1"

  if [ "$DRY_RUN" = true ]; then
    return 0
  fi

  echo -n -e "${YELLOW}$prompt [y/N]: ${NC}"
  read -r response

  case "$response" in
    [yY][eE][sS]|[yY])
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

commit_changes() {
  local target_file="$1"
  local meta_file="$2"
  local repo="$3"
  local upstream_sha="$4"

  if [ "$DRY_RUN" = true ]; then
    print_info "DRY RUN: Would commit changes"
    return 0
  fi

  print_info "Committing changes..."

  # Check if files have changes
  if ! git diff --quiet "$target_file" "$meta_file" 2>/dev/null; then
    git add "$target_file" "$meta_file"

    local short_sha="${upstream_sha:0:7}"
    git commit -m "docs: sync external documentation" \
      -m "Synced from $repo@$short_sha" \
      -m "Manual sync via sync-external-docs.sh"

    print_success "Changes committed"
  else
    print_info "No changes to commit"
  fi

  return 0
}

sync_component() {
  local component="$1"

  if [ -z "${EXTERNAL_DOCS[$component]}" ]; then
    print_error "Unknown component: $component"
    echo "Available components: ${!EXTERNAL_DOCS[*]}"
    return 1
  fi

  # Parse configuration
  IFS='|' read -r repo source_path target_file meta_file <<< "${EXTERNAL_DOCS[$component]}"

  # Convert relative paths to absolute
  target_file="$REPO_ROOT/$target_file"
  meta_file="$REPO_ROOT/$meta_file"

  echo ""
  print_info "Syncing: $component"
  echo "  Source: $repo/$source_path"
  echo "  Target: $target_file"
  echo ""

  # Check upstream version
  if ! check_upstream_version "$repo" "$meta_file"; then
    print_info "Changes detected"
    echo "  Local:    $LOCAL_SHA"
    echo "  Upstream: $UPSTREAM_SHA"
    echo ""

    # Fetch content
    if ! fetch_content "$repo" "$source_path" "$target_file" "$UPSTREAM_SHA"; then
      return 1
    fi

    # Show preview if requested
    if [ "$DRY_RUN" = true ]; then
      show_preview "$target_file"
      print_info "DRY RUN: No changes were made"
      return 0
    fi

    # Update metadata
    if ! update_metadata "$repo" "$source_path" "$target_file" "$meta_file" "$UPSTREAM_SHA"; then
      return 1
    fi

    # Confirm before committing
    if confirm_action "Commit changes to git?"; then
      commit_changes "$target_file" "$meta_file" "$repo" "$UPSTREAM_SHA"
    else
      print_info "Skipped commit (changes saved locally)"
    fi

    echo ""
    print_success "Sync completed successfully"
  else
    print_success "Already up to date (SHA: $UPSTREAM_SHA)"
  fi

  return 0
}

interactive_mode() {
  print_header

  echo "Available components:"
  echo ""
  local i=1
  for component in "${!EXTERNAL_DOCS[@]}"; do
    echo "  $i) $component"
    ((i++))
  done
  echo "  0) All components"
  echo ""

  echo -n "Select component to sync (0-$((i-1))): "
  read -r selection

  case "$selection" in
    0)
      for component in "${!EXTERNAL_DOCS[@]}"; do
        sync_component "$component"
      done
      ;;
    [1-9])
      local component_array=(${!EXTERNAL_DOCS[@]})
      local selected_component="${component_array[$((selection-1))]}"
      sync_component "$selected_component"
      ;;
    *)
      print_error "Invalid selection"
      return 1
      ;;
  esac
}

# Main script

# Parse arguments
COMPONENT=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --preserve-local)
      PRESERVE_LOCAL=true
      shift
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    -h|--help)
      show_usage
      exit 0
      ;;
    *)
      COMPONENT="$1"
      shift
      ;;
  esac
done

# Check dependencies
check_dependencies

# Change to repo root
cd "$REPO_ROOT"

# Run in appropriate mode
if [ -z "$COMPONENT" ]; then
  interactive_mode
else
  print_header
  sync_component "$COMPONENT"
fi

exit 0
