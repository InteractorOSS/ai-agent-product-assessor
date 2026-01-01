# Start Implementation Phase

Initialize the Implementation phase for coding and development.

## Instructions

When this command is invoked, perform the following:

### 1. Verify Planning Completion

Check if planning artifacts exist:
- `docs/planning/architecture.md`
- `docs/planning/tasks.md`

If missing, warn that planning phase may be incomplete.

### 2. Set Context

Update the project phase in CLAUDE.md to "implementation".

### 3. Development Environment Check

Verify development setup:
- [ ] Dependencies installed (`npm install` or equivalent)
- [ ] Environment variables configured (`.env`)
- [ ] Development server runs
- [ ] Tests can execute
- [ ] Development port configured (4005 or higher)

### Port Configuration

**Development**: Use port **4005 or higher** to avoid conflicts with other services.
**Production**: Use port **4000** (standard Phoenix default).

Configure in `config/dev.exs`:
```elixir
config :my_app, MyAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4005],
  # ... rest of config
```

Or via environment variable in `.env`:
```bash
PORT=4005  # Development
```

For production (`config/runtime.exs`):
```elixir
port = String.to_integer(System.get_env("PORT") || "4000")
```

### 4. Create Environment Configuration

If `.env` does not exist, create it from `.env.example`:

```bash
cp .env.example .env
```

#### Required Configuration

Ask the user for the following **required** values:

| Variable | Description | Default | Action |
|----------|-------------|---------|--------|
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://postgres:postgres@localhost:5432/my_app_dev` | Ask for app name to customize database name |
| `SECRET_KEY_BASE` | Phoenix secret (64+ chars) | *none* | Auto-generate with `mix phx.gen.secret` |
| `LIVE_VIEW_SIGNING_SALT` | LiveView salt (32 chars) | *none* | Auto-generate with `mix phx.gen.secret 32` |

#### Interactive Setup Flow

1. **Ask for Application Name**:
   ```
   What is your application name? (e.g., my_app)
   ```
   - Use this to set database name: `{app_name}_dev`
   - Update `DATABASE_URL` accordingly

2. **Generate Security Keys**:
   ```bash
   # Generate and set SECRET_KEY_BASE
   mix phx.gen.secret

   # Generate and set LIVE_VIEW_SIGNING_SALT
   mix phx.gen.secret 32
   ```

3. **Ask About Optional Services**:
   ```
   Will your application use any of these services? (You can configure later)

   - [ ] Email (SMTP/Mailgun/SendGrid)
   - [ ] Stripe payments
   - [ ] AWS S3 storage
   - [ ] Error tracking (Sentry)
   - [ ] Interactor API
   ```

   For any selected, note that configuration is needed in `.env`.

#### Example .env Setup

After gathering information, update `.env` with:

```bash
# Application Settings
MIX_ENV=dev
PORT=4005
PHX_HOST=localhost

# Database (customize database name)
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/{app_name}_dev
POOL_SIZE=10

# Security (auto-generated)
SECRET_KEY_BASE={generated_64_char_secret}
LIVE_VIEW_SIGNING_SALT={generated_32_char_salt}

# Optional services - configure as needed
# Uncomment and fill in when ready:
# SMTP_HOST=
# STRIPE_SECRET_KEY=
# AWS_ACCESS_KEY_ID=
# SENTRY_DSN=
# INTERACTOR_API_KEY=
```

#### Deferred Configuration Notice

Display to user:
```markdown
## Environment Configuration Created

✅ `.env` file created from `.env.example`
✅ Database URL configured for: {app_name}_dev
✅ Security keys auto-generated

### Configure Later
The following optional services can be configured in `.env` when needed:
- Email settings (SMTP_*, MAILGUN_*, etc.)
- Payment processing (STRIPE_*)
- Cloud storage (AWS_*)
- Error tracking (SENTRY_DSN)
- External APIs (INTERACTOR_API_KEY, GITHUB_TOKEN)

Edit `.env` anytime to add these configurations.

⚠️  Remember: NEVER commit `.env` to version control!
```

#### Validation
- [ ] `.env` file exists
- [ ] `DATABASE_URL` has correct database name
- [ ] `SECRET_KEY_BASE` is set (64+ characters)
- [ ] `LIVE_VIEW_SIGNING_SALT` is set (32 characters)
- [ ] `PORT` is set to 4005 or higher for development

