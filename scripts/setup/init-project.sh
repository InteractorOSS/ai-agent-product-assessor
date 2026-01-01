#!/bin/bash
#
# Initialize a new project from the product development template
#
# Usage: ./init-project.sh <project-name> [project-type]
#
# Project types: web, mobile, backend, cli
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print with color
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
echo -e "${GREEN}║     Product Development Template - Project Initializer    ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check for required arguments
if [ -z "$1" ]; then
    print_error "Project name is required"
    echo ""
    echo "Usage: ./init-project.sh <project-name> [project-type]"
    echo ""
    echo "Project types:"
    echo "  web      - Web application (React, Vue, etc.)"
    echo "  mobile   - Mobile application (React Native, Flutter)"
    echo "  backend  - Backend/API service (Node.js, Python, Go)"
    echo "  cli      - Command-line tool"
    echo ""
    echo "Examples:"
    echo "  ./init-project.sh my-app"
    echo "  ./init-project.sh my-api backend"
    echo "  ./init-project.sh my-mobile-app mobile"
    exit 1
fi

PROJECT_NAME=$1
PROJECT_TYPE=${2:-"web"}

# Validate project name
if [[ ! "$PROJECT_NAME" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
    print_error "Invalid project name: $PROJECT_NAME"
    echo "Project name must start with a letter and contain only letters, numbers, hyphens, and underscores."
    exit 1
fi

# Validate project type
case $PROJECT_TYPE in
    web|mobile|backend|cli)
        ;;
    *)
        print_error "Invalid project type: $PROJECT_TYPE"
        echo "Valid options: web, mobile, backend, cli"
        exit 1
        ;;
esac

print_info "Initializing project: ${GREEN}$PROJECT_NAME${NC}"
print_info "Project type: ${GREEN}$PROJECT_TYPE${NC}"
echo ""

# Get the script's directory (template root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Update CLAUDE.md with project info
print_info "Configuring CLAUDE.md..."

if [ -f "CLAUDE.md" ]; then
    # macOS compatible sed
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/\[Your Project Name\]/$PROJECT_NAME/g" CLAUDE.md
        sed -i '' "s/\[web | mobile | backend | cli\]/$PROJECT_TYPE/g" CLAUDE.md
    else
        sed -i "s/\[Your Project Name\]/$PROJECT_NAME/g" CLAUDE.md
        sed -i "s/\[web | mobile | backend | cli\]/$PROJECT_TYPE/g" CLAUDE.md
    fi
    print_success "CLAUDE.md updated with project info"
else
    print_warning "CLAUDE.md not found, skipping update"
fi

# Append project-type specific configuration
print_info "Applying $PROJECT_TYPE configuration..."

if [ -f "config/$PROJECT_TYPE/CLAUDE.local.md" ]; then
    echo "" >> CLAUDE.md
    echo "---" >> CLAUDE.md
    echo "" >> CLAUDE.md
    echo "## Platform-Specific Configuration" >> CLAUDE.md
    echo "" >> CLAUDE.md
    cat "config/$PROJECT_TYPE/CLAUDE.local.md" >> CLAUDE.md
    print_success "Platform-specific configuration added"
else
    print_warning "Platform config not found at config/$PROJECT_TYPE/CLAUDE.local.md"
fi

# Create .claude/settings.local.json from example if not exists
print_info "Setting up local configuration..."

if [ -f ".claude/settings.local.json.example" ] && [ ! -f ".claude/settings.local.json" ]; then
    cp .claude/settings.local.json.example .claude/settings.local.json
    print_success "Created .claude/settings.local.json from example"
else
    print_info "Local settings already exist or example not found"
fi

# Create .env from example if not exists
if [ -f ".env.example" ] && [ ! -f ".env" ]; then
    cp .env.example .env
    print_success "Created .env from .env.example"
    print_warning "Remember to configure your .env file with actual values"
else
    print_info ".env already exists or .env.example not found"
fi

# Initialize git if not already
if [ ! -d ".git" ]; then
    print_info "Initializing git repository..."
    git init > /dev/null 2>&1
    print_success "Git repository initialized"
else
    print_info "Git repository already exists"
fi

# Make an initial commit if repo is fresh
if [ -d ".git" ]; then
    COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    if [ "$COMMIT_COUNT" = "0" ]; then
        print_info "Creating initial commit..."
        git add -A
        git commit -m "Initial commit from product-dev-template

Project: $PROJECT_NAME
Type: $PROJECT_TYPE

🤖 Generated with product-dev-template" > /dev/null 2>&1
        print_success "Initial commit created"
    fi
fi

# Store template origin for future updates
TEMPLATE_ORIGIN=${TEMPLATE_ORIGIN:-"https://github.com/pulzze/product-dev-template.git"}

print_info "Setting up template sync..."
if [ -d ".git" ]; then
    # Add template as upstream remote for future updates
    git remote add template "$TEMPLATE_ORIGIN" 2>/dev/null || true
    print_success "Template remote added (for pulling future updates)"
fi

