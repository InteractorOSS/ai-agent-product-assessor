#!/bin/bash
#
# Sync updates from the product-dev-template to your project
#
# Usage: ./sync-template.sh [component]
#
# Components:
#   all       - Sync everything (use with caution)
#   skills    - Sync .claude/skills/i/
#   commands  - Sync .claude/commands/i/
#   rules     - Sync .claude/rules/i/
#   icons     - Sync .claude/assets/icons/i/ (2600+ SVG icons)
#   docs      - Sync docs/i/phases/ and docs/i/checklists/
#   validator - Sync validator skill and validation checklist
#
# IMPORTANT: The "/i/" folder convention
# ======================================
# Files inside "/i/" directories are template-owned and safe to sync.
# Files OUTSIDE "/i/" directories are user-owned and will NOT be synced.
#
# Protected by design (not in /i/ paths):
#   - docs/project-idea-intake.md  (your project idea - never overwritten)
#   - CLAUDE.md                    (your project config - never overwritten)
#   - Any files you create outside /i/ directories
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Header
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         Product Dev Template - Sync Updates               ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Template repository URL
TEMPLATE_REPO_URL="https://github.com/pulzze/product-dev-template.git"

# Protected files - these should NEVER be overwritten by sync
# These are user-specific files that live outside /i/ directories
PROTECTED_FILES=(
    "docs/project-idea-intake.md"
    "CLAUDE.md"
)

# Check if a file is protected
is_protected() {
    local file=$1
    for protected in "${PROTECTED_FILES[@]}"; do
        if [[ "$file" == "$protected" ]]; then
            return 0
        fi
    done
    return 1
}

# Warn if any protected files would be affected
check_protected_files() {
    local path=$1
    local has_protected=false

    for protected in "${PROTECTED_FILES[@]}"; do
        if [[ "$protected" == "$path"* ]] || git diff --name-only HEAD template/main -- "$path" 2>/dev/null | grep -q "^$protected$"; then
            print_warning "Protected file would be affected: $protected"
            has_protected=true
        fi
    done

    if $has_protected; then
        print_warning "Protected files are user-specific and should not be synced."
        return 1
    fi
    return 0
}

# Check if template remote exists, add if missing
if ! git remote | grep -q "template"; then
    print_info "Adding template remote..."
    git remote add template "$TEMPLATE_REPO_URL"
    print_success "Added template remote: $TEMPLATE_REPO_URL"
    echo ""
fi

COMPONENT=${1:-"interactive"}

# Fetch latest from template
print_info "Fetching latest template updates..."
git fetch template
print_success "Fetched template updates"
echo ""

# Show what's changed
print_info "Changes available from template:"
echo ""
git log --oneline HEAD..template/main -- .claude/ docs/ 2>/dev/null | head -20 || echo "  (no new commits)"
echo ""

sync_component() {
    local component=$1
    local path=$2

    print_info "Syncing $component..."

    # Show what would change
    echo ""
    echo "Files that would be updated:"
    git diff --name-only HEAD template/main -- "$path" 2>/dev/null | head -20 || echo "  (no changes)"
    echo ""

    read -p "Proceed with sync? (y/n) " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git checkout template/main -- "$path"
        print_success "Synced $component"
    else
        print_warning "Skipped $component"
    fi
}

case $COMPONENT in
    all)
        print_warning "Syncing ALL template files. This may overwrite your customizations."
        read -p "Are you sure? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git checkout template/main -- .claude/
            git checkout template/main -- docs/i/phases/
            git checkout template/main -- docs/i/checklists/
            git checkout template/main -- docs/i/templates/
            print_success "Synced all template files"
        fi
        ;;
    skills)
        sync_component "skills" ".claude/skills/i/"
        ;;
    commands)
        sync_component "commands" ".claude/commands/i/"
        ;;
    rules)
        sync_component "rules" ".claude/rules/i/"
        ;;
    icons)
        sync_component "icons" ".claude/assets/icons/i/"
        ;;
    docs)
        sync_component "phase documentation" "docs/i/phases/"
        sync_component "checklists" "docs/i/checklists/"
        ;;
    validator)
        sync_component "validator skill" ".claude/skills/i/validator/"
        sync_component "validation checklist" "docs/i/checklists/validation-checklist.md"
        ;;
    interactive)
        echo "What would you like to sync?"
        echo ""
        echo "  1) Skills (.claude/skills/i/)"
        echo "  2) Commands (.claude/commands/i/)"
        echo "  3) Rules (.claude/rules/i/)"
        echo "  4) Icons (.claude/assets/icons/i/) - 2600+ SVG icons"
        echo "  5) Documentation (docs/i/phases/, docs/i/checklists/)"
        echo "  6) Validator only"
        echo "  7) All (use with caution)"
        echo "  8) Cancel"
        echo ""
        read -p "Select option (1-8): " -n 1 -r
        echo ""
        echo ""

        case $REPLY in
            1) sync_component "skills" ".claude/skills/i/" ;;
            2) sync_component "commands" ".claude/commands/i/" ;;
            3) sync_component "rules" ".claude/rules/i/" ;;
            4) sync_component "icons" ".claude/assets/icons/i/" ;;
            5)
                sync_component "phase documentation" "docs/i/phases/"
                sync_component "checklists" "docs/i/checklists/"
                ;;
            6)
                sync_component "validator skill" ".claude/skills/i/validator/"
                sync_component "validation checklist" "docs/i/checklists/validation-checklist.md"
                ;;
            7)
                print_warning "Syncing ALL template files. This may overwrite your customizations."
                read -p "Are you sure? (y/n) " -n 1 -r
                echo ""
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    git checkout template/main -- .claude/
                    git checkout template/main -- docs/i/phases/
                    git checkout template/main -- docs/i/checklists/
                    print_success "Synced all template files"
                fi
                ;;
            8)
                print_info "Cancelled"
                exit 0
                ;;
            *)
                print_error "Invalid option"
                exit 1
                ;;
        esac
        ;;
    *)
        print_error "Unknown component: $COMPONENT"
        echo ""
        echo "Valid components: all, skills, commands, rules, icons, docs, validator"
        exit 1
        ;;
esac

echo ""
print_info "Don't forget to review changes and commit:"
echo ""
echo "  git status"
echo "  git diff --cached"
echo "  git commit -m 'Sync template updates'"
echo ""