### 5. Display Implementation Guidelines

```markdown
## Implementation Phase Guidelines

### Before Coding
1. Review the task requirements
2. Understand the acceptance criteria
3. Check related architecture decisions
4. Identify test cases first (TDD)

### While Coding
1. Follow code style guidelines (`.claude/rules/i/code-style.md`)
2. Write tests alongside code
3. Commit frequently with meaningful messages
4. Keep changes focused and atomic

### Code Review Preparation
1. Self-review before requesting review
2. Ensure tests pass
3. Update documentation if needed
4. Run linter and formatter

### AI Collaboration Tips
- Explain context before asking for help
- Review generated code carefully
- Ask for explanations when unclear
- Request tests for generated code
```

### 6. Display Current Tasks

If `docs/planning/tasks.md` exists, show:
- Current sprint/milestone tasks
- Task priorities
- Dependencies

### 7. Suggested Prompts

```
"Help me implement [feature] based on the architecture"
"Write tests for [function/component]"
"Review this code for [concerns]"
"Refactor [code] to improve [aspect]"
"Add error handling to [function]"
"Implement [pattern] for [use case]"
```

### 8. Available Skills

```markdown
### Skills for Implementation
- `code-review` - Review code for quality and security
- `test-generator` - Generate test scaffolds
- `doc-generator` - Update documentation
```

### 9. Create Development Start Script

Create `./scripts/start.sh` - a comprehensive development startup script that:

1. **Checks all dependencies**:
   - Elixir/Erlang versions (via asdf or system)
   - Node.js (if assets pipeline needed)
   - PostgreSQL running and accessible
   - Required CLI tools (mix, npm/yarn)

2. **Validates environment setup**:
   - `.env` file exists with required variables
   - Database configured and accessible
   - Required environment variables set

3. **Auto-setup if environment not ready**:
   - Prompt user to install missing dependencies
   - Offer to create `.env` from `.env.example`
   - Run `mix deps.get` if deps missing
   - Run `mix ecto.setup` if database not initialized
   - Run `npm install` if node_modules missing (for assets)

4. **Starts the development server**:
   - Run migrations if pending
   - Start Phoenix server with IEx shell
   - Display helpful startup information

```bash
#!/usr/bin/env bash
# ./scripts/start.sh - Development environment startup script
#
# Usage: ./scripts/start.sh [options]
# Options:
#   --check-only    Only check dependencies, don't start server
#   --setup         Run full setup (deps, db, assets)
#   --skip-checks   Skip dependency checks and start immediately
```

**Required behavior**:
- Exit with clear error messages if critical dependencies missing
- Offer interactive prompts for fixable issues
- Support `--help` flag for usage information
- Be idempotent (safe to run multiple times)
- Work on macOS and Linux

## Output

```markdown
## Implementation Phase Initialized

**Status**: Ready for development

### Architecture Summary
[Show key points from architecture doc if available]

### Current Tasks
[List tasks from planning if available]

### Development Checklist
- [ ] Environment configured
- [ ] Dependencies installed
- [ ] Tests running
- [ ] Linter configured

### Guidelines Reference
- Code style: `.claude/rules/i/code-style.md`
- Testing: `.claude/rules/i/testing.md`
- Security: `.claude/rules/i/security.md`
- Git workflow: `.claude/rules/i/git-workflow.md`

### Skills Available
- `code-review` - Code quality analysis
- `test-generator` - Create test scaffolds
- `doc-generator` - Update documentation

### Quick Commands
```bash
mix phx.server   # Start development server (port 4005+)
mix test         # Run tests
mix format       # Format code
mix credo        # Static analysis
```

> **Note**: Development runs on port 4005+ (localhost:4005). Production uses port 4000.

What would you like to implement first?
```

## Validation Requirements

### Entry Validation
Before starting implementation, verify planning outputs:
```
"Validate planning documents"
```

### During Implementation - Validate Every Change

After generating ANY code, run these validation commands:

```bash
# Required after every code generation
mix compile --warnings-as-errors    # Must pass
mix format --check-formatted        # Must pass
mix credo --strict                  # Should pass

# After writing tests
mix test                            # Must pass
```

### Code Generation Validation Checklist

After generating each type of code:

| Generated Code | Validation |
|---------------|------------|
| Schema/Migration | `mix ecto.migrate`, check rollback works |
| Context functions | `mix compile`, verify pattern matching |
| LiveView | Check mount/handle_params/handle_event pattern |
| Controller | Verify action_fallback, proper responses |
| Tests | `mix test`, verify meaningful assertions |

### Continuous Validation

Run after each significant change:
```elixir
# In IEx during development
recompile()  # Check for compilation errors
```

### Exit Gate Validation
Before proceeding to `/run-review`:

- [ ] All code compiles without warnings
- [ ] All tests pass
- [ ] Code is formatted (`mix format`)
- [ ] Credo passes (`mix credo --strict`)
- [ ] Coverage meets minimum threshold
- [ ] No TODO comments left in code

Run the `validator` skill:
```
"Validate the implementation before code review"
```

### 10. Update Team Settings

After the application has been built, update `.claude/settings.json` to reflect the project's technology stack:

#### For Elixir/Phoenix Projects

Update the settings to include Elixir-specific permissions and hooks:

```json
{
  "permissions": {
    "allow": [
      "Bash(git diff:*)",
      "Bash(git status:*)",
      "Bash(git log:*)",
      "Bash(git branch:*)",
      "Bash(mix test:*)",
      "Bash(mix format:*)",
      "Bash(mix credo:*)",
      "Bash(mix compile:*)",
      "Bash(mix deps.get:*)",
      "Bash(mix ecto.migrate:*)",
      "Bash(mix phx.routes:*)",
      "Bash(iex:*)",
      "Read(**/*)",
      "Glob(**/*)",
      "Grep(**/*)"
    ],
    "ask": [
      "Bash(git push:*)",
      "Bash(git commit:*)",
      "Bash(git checkout:*)",
      "Bash(git merge:*)",
      "Bash(mix ecto.drop:*)",
      "Bash(mix ecto.reset:*)",
      "Bash(mix ecto.rollback:*)",
      "Bash(mix deps.update:*)",
      "Bash(rm:*)",
      "Bash(curl:*)",
      "Bash(wget:*)",
      "Write(.env*)",
      "Write(**/secrets/**)",
      "Edit(mix.exs)",
      "Edit(mix.lock)"
    ],
    "deny": [
      "Write(.env)",
      "Write(.env.local)",
      "Write(.env.production)",
      "Write(**/credentials*)",
      "Write(**/secrets/**)",
      "Read(.env)",
      "Read(.env.local)",
      "Read(.env.production)",
      "Bash(rm -rf /)",
      "Bash(rm -rf ~)",
      "Bash(sudo:*)",
      "Bash(mix ecto.drop --force:*)"
    ],
    "additionalDirectories": []
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write(*.ex)",
        "hooks": [
          {
            "type": "command",
            "command": "mix format \"$CLAUDE_FILE_PATH\" 2>/dev/null || true"
          }
        ]
      },
      {
        "matcher": "Write(*.exs)",
        "hooks": [
          {
            "type": "command",
            "command": "mix format \"$CLAUDE_FILE_PATH\" 2>/dev/null || true"
          }
        ]
      },
      {
        "matcher": "Write(*.heex)",
        "hooks": [
          {
            "type": "command",
            "command": "mix format \"$CLAUDE_FILE_PATH\" 2>/dev/null || true"
          }
        ]
      },
      {
        "matcher": "Write(*.js)",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$CLAUDE_FILE_PATH\" 2>/dev/null || true"
          }
        ]
      },
      {
        "matcher": "Write(*.json)",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$CLAUDE_FILE_PATH\" 2>/dev/null || true"
          }
        ]
      },
      {
        "matcher": "Write(*.md)",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$CLAUDE_FILE_PATH\" 2>/dev/null || true"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write(.env*)",
        "hooks": [
          {
            "type": "command",
            "command": "echo '⚠️  WARNING: Modifying environment file. Ensure no secrets are being committed.'"
          }
        ]
      },
      {
        "matcher": "Write(**/production/**)",
        "hooks": [
          {
            "type": "command",
            "command": "echo '⚠️  WARNING: Modifying production configuration file.'"
          }
        ]
      },
      {
        "matcher": "Edit(config/runtime.exs)",
        "hooks": [
          {
            "type": "command",
            "command": "echo '⚠️  WARNING: Modifying runtime configuration. Verify environment variables.'"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo 'PROJECT_ROOT='$(pwd) >> $CLAUDE_ENV_FILE 2>/dev/null || true"
          }
        ]
      }
    ]
  },
  "env": {
    "MIX_ENV": "dev",
    "EDITOR": "code"
  },
  "attribution": {
    "commit": "Generated with AI assistance\n\nCo-Authored-By: Claude <noreply@anthropic.com>",
    "pr": "Generated with AI assistance"
  }
}
```

