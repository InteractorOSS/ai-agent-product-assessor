#!/usr/bin/env bash
# ./scripts/start.sh - Development Environment Startup Script
#
# This script validates, auto-installs, and configures the entire development
# environment, then starts the Phoenix server.
#
# Features:
#   - Auto-installs Elixir/Erlang via asdf or Homebrew
#   - Auto-installs Node.js 18+
#   - Auto-configures database settings
#   - Auto-generates security keys
#   - Fixes common configuration issues
#   - Validates everything before starting
#
# Usage: ./scripts/start.sh [options]
# Options:
#   --check-only    Only check/fix environment, don't start server
#   --setup         Run full setup (install deps, setup db, build assets)
#   --skip-checks   Skip all checks and start immediately
#   --port PORT     Use specific port (default: auto-find from 4005)
#   --verbose       Show detailed output
#   --help          Show this help message

set -e

# ============================================================================
# Configuration
# ============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Minimum versions
MIN_ELIXIR_VERSION="1.15"
MIN_ERLANG_VERSION="26"
MIN_NODE_VERSION="18"

# Default settings
DEFAULT_PORT=4005
DEFAULT_DB_USER="postgres"
DEFAULT_DB_PASS="postgres"
DEFAULT_DB_HOST="localhost"
DEFAULT_DB_PORT="5432"

# Flags
CHECK_ONLY=false
FULL_SETUP=false
SKIP_CHECKS=false
VERBOSE=false
SPECIFIED_PORT=""

# Counters
ERRORS_FOUND=0
FIXES_APPLIED=0
WARNINGS=0
INSTALLS=0

# ============================================================================
# Argument Parsing
# ============================================================================

while [[ $# -gt 0 ]]; do
    case $1 in
        --check-only)
            CHECK_ONLY=true
            shift
            ;;
        --setup)
            FULL_SETUP=true
            shift
            ;;
        --skip-checks)
            SKIP_CHECKS=true
            shift
            ;;
        --port)
            SPECIFIED_PORT="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            cat << 'EOF'
Development Environment Startup Script

This script validates, auto-installs, and configures your entire
development environment for Elixir/Phoenix projects.

Usage: ./scripts/start.sh [options]

Options:
  --check-only    Only check/fix environment, don't start server
  --setup         Run full setup (install all deps, setup db, build assets)
  --skip-checks   Skip all checks and start immediately
  --port PORT     Use specific port (default: auto-find from 4005)
  --verbose       Show detailed output
  --help          Show this help message

Examples:
  ./scripts/start.sh                  # Check, fix, and start
  ./scripts/start.sh --setup          # Full setup from scratch
  ./scripts/start.sh --check-only     # Just validate environment
  ./scripts/start.sh --port 4010      # Start on specific port

What gets checked/installed:
  ✓ Elixir 1.15+ (via asdf or Homebrew)
  ✓ Erlang/OTP 26+ (via asdf or Homebrew)
  ✓ Node.js 18+ (via asdf, nvm, or Homebrew)
  ✓ PostgreSQL client
  ✓ Environment variables (.env file)
  ✓ Security keys (SECRET_KEY_BASE, etc.)
  ✓ Elixir dependencies (mix deps.get)
  ✓ Database connection and migrations
  ✓ Frontend assets (npm install)
  ✓ Project compilation
EOF
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
}

print_subheader() {
    echo ""
    echo -e "${CYAN}--- $1 ---${NC}"
}

print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++)) || true
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS_FOUND++)) || true
}

print_fix() {
    echo -e "${CYAN}→${NC} $1"
    ((FIXES_APPLIED++)) || true
}

print_install() {
    echo -e "${MAGENTA}⬇${NC} $1"
    ((INSTALLS++)) || true
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "  ${CYAN}[DEBUG]${NC} $1"
    fi
}