# Create project-specific feedback log
print_info "Creating feedback tracking..."
if [ -f "docs/i/templates/template-feedback.md" ]; then
    cp docs/i/templates/template-feedback.md docs/template-feedback.md
    # Update with project info
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/\[Your project name\]/$PROJECT_NAME/g" docs/template-feedback.md
        sed -i '' "s/\[web \/ mobile \/ backend \/ cli\]/$PROJECT_TYPE/g" docs/template-feedback.md
        sed -i '' "s/\[YYYY-MM-DD\]/$(date +%Y-%m-%d)/g" docs/template-feedback.md
    else
        sed -i "s/\[Your project name\]/$PROJECT_NAME/g" docs/template-feedback.md
        sed -i "s/\[web \/ mobile \/ backend \/ cli\]/$PROJECT_TYPE/g" docs/template-feedback.md
        sed -i "s/\[YYYY-MM-DD\]/$(date +%Y-%m-%d)/g" docs/template-feedback.md
    fi
    print_success "Created docs/template-feedback.md for tracking improvements"
fi

# Offer Phoenix project initialization for web/backend types
if [[ "$PROJECT_TYPE" == "web" || "$PROJECT_TYPE" == "backend" ]]; then
    echo ""
    print_info "This template is configured for Elixir/Phoenix projects."
    echo ""
    read -p "Would you like to initialize a Phoenix project now? (y/n) " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Convert project name to snake_case for Elixir
        APP_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_' | tr ' ' '_')

        print_info "Creating Phoenix project: $APP_NAME"
        echo ""

        # Check if Elixir/Mix is available
        if ! command -v mix &> /dev/null; then
            print_error "Elixir/Mix not found. Please install Elixir first."
            print_info "Visit: https://elixir-lang.org/install.html"
            print_warning "You can create the Phoenix project later during /start-planning"
        else
            # Check if phx.new is available
            if mix help phx.new &> /dev/null; then
                print_info "Running: mix phx.new . --app $APP_NAME --database postgres --live"
                echo ""

                if mix phx.new . --app "$APP_NAME" --database postgres --live; then
                    print_success "Phoenix project created successfully!"
                    echo ""

                    # Configure development port to use PORT env var with 4005 default
                    if [ -f "config/dev.exs" ]; then
                        print_info "Configuring dynamic port (default: 4005)..."
                        # Replace static port with dynamic PORT env var
                        if [[ "$OSTYPE" == "darwin"* ]]; then
                            sed -i '' 's/port: 4000/port: String.to_integer(System.get_env("PORT") || "4005")/g' config/dev.exs
                        else
                            sed -i 's/port: 4000/port: String.to_integer(System.get_env("PORT") || "4005")/g' config/dev.exs
                        fi
                        print_success "Development port configured (dynamic, default: 4005)"
                    fi

                    # Install dependencies
                    print_info "Installing dependencies..."
                    mix deps.get

                    print_success "Phoenix project ready!"
                    echo ""
                    print_info "Run 'mix ecto.create' to create the database"
                    print_info "Run 'mix phx.server' to start the server (localhost:4005)"
                else
                    print_error "Failed to create Phoenix project"
                    print_warning "You can try again during /start-planning"
                fi
            else
                print_warning "Phoenix installer not found."
                print_info "Install it with: mix archive.install hex phx_new"
                print_warning "You can create the Phoenix project later during /start-planning"
            fi
        fi
    else
        print_info "Skipping Phoenix project creation"
        print_info "You can create it later during /start-planning"
    fi
fi

# Summary
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                  Initialization Complete                   ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}Project:${NC} $PROJECT_NAME"
echo -e "${BLUE}Type:${NC} $PROJECT_TYPE"
echo ""

# Check if mix.exs exists to adjust next steps
if [ -f "mix.exs" ]; then
    echo -e "${YELLOW}Next Steps:${NC}"
    echo ""
    echo "  1. Review and customize CLAUDE.md for your project"
    echo "  2. Configure .claude/settings.json for your team"
    echo "  3. Create database: mix ecto.create"
    echo "  4. Start development with: /start-discovery"
else
    echo -e "${YELLOW}Next Steps:${NC}"
    echo ""
    echo "  1. Review and customize CLAUDE.md for your project"
    echo "  2. Configure .claude/settings.json for your team"
    echo "  3. Update .env with your environment variables"
    echo "  4. Set up MCP servers in .mcp.json (if needed)"
    echo "  5. Start development with: /start-discovery"
    echo ""
    print_warning "Note: Phoenix project not yet created."
    echo "  Create it during /start-planning or manually with:"
    echo "  mix phx.new . --app <app_name> --database postgres --live"
fi
echo ""

echo -e "${BLUE}Available Commands:${NC}"
echo ""
echo "  /start-discovery      Begin requirements gathering"
echo "  /start-planning       Start architecture and planning"
echo "  /start-implementation Begin development"
echo "  /run-review           Execute code review workflow"
echo "  /prepare-release      Prepare for deployment"
echo ""

echo -e "${BLUE}Documentation:${NC}"
echo ""
echo "  docs/i/phases/        Development phase guides"
echo "  docs/i/templates/     Document templates"
echo "  docs/i/checklists/    Project checklists"
echo "  .claude/skills/i/     AI-powered skills"
echo "  .claude/rules/i/      Development rules"
echo "  .claude/icons/i/      2600+ SVG icons (browse: gallery.html)"
echo ""

echo -e "${BLUE}Template Improvement:${NC}"
echo ""
echo "  docs/template-feedback.md   Track what works and what doesn't"
echo "  CONTRIBUTING.md             How to contribute improvements back"
echo ""
echo "  To pull template updates:   git fetch template && git diff HEAD template/main"
echo ""

echo -e "${GREEN}Happy coding! 🚀${NC}"
echo ""