#### Settings Customization Checklist

When updating settings for your project:

1. **Permissions - Allow**: Add commands your team runs frequently
   - Build commands (`mix compile`, `mix deps.get`)
   - Test commands (`mix test`, `mix coveralls`)
   - Format/lint commands (`mix format`, `mix credo`)

2. **Permissions - Ask**: Add potentially destructive commands
   - Database operations (`mix ecto.drop`, `mix ecto.reset`)
   - Dependency changes (`mix deps.update`)
   - Git operations that modify history

3. **Permissions - Deny**: Add commands that should never run
   - Production database operations
   - Credential file access
   - Destructive system commands

4. **Hooks - PostToolUse**: Auto-format files after writing
   - `.ex`, `.exs`, `.heex` → `mix format`
   - `.js`, `.json`, `.md` → `prettier`

5. **Environment Variables**: Set project-specific defaults
   - `MIX_ENV`: Default environment
   - `DATABASE_URL`: If using external database
   - Custom project variables

#### Validation
After updating settings:
- [ ] Settings file is valid JSON
- [ ] All file patterns use correct glob syntax
- [ ] Hooks reference available formatters
- [ ] No sensitive data in env section

### 11. Update Project README

After the application has been built, update the project documentation:

#### Step 1: Rename Existing README
Rename the template setup README to preserve it for reference:

```bash
mv README.md README_SETUP.md
```

#### Step 2: Create Application README
Create a new `README.md` tailored to the built application with the following structure:

```markdown
# [Application Name]

[Brief description of what the application does]

## Features

- [Feature 1]
- [Feature 2]
- [Feature 3]

## Tech Stack

- **Backend**: Elixir/Phoenix
- **Database**: PostgreSQL
- **Frontend**: Phoenix LiveView, TailwindCSS
- [Other technologies used]

## Getting Started

### Prerequisites

- Elixir 1.15+
- Erlang/OTP 26+
- PostgreSQL 14+
- Node.js 18+ (for assets)

### Installation

1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd [project-directory]
   ```

2. Install dependencies:
   ```bash
   mix deps.get
   ```

3. Set up the database:
   ```bash
   mix ecto.setup
   ```

4. Install frontend dependencies:
   ```bash
   cd assets && npm install && cd ..
   ```

5. Start the development server:
   ```bash
   ./scripts/start.sh
   # Or manually: mix phx.server
   ```

6. Visit [`localhost:4005`](http://localhost:4005) in your browser.

## Development

### Running Tests
```bash
mix test
```

### Code Quality
```bash
mix format      # Format code
mix credo       # Static analysis
mix dialyzer    # Type checking
```

### Database Migrations
```bash
mix ecto.migrate    # Run migrations
mix ecto.rollback   # Rollback last migration
```

## Project Structure

```
lib/
├── [app_name]/           # Core business logic (contexts)
├── [app_name]_web/       # Web layer (controllers, views, templates)
test/                     # Test files
priv/repo/migrations/     # Database migrations
```

## Configuration

See `.env.example` for required environment variables.

## Documentation

- [Architecture](docs/planning/architecture.md)
- [API Documentation](docs/api/) (if applicable)

## Contributing

[Contributing guidelines if applicable]

## License

[License information]
```

#### Customization Requirements

When creating the new README, ensure:
1. **Application name** matches the actual project name
2. **Features** reflect what was actually implemented
3. **Tech stack** lists all technologies used
4. **Port number** matches the configured development port (default: 4005)
5. **Project structure** reflects the actual directory layout
6. **Environment variables** reference the actual `.env.example` file

#### Validation
After creating the new README:
- [ ] README.md exists with application-specific content
- [ ] README_SETUP.md exists (preserved template documentation)
- [ ] All links in README are valid
- [ ] Installation instructions work when followed