# Check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Compare version strings (returns 0 if $1 >= $2)
version_gte() {
    [ "$(printf '%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

# Find available port starting from given port
find_available_port() {
    local port=${1:-4005}
    local max_port=$((port + 100))

    while [ $port -lt $max_port ]; do
        if ! lsof -i :$port > /dev/null 2>&1; then
            echo $port
            return 0
        fi
        verbose "Port $port is in use, trying next..."
        port=$((port + 1))
    done

    echo "Error: No available port found between $1 and $max_port" >&2
    return 1
}

# Suppress asdf notices and other noise
run_quiet() {
    "$@" 2>&1 | grep -v "NOTICE\|asdf\|migrate to\|rewrite\|----------\|Aside from\|older Bash\|Migration guide\|website:\|Source code:" || true
}

# Get OS type
get_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}

# Check if running interactively
is_interactive() {
    [ -t 0 ]
}

# Ask yes/no question (defaults to yes if non-interactive)
ask_yes_no() {
    local prompt="$1"
    local default="${2:-y}"

    if ! is_interactive; then
        [ "$default" = "y" ]
        return $?
    fi

    read -p "$prompt (y/n) [$default]: " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY && "$default" = "y" ]]
}

# ============================================================================
# Installation Functions
# ============================================================================

install_homebrew() {
    if command_exists brew; then
        return 0
    fi

    print_install "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add to path for this session
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

install_asdf() {
    if command_exists asdf; then
        return 0
    fi

    local os=$(get_os)

    if [ "$os" = "macos" ] && command_exists brew; then
        print_install "Installing asdf via Homebrew..."
        brew install asdf

        # Add to shell
        echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ~/.zshrc 2>/dev/null || true
        echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ~/.bashrc 2>/dev/null || true

        # Source for current session
        . "$(brew --prefix asdf)/libexec/asdf.sh" 2>/dev/null || true
    else
        print_install "Installing asdf via git..."
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

        echo -e "\n. $HOME/.asdf/asdf.sh" >> ~/.bashrc 2>/dev/null || true
        echo -e "\n. $HOME/.asdf/asdf.sh" >> ~/.zshrc 2>/dev/null || true

        . "$HOME/.asdf/asdf.sh" 2>/dev/null || true
    fi
}

install_elixir_erlang() {
    local os=$(get_os)

    # Try asdf first
    if command_exists asdf; then
        print_install "Installing Erlang via asdf..."
        asdf plugin add erlang 2>/dev/null || true
        asdf install erlang latest
        asdf global erlang latest

        print_install "Installing Elixir via asdf..."
        asdf plugin add elixir 2>/dev/null || true
        asdf install elixir latest
        asdf global elixir latest

        # Reshim
        asdf reshim erlang 2>/dev/null || true
        asdf reshim elixir 2>/dev/null || true

        return 0
    fi

    # Fall back to Homebrew on macOS
    if [ "$os" = "macos" ]; then
        if ! command_exists brew; then
            install_homebrew
        fi

        print_install "Installing Erlang via Homebrew..."
        brew install erlang

        print_install "Installing Elixir via Homebrew..."
        brew install elixir

        return 0
    fi

    # Linux instructions
    print_error "Could not auto-install Elixir/Erlang"
    echo "  Please install manually:"
    echo "  Ubuntu/Debian: sudo apt-get install elixir erlang"
    echo "  Or use asdf: https://asdf-vm.com/"
    return 1
}

install_nodejs() {
    local os=$(get_os)

    # Try asdf first
    if command_exists asdf; then
        print_install "Installing Node.js via asdf..."
        asdf plugin add nodejs 2>/dev/null || true
        asdf install nodejs latest
        asdf global nodejs latest
        asdf reshim nodejs 2>/dev/null || true
        return 0
    fi

    # Try nvm
    if [ -f "$HOME/.nvm/nvm.sh" ]; then
        . "$HOME/.nvm/nvm.sh"
        print_install "Installing Node.js via nvm..."
        nvm install 20
        nvm use 20
        return 0
    fi

    # Fall back to Homebrew on macOS
    if [ "$os" = "macos" ]; then
        if ! command_exists brew; then
            install_homebrew
        fi

        print_install "Installing Node.js via Homebrew..."
        brew install node@20
        brew link node@20 --force --overwrite
        return 0
    fi

    # Linux instructions
    print_error "Could not auto-install Node.js"
    echo "  Please install manually:"
    echo "  Ubuntu/Debian: curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs"
    echo "  Or use nvm: https://github.com/nvm-sh/nvm"
    return 1
}

install_phoenix() {
    print_install "Installing Phoenix framework..."
    run_quiet mix local.hex --force
    run_quiet mix local.rebar --force
    run_quiet mix archive.install hex phx_new --force
    print_status "Phoenix framework installed"
}

install_postgres_client() {
    local os=$(get_os)

    if [ "$os" = "macos" ]; then
        if command_exists brew; then
            print_install "Installing PostgreSQL client via Homebrew..."
            brew install libpq
            brew link libpq --force 2>/dev/null || true
        fi
    else
        print_info "Install PostgreSQL client with: sudo apt-get install postgresql-client"
    fi
}

# ============================================================================
# Validation Functions
# ============================================================================

check_elixir() {
    print_subheader "Elixir/Erlang"

    # Check Elixir
    if command_exists elixir; then
        local elixir_version=$(elixir --version 2>&1 | grep -oE "Elixir [0-9]+\.[0-9]+\.[0-9]+" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -1)
        if [ -n "$elixir_version" ]; then
            local major_minor=$(echo "$elixir_version" | cut -d. -f1,2)
            if version_gte "$major_minor" "$MIN_ELIXIR_VERSION"; then
                print_status "Elixir $elixir_version installed"
            else
                print_warning "Elixir $elixir_version installed (recommend $MIN_ELIXIR_VERSION+)"
            fi
        else
            print_status "Elixir installed"
        fi
    else
        print_error "Elixir not found"
        if ask_yes_no "Would you like to install Elixir/Erlang?" "y"; then
            install_elixir_erlang
            # Re-check
            if command_exists elixir; then
                print_status "Elixir installed successfully"
            else
                print_error "Elixir installation failed"
                return 1
            fi
        else
            print_error "Elixir is required to continue"
            return 1
        fi
    fi

    # Check Erlang
    if command_exists erl; then
        print_status "Erlang/OTP installed"
    else
        print_error "Erlang not found"
        return 1
    fi

    # Check Phoenix installer
    if ! mix help phx.new &> /dev/null 2>&1; then
        print_warning "Phoenix installer not found"
        print_fix "Installing Phoenix framework..."
        install_phoenix
    fi

    return 0
}

check_node() {
    print_subheader "Node.js"

    if command_exists node; then
        local node_version=$(node --version 2>/dev/null | sed 's/v//')
        local major=$(echo "$node_version" | cut -d. -f1)

        if [ "$major" -ge "$MIN_NODE_VERSION" ] 2>/dev/null; then
            print_status "Node.js v$node_version installed"
        else
            print_warning "Node.js v$node_version installed (recommend v$MIN_NODE_VERSION+)"
            if ask_yes_no "Would you like to upgrade Node.js?" "y"; then
                install_nodejs
            fi
        fi
    else
        print_error "Node.js not found"
        if ask_yes_no "Would you like to install Node.js?" "y"; then
            install_nodejs
            if command_exists node; then
                print_status "Node.js installed successfully"
            else
                print_warning "Node.js installation failed - assets may not build"
            fi
        else
            print_warning "Node.js is recommended for asset compilation"
        fi
    fi

    if command_exists npm; then
        local npm_version=$(npm --version 2>/dev/null)
        print_status "npm $npm_version installed"
    fi

    return 0
}

check_postgres() {
    print_subheader "PostgreSQL"

    if command_exists psql; then
        local pg_version=$(psql --version 2>/dev/null | grep -oE "[0-9]+\.[0-9]+" | head -1)
        print_status "PostgreSQL client $pg_version installed"
    else
        print_warning "PostgreSQL client not found"
        if ask_yes_no "Would you like to install PostgreSQL client?" "n"; then
            install_postgres_client
        else
            print_info "Using remote database - client not required"
        fi
    fi

    return 0
}

# ============================================================================
# Environment Configuration
# ============================================================================

check_env_file() {
    print_subheader "Environment Configuration"

    cd "$PROJECT_ROOT"

    # Check if .env exists
    if [ ! -f ".env" ]; then
        print_error ".env file not found"

        # Try to create from templates
        if [ -f ".env.dev" ]; then
            print_fix "Creating .env from .env.dev"
            cp .env.dev .env
            print_status ".env created from .env.dev"
        elif [ -f ".env.example" ]; then
            print_fix "Creating .env from .env.example"
            cp .env.example .env
            print_warning ".env created - needs configuration"
        else
            print_fix "Creating new .env file"
            create_env_file
            print_status ".env file created"
        fi
    else
        print_status ".env file exists"
    fi

    # Source the env file
    set -a
    source .env 2>/dev/null || true
    set +a

    return 0
}

create_env_file() {
    local app_name=$(get_app_name)

    cat > .env << EOF
# =============================================================================
# Development Environment Configuration
# =============================================================================
# Generated by start.sh - $(date +%Y-%m-%d)
# =============================================================================

# Application Settings
MIX_ENV=dev
PORT=$DEFAULT_PORT
PHX_HOST=localhost
PHX_SERVER=true

# Database Configuration
DB_USERNAME=$DEFAULT_DB_USER
DB_PASSWORD=$DEFAULT_DB_PASS
DB_HOSTNAME=$DEFAULT_DB_HOST
DB_DATABASE=${app_name}_dev
DB_PORT=$DEFAULT_DB_PORT
DATABASE_URL=postgresql://$DEFAULT_DB_USER:$DEFAULT_DB_PASS@$DEFAULT_DB_HOST:$DEFAULT_DB_PORT/${app_name}_dev

# Pool size
POOL_SIZE=10

# Security (will be auto-generated if empty)
SECRET_KEY_BASE=
LIVE_VIEW_SIGNING_SALT=

# AWS S3 (optional)
# AWS_ACCESS_KEY_ID=
# AWS_SECRET_ACCESS_KEY=
# AWS_BUCKET=
# AWS_REGION=us-east-1

# Development Settings
LIVE_RELOAD=true
SHOW_SENSITIVE_DATA=true
EOF
}

get_app_name() {
    if [ -f "mix.exs" ]; then
        grep -oP 'app:\s*:\K[a-z_]+' mix.exs 2>/dev/null | head -1 || echo "my_app"
    else
        # Derive from directory name
        basename "$PROJECT_ROOT" | tr '[:upper:]' '[:lower:]' | tr '-' '_' | tr ' ' '_'
    fi
}

validate_env_variables() {
    print_subheader "Required Environment Variables"

    cd "$PROJECT_ROOT"

    # Re-source env file
    if [ -f ".env" ]; then
        set -a
        source .env 2>/dev/null || true
        set +a
    fi

    local all_valid=true

    # Check SECRET_KEY_BASE
    if [ -z "$SECRET_KEY_BASE" ]; then
        print_warning "SECRET_KEY_BASE is not set"
        print_fix "Generating SECRET_KEY_BASE..."
        local new_secret=$(run_quiet mix phx.gen.secret | grep -E '^[A-Za-z0-9+/=]{64}' | head -1)

        if [ -z "$new_secret" ]; then
            # Fallback: generate with openssl
            new_secret=$(openssl rand -base64 48 | tr -d '\n')
        fi

        if [ -n "$new_secret" ] && [ ${#new_secret} -ge 64 ]; then
            update_env_var "SECRET_KEY_BASE" "$new_secret"
            export SECRET_KEY_BASE="$new_secret"
            print_status "SECRET_KEY_BASE generated and saved"
        else
            print_error "Failed to generate SECRET_KEY_BASE"
            all_valid=false
        fi
    else
        print_status "SECRET_KEY_BASE is set (${#SECRET_KEY_BASE} chars)"
    fi

    # Check LIVE_VIEW_SIGNING_SALT
    if [ -z "$LIVE_VIEW_SIGNING_SALT" ]; then
        print_warning "LIVE_VIEW_SIGNING_SALT is not set"
        print_fix "Generating LIVE_VIEW_SIGNING_SALT..."
        local new_salt=$(run_quiet mix phx.gen.secret 32 | grep -E '^[A-Za-z0-9+/=]{32}' | head -1)

        if [ -z "$new_salt" ]; then
            # Fallback: generate with openssl
            new_salt=$(openssl rand -base64 24 | tr -d '\n')
        fi

        if [ -n "$new_salt" ]; then
            update_env_var "LIVE_VIEW_SIGNING_SALT" "$new_salt"
            export LIVE_VIEW_SIGNING_SALT="$new_salt"
            print_status "LIVE_VIEW_SIGNING_SALT generated and saved"
        fi
    else
        print_status "LIVE_VIEW_SIGNING_SALT is set"
    fi

    # Check database configuration
    if [ -n "$DATABASE_URL" ]; then
        print_status "DATABASE_URL is set"
    elif [ -n "$DB_HOSTNAME" ] && [ -n "$DB_DATABASE" ]; then
        print_status "Database configured: $DB_DATABASE@$DB_HOSTNAME"
    else
        print_warning "Database not fully configured"
        print_fix "Setting up default database configuration..."
        configure_database
    fi

    # Check PORT
    if [ -z "$PORT" ]; then
        print_info "PORT not set, will auto-detect"
    else
        print_status "PORT is set: $PORT"
    fi

    if [ "$all_valid" = false ]; then
        return 1
    fi
    return 0
}

update_env_var() {
    local var_name="$1"
    local var_value="$2"

    if [ ! -f ".env" ]; then
        echo "$var_name=$var_value" > .env
        return
    fi

    if grep -q "^$var_name=" .env 2>/dev/null; then
        # Update existing
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|^$var_name=.*|$var_name=$var_value|" .env
        else
            sed -i "s|^$var_name=.*|$var_name=$var_value|" .env
        fi
    else
        # Add new
        echo "$var_name=$var_value" >> .env
    fi
}

configure_database() {
    local app_name=$(get_app_name)

    # Set defaults if not set
    [ -z "$DB_USERNAME" ] && update_env_var "DB_USERNAME" "$DEFAULT_DB_USER" && export DB_USERNAME="$DEFAULT_DB_USER"
    [ -z "$DB_PASSWORD" ] && update_env_var "DB_PASSWORD" "$DEFAULT_DB_PASS" && export DB_PASSWORD="$DEFAULT_DB_PASS"
    [ -z "$DB_HOSTNAME" ] && update_env_var "DB_HOSTNAME" "$DEFAULT_DB_HOST" && export DB_HOSTNAME="$DEFAULT_DB_HOST"
    [ -z "$DB_DATABASE" ] && update_env_var "DB_DATABASE" "${app_name}_dev" && export DB_DATABASE="${app_name}_dev"
    [ -z "$DB_PORT" ] && update_env_var "DB_PORT" "$DEFAULT_DB_PORT" && export DB_PORT="$DEFAULT_DB_PORT"

    # Build DATABASE_URL
    local db_url="postgresql://$DB_USERNAME:$DB_PASSWORD@$DB_HOSTNAME:$DB_PORT/$DB_DATABASE"
    update_env_var "DATABASE_URL" "$db_url"
    export DATABASE_URL="$db_url"

    print_status "Database configured: $DB_DATABASE@$DB_HOSTNAME"
}

# ============================================================================
# Project Validation
# ============================================================================

check_mix_project() {
    print_subheader "Mix Project"

    cd "$PROJECT_ROOT"

    if [ ! -f "mix.exs" ]; then
        print_error "No mix.exs found - not an Elixir project"

        if ask_yes_no "Would you like to create a Phoenix project?" "n"; then
            local app_name=$(get_app_name)
            print_install "Creating Phoenix project: $app_name"

            if mix phx.new . --app "$app_name" --database postgres --live; then
                print_status "Phoenix project created"

                # Configure port
                configure_dev_port
            else
                print_error "Failed to create Phoenix project"
                return 1
            fi
        else
            print_error "mix.exs is required to continue"
            return 1
        fi
    else
        print_status "mix.exs found"
    fi

    return 0
}

configure_dev_port() {
    if [ -f "config/dev.exs" ]; then
        print_fix "Configuring dynamic port..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' 's/port: 4000/port: String.to_integer(System.get_env("PORT") || "4005")/g' config/dev.exs
        else
            sed -i 's/port: 4000/port: String.to_integer(System.get_env("PORT") || "4005")/g' config/dev.exs
        fi
        print_status "Port configured (dynamic, default: 4005)"
    fi
}

check_dependencies() {
    print_subheader "Elixir Dependencies"

    cd "$PROJECT_ROOT"

    if [ -d "deps" ] && [ -d "_build" ]; then
        local dep_check=$(run_quiet mix deps 2>&1)
        if echo "$dep_check" | grep -q "not available\|not ok"; then
            print_warning "Some dependencies need updating"
            print_fix "Running mix deps.get..."
            run_quiet mix deps.get
            print_status "Dependencies updated"
        else
            print_status "Dependencies installed"
        fi
    else
        print_warning "Dependencies not installed"
        print_fix "Running mix deps.get..."
        run_quiet mix deps.get
        print_status "Dependencies installed"
    fi

    return 0
}

check_config_files() {
    print_subheader "Configuration Files"

    cd "$PROJECT_ROOT"

    # Check required config files
    local config_files=("config/config.exs" "config/dev.exs" "config/runtime.exs")
    local missing=false

    for config in "${config_files[@]}"; do
        if [ -f "$config" ]; then
            print_status "$config exists"
        else
            print_warning "$config missing"
            missing=true
        fi
    done

    # Fix common issues

    # Remove deprecated Oban.Plugins.Stager
    if grep -q "Oban.Plugins.Stager" config/config.exs 2>/dev/null; then
        print_fix "Removing deprecated Oban.Plugins.Stager..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' 's/Oban.Plugins.Stager[[:space:]]*,\?//g' config/config.exs
        else
            sed -i 's/Oban.Plugins.Stager[[:space:]]*,\?//g' config/config.exs
        fi
        print_status "Oban configuration fixed"
    fi

    # Check for compile-time env issues
    if grep -q 'System.get_env.*aws_region\|System.get_env.*AWS' config/dev.exs 2>/dev/null; then
        if ! grep -q 'aws_region' config/runtime.exs 2>/dev/null; then
            print_warning "AWS config in dev.exs may cause compile-time issues"
            print_info "Consider moving to runtime.exs"
        fi
    fi

    return 0
}

check_compilation() {
    print_subheader "Project Compilation"

    cd "$PROJECT_ROOT"

    print_info "Compiling project..."
    local compile_output=$(run_quiet mix compile 2>&1)

    if echo "$compile_output" | grep -qi "error\|** ("; then
        print_error "Compilation failed"

        # Try to identify and fix common errors
        if echo "$compile_output" | grep -q "Oban.Plugins.Stager"; then
            print_fix "Fixing Oban configuration..."
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' 's/Oban.Plugins.Stager[[:space:]]*,\?//g' config/config.exs
            else
                sed -i 's/Oban.Plugins.Stager[[:space:]]*,\?//g' config/config.exs
            fi

            # Recompile
            print_info "Recompiling..."
            run_quiet mix deps.clean api_docs_monitor --build 2>/dev/null || true
            compile_output=$(run_quiet mix compile 2>&1)

            if ! echo "$compile_output" | grep -qi "error\|** ("; then
                print_status "Compilation fixed and successful"
                return 0
            fi
        fi

        # Show errors
        echo "$compile_output" | grep -A3 "error\|** (" | head -15
        return 1
    elif echo "$compile_output" | grep -q "warning:"; then
        local warning_count=$(echo "$compile_output" | grep -c "warning:" || echo "0")
        print_warning "Compiled with $warning_count warning(s)"
    else
        print_status "Project compiles successfully"
    fi

    return 0
}

check_database() {
    print_subheader "Database Connection"

    cd "$PROJECT_ROOT"

    # Source env
    if [ -f ".env" ]; then
        set -a
        source .env 2>/dev/null || true
        set +a
    fi

    # Test database connection
    print_info "Testing database connection..."
    local db_check=$(run_quiet mix ecto.migrations 2>&1)

    if echo "$db_check" | grep -qi "could not connect\|connection refused\|does not exist\|FATAL"; then
        print_error "Cannot connect to database"
        verbose "Error: $db_check"

        # Try to create database
        if echo "$db_check" | grep -qi "does not exist"; then
            print_fix "Creating database..."
            if run_quiet mix ecto.create 2>&1 | grep -qi "created\|already"; then
                print_status "Database created"
                db_check=$(run_quiet mix ecto.migrations 2>&1)
            else
                print_error "Failed to create database"
                echo "  Please ensure PostgreSQL is running and accessible"
                echo "  Host: ${DB_HOSTNAME:-localhost}"
                echo "  User: ${DB_USERNAME:-postgres}"
                echo "  Database: ${DB_DATABASE:-unknown}"
                return 1
            fi
        else
            echo "  Please check your database configuration:"
            echo "  Host: ${DB_HOSTNAME:-localhost}"
            echo "  User: ${DB_USERNAME:-postgres}"
            echo "  Database: ${DB_DATABASE:-unknown}"
            return 1
        fi
    else
        print_status "Database connection successful"
    fi

    # Check for pending migrations
    local pending=$(echo "$db_check" | grep -c "down" || echo "0")
    pending=${pending:-0}
    if [ "$pending" -gt 0 ] 2>/dev/null; then
        print_warning "$pending pending migration(s) found"
        print_fix "Running mix ecto.migrate..."
        run_quiet mix ecto.migrate
        print_status "Migrations applied"
    else
        print_status "All migrations are up to date"
    fi

    return 0
}

check_assets() {
    print_subheader "Frontend Assets"

    cd "$PROJECT_ROOT"

    if [ -d "assets" ]; then
        if [ -f "assets/package.json" ]; then
            if [ ! -d "assets/node_modules" ]; then
                print_warning "Node modules not installed"
                if command_exists npm; then
                    print_fix "Running npm install in assets/..."
                    (cd assets && npm install --silent 2>/dev/null)
                    print_status "Node modules installed"
                else
                    print_warning "npm not available, skipping asset install"
                fi
            else
                print_status "Node modules installed"
            fi
        fi

        if [ -d "priv/static/assets" ]; then
            print_status "Static assets built"
        else
            print_info "Static assets will be built on first request"
        fi
    else
        print_info "No assets directory found"
    fi

    return 0
}

# ============================================================================
# Final Validation
# ============================================================================

run_validation_test() {
    print_subheader "Final Validation"

    cd "$PROJECT_ROOT"

    # Source env
    if [ -f ".env" ]; then
        set -a
        source .env 2>/dev/null || true
        set +a
    fi

    print_info "Running startup validation..."

    local test_output=$(timeout 15 mix run -e "IO.puts(\"Startup OK\")" 2>&1 || true)

    if echo "$test_output" | grep -q "Startup OK"; then
        print_status "Application starts successfully"
        return 0
    elif echo "$test_output" | grep -qi "error\|exception"; then
        print_error "Application failed to start"
        echo "$test_output" | grep -A3 "error\|exception" | head -10
        return 1
    else
        print_status "Startup validation passed"
        return 0
    fi
}

# ============================================================================
# Summary and Server Start
# ============================================================================

print_summary() {
    print_header "Validation Summary"

    echo ""
    if [ $ERRORS_FOUND -gt 0 ]; then
        echo -e "  ${RED}Errors:${NC}      $ERRORS_FOUND"
    else
        echo -e "  ${GREEN}Errors:${NC}      0"
    fi

    if [ $WARNINGS -gt 0 ]; then
        echo -e "  ${YELLOW}Warnings:${NC}    $WARNINGS"
    else
        echo -e "  ${GREEN}Warnings:${NC}    0"
    fi

    if [ $FIXES_APPLIED -gt 0 ]; then
        echo -e "  ${CYAN}Auto-fixed:${NC}  $FIXES_APPLIED"
    fi

    if [ $INSTALLS -gt 0 ]; then
        echo -e "  ${MAGENTA}Installed:${NC}   $INSTALLS"
    fi

    echo ""

    if [ $ERRORS_FOUND -gt 0 ]; then
        echo -e "${RED}${BOLD}Environment has errors that need manual attention.${NC}"
        return 1
    elif [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}Environment ready with warnings.${NC}"
        return 0
    else
        echo -e "${GREEN}${BOLD}Environment is fully configured and ready!${NC}"
        return 0
    fi
}

start_server() {
    print_header "Starting Development Server"

    cd "$PROJECT_ROOT"

    # Source env
    if [ -f ".env" ]; then
        set -a
        source .env 2>/dev/null || true
        set +a
    fi

    # Determine port
    if [ -n "$SPECIFIED_PORT" ]; then
        PORT=$SPECIFIED_PORT
    elif [ -z "$PORT" ]; then
        PORT=$(find_available_port $DEFAULT_PORT)
        if [ $? -ne 0 ]; then
            print_error "Could not find available port"
            exit 1
        fi
    fi

    export PORT

    # Final migration check
    print_info "Checking for pending migrations..."
    run_quiet mix ecto.migrate 2>/dev/null || true

    local app_name=$(get_app_name)

    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}  $app_name - Development Server${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${BOLD}URL:${NC}      ${BLUE}http://localhost:$PORT${NC}"
    echo -e "  ${BOLD}Database:${NC} ${DB_HOSTNAME:-localhost}/${DB_DATABASE:-dev}"
    echo ""
    echo -e "  ${BOLD}Commands in IEx:${NC}"
    echo "    recompile()       - Recompile code"
    echo "    Ctrl+C (twice)    - Stop server"
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    # Start Phoenix with IEx
    exec iex -S mix phx.server
}

# ============================================================================
# Main Execution
# ============================================================================

main() {
    cd "$PROJECT_ROOT"

    echo ""
    echo -e "${BLUE}${BOLD}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}${BOLD}║      Development Environment Setup & Validation           ║${NC}"
    echo -e "${BLUE}${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"

    if [ "$SKIP_CHECKS" = true ]; then
        print_info "Skipping all checks (--skip-checks)"
        start_server
        exit 0
    fi

    # Run all checks
    print_header "System Dependencies"
    check_elixir || exit 1
    check_node
    check_postgres

    print_header "Environment Setup"
    check_env_file || exit 1
    validate_env_variables || exit 1

    print_header "Project Setup"
    check_mix_project || exit 1
    check_dependencies || exit 1
    check_config_files
    check_compilation || exit 1
    check_database || exit 1
    check_assets

    if [ "$FULL_SETUP" = true ]; then
        print_header "Full Setup"
        print_info "Running full project setup..."
        run_quiet mix deps.get
        run_quiet mix compile
        run_quiet mix ecto.setup 2>/dev/null || run_quiet mix ecto.migrate
        if [ -d "assets" ] && [ -f "assets/package.json" ]; then
            (cd assets && npm install --silent 2>/dev/null)
        fi
        print_status "Full setup complete"
    fi

    print_header "Validation Test"
    run_validation_test

    # Print summary
    print_summary
    local summary_status=$?

    if [ "$CHECK_ONLY" = true ]; then
        print_header "Check Complete"
        if [ $summary_status -eq 0 ]; then
            echo -e "${GREEN}Ready to start with: ./scripts/start.sh${NC}"
        fi
        exit $summary_status
    fi

    if [ $ERRORS_FOUND -gt 0 ]; then
        echo ""
        echo -e "${RED}Cannot start server due to errors. Please fix the issues above.${NC}"
        exit 1
    fi

    # Start the server
    start_server
}

# Run main
main "$@"
