# Product Development Template

A comprehensive AI-driven product development template for Elixir/Phoenix applications, powered by Claude Code. This template covers all phases of the software development lifecycle with built-in validation at every step.

## What This Template Provides

- **AI-Powered Development** - Skills, commands, and rules optimized for Claude Code
- **Full SDLC Coverage** - Discovery → Planning → Implementation → Testing → Review → Deployment
- **Continuous Validation** - Every artifact is validated for correctness before proceeding
- **Elixir/Phoenix Best Practices** - Phoenix contexts, Ecto patterns, LiveView, Oban
- **Comprehensive Documentation** - Templates, checklists, and guides for every phase

## Prerequisites

- [Claude Code](https://claude.ai/claude-code) installed
- Elixir 1.15+ and Erlang/OTP 26+
- PostgreSQL
- Git

## Quick Start

#### Enter your product idea

Update `docs/phases/01-discovery/project-idea-intake.md` with your idea.

| You can write your ideas in a notepad and instruct Claude to fill in the `project-idea-intake.md`
| Having screenshots or mock of page drawn up helps. Save it in a file and let Claude know the location.

### Step 1: Create Your Project

```bash
# Clone the template
git clone https://github.com/pulzze/product-dev-template.git my-project
cd my-project

# Run the initialization script
./scripts/setup/init-project.sh my-project web mobile backend

# Project types: web, mobile, backend, cli
```

The init script will:
- Configure CLAUDE.md with your project name
- Apply platform-specific settings
- Create local configuration files
- Set up git repository
- Add template remote for future updates


### Step 2: Configure Your Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your settings
# Key variables:
#   DATABASE_URL=postgresql://postgres:postgres@localhost:5432/my_app_dev
#   SECRET_KEY_BASE= (generate with: mix phx.gen.secret)
```

### Step 3: Create Your Phoenix Application

```bash
# Create a new Phoenix app (run in parent directory of my-project, or adjust paths)
mix phx.new my_app --database postgres

# Or if using this template as a scaffold for an existing app,
# copy the .claude/, docs/, and scripts/ directories to your project
```

### Step 4: Start Development with Claude Code

Open Claude Code in your project directory and begin with discovery:

```
/start-discovery
```

This will guide you through gathering requirements. Then proceed through the phases:

```
/start-planning        # Design architecture
/start-implementation  # Begin coding
/run-review           # Code review
/prepare-release      # Deploy
```

## Development Workflow

### The Six Phases

```
┌─────────────┐   ┌─────────────┐   ┌─────────────────┐
│  Discovery  │ → │  Planning   │ → │ Implementation  │
│             │   │             │   │                 │
│ • Requirements   • Architecture    • Write code     │
│ • User stories   • Task breakdown  • Write tests    │
│ • Stakeholders   • ADRs            • Validate       │
└─────────────┘   └─────────────┘   └─────────────────┘
       ↓                 ↓                   ↓
   [Validate]        [Validate]          [Validate]

┌─────────────┐   ┌─────────────┐   ┌─────────────────┐
│   Testing   │ → │   Review    │ → │   Deployment    │
│             │   │             │   │                 │
│ • Unit tests     • Code review    • Release build  │
│ • Integration    • Security       • Staging        │
│ • Coverage       • Performance    • Production     │
└─────────────┘   └─────────────┘   └─────────────────┘
       ↓                 ↓                   ↓
   [Validate]        [Validate]          [Validate]
```

### Iterative Changes

Real projects aren't linear. Use `/handle-change` when requirements or designs change:

```
                    ┌─────────────────┐
                    │  Change Request │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
         ┌────────┐    ┌──────────┐   ┌──────────┐
         │ Small  │    │  Medium  │   │  Large   │
         │(code)  │    │(design)  │   │(arch)    │
         └───┬────┘    └────┬─────┘   └────┬─────┘
             │              │              │
             ▼              ▼              ▼
         Continue      Update docs    Go back to
         coding        Mini-cycle     Planning
```

- **Small changes**: Update code + tests, continue implementation
- **Medium changes**: Quick planning, update docs, mini-cycle
- **Large changes**: Revisit Planning phase, update ADR, re-estimate

See `docs/templates/change-request-template.md` for formal change tracking.

### Validation at Every Step

The template enforces validation at every phase. After generating any artifact, run:

```bash
# After code changes
mix compile --warnings-as-errors  # Must pass
mix format --check-formatted      # Must pass
mix test                          # Must pass

# Before commits
mix credo --strict               # Should pass
mix test --cover                 # Coverage ≥ 80%

# Before deployment
mix sobelow                      # Security check
mix hex.audit                    # Dependency audit
MIX_ENV=prod mix release         # Release builds
```

### Using Slash Commands

| Command | When to Use |
|---------|------------|
| `/start-discovery` | Starting a new project or feature - gather requirements |
| `/start-planning` | After requirements are clear - design architecture |
| `/start-implementation` | After planning is complete - begin coding |
| `/run-review` | Before merging - comprehensive code review |
| `/prepare-release` | Before deployment - release checklist |
| `/handle-change` | Requirements or design changed - assess and adapt |

### Using Skills

| Skill | Purpose |
|-------|---------|
| `validator` | Validate any artifact for correctness (use frequently!) |
| `code-review` | Comprehensive code quality analysis |
| `security-audit` | OWASP-based security scanning |
| `test-generator` | Generate test scaffolds |
| `architecture-planner` | Design system architecture |
| `deployment` | Deployment preparation and verification |
| `doc-generator` | Auto-generate documentation |

Example: "Use the validator skill to check these requirements"

## Project Structure

```
my-project/
├── CLAUDE.md                    # AI guidance - customize for your project
├── CONTRIBUTING.md              # How to improve the template
│
├── .claude/
│   ├── settings.json            # Team settings & hooks
│   ├── settings.local.json      # Personal settings (gitignored)
│   ├── skills/                  # AI skills
│   │   ├── validator/           # Validation skill (use frequently!)
│   │   ├── code-review/
│   │   ├── security-audit/
│   │   ├── test-generator/
│   │   ├── architecture-planner/
│   │   ├── deployment/
│   │   └── doc-generator/
│   ├── commands/                # Slash commands for each phase
│   │   ├── start-discovery.md
│   │   ├── start-planning.md
│   │   ├── start-implementation.md
│   │   ├── run-review.md
│   │   └── prepare-release.md
│   └── rules/                   # Development rules
│       ├── code-style.md
│       ├── testing.md
│       ├── security.md
│       ├── documentation.md
│       └── git-workflow.md
│
├── .mcp.json                    # MCP server configuration
├── .env.example                 # Environment variables template
│
├── docs/
│   ├── phases/                  # Phase documentation
│   │   ├── 01-discovery/
│   │   │   ├── README.md
│   │   │   ├── project-idea-intake.md   # Start here with rough ideas
│   │   │   ├── requirements-template.md
│   │   │   ├── stakeholder-analysis.md
│   │   │   └── user-story-template.md
│   │   ├── 02-planning/
│   │   ├── 03-implementation/
│   │   ├── 04-testing/
│   │   ├── 05-review/
│   │   └── 06-deployment/
│   │       ├── README.md
│   │       ├── release-checklist.md
│   │       └── rollback-procedures.md
│   ├── templates/
│   │   ├── prd-template.md          # Product Requirements Doc
│   │   ├── design-doc-template.md   # Technical Design Doc
│   │   ├── adr-template.md          # Architecture Decision Record
│   │   └── template-feedback.md     # Track template improvements
│   └── checklists/
│       ├── validation-checklist.md  # Comprehensive validation guide
│       ├── project-kickoff.md
│       ├── code-complete.md
│       └── release-ready.md
│
├── config/                      # Platform-specific configurations
│   ├── web/CLAUDE.local.md
│   ├── mobile/CLAUDE.local.md
│   ├── backend/CLAUDE.local.md
│   └── cli/CLAUDE.local.md
│
└── scripts/
    └── setup/
        ├── init-project.sh      # Project initialization
        └── sync-template.sh     # Pull template updates
```

## Example Workflow

### Starting a New Project

1. **Share your idea** (even rough notes are fine):
   ```
   I want to build a task management app where teams can track projects,
   assign tasks, and set deadlines. Should have real-time updates.
   ```

2. **Claude processes through discovery**:
   - Extracts requirements from your description
   - Asks clarifying questions
   - Creates structured user stories
   - Validates completeness

3. **Move to planning** (`/start-planning`):
   - Designs Phoenix contexts (Projects, Tasks, Teams)
   - Creates database schema with Ecto
   - Documents architectural decisions

4. **Implementation** (`/start-implementation`):
   - Generates code following Phoenix patterns
   - Validates after every change
   - Writes tests alongside code

5. **Review and Deploy** (`/run-review`, `/prepare-release`):
   - Comprehensive code review
   - Security audit
   - Release validation

## Validation Commands Reference

```bash
# Must pass after every code change
mix compile --warnings-as-errors
mix format --check-formatted
mix test

# Should pass before commits
mix credo --strict
mix test --cover

# Must pass before deployment
mix sobelow --config
mix hex.audit
mix dialyzer                    # Optional but recommended
MIX_ENV=prod mix release

# One-liner for pre-commit
mix format && mix compile --warnings-as-errors && mix credo --strict && mix test

# One-liner for full validation
mix format --check-formatted && mix compile --warnings-as-errors && \
mix credo --strict && mix test --cover && mix sobelow && mix hex.audit
```

## Keeping the Template Updated

Projects created from this template can pull in improvements automatically or manually.

### Option 1: GitHub Actions (Recommended)

Set up automatic sync checking with the included workflow:

1. Add the template repo as a secret:
   ```bash
   # In your project's GitHub Settings > Secrets > Actions
   # Add secret: TEMPLATE_REPO = "your-org/product-dev-template"
   ```

2. The workflow runs weekly and creates a PR when updates are available

3. Or trigger manually:
   - Go to **Actions** > **Sync Template Updates** > **Run workflow**
   - Select which component to sync (all, skills, commands, rules, docs, validator)

### Option 2: Manual Sync

```bash
# See available updates
git fetch template
git diff HEAD template/main -- .claude/ docs/

# Interactive sync
./scripts/setup/sync-template.sh

# Sync specific components
./scripts/setup/sync-template.sh skills     # Just skills
./scripts/setup/sync-template.sh validator  # Just validator
./scripts/setup/sync-template.sh docs       # Documentation
```

## Contributing Improvements

Track what works and what doesn't in `docs/template-feedback.md`, then contribute back:

1. Fork the template repository
2. Make your improvements
3. Submit a PR with description of what was improved

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Customization

### Modify CLAUDE.md

The main guidance document. Update:
- Project name and type
- Current development phase
- Technology stack specifics
- Custom workflows

### Add Custom Skills

Create in `.claude/skills/my-skill/SKILL.md`:

```markdown
---
name: my-skill
description: What this skill does
---

# My Skill

## When to Use
[Trigger conditions]

## Instructions
[What Claude should do]
```

### Add Custom Rules

Create in `.claude/rules/my-rule.md`:

```markdown
---
paths: src/**/*.ex  # Optional: apply to specific files
---

# My Rule

[Rule content]
```

## MCP Servers

Pre-configured but disabled by default in `.mcp.json`:

- **filesystem** - File system access
- **github** - GitHub integration
- **postgres** - PostgreSQL access
- **memory** - Persistent memory

Enable by setting `"disabled": false` in `.mcp.json`.

## Technology Stack

This template is optimized for:

- **Elixir 1.15+** with OTP 26+
- **Phoenix 1.7+** with LiveView
- **PostgreSQL** with Ecto
- **Oban** for background jobs
- **TailwindCSS** for styling

The validation commands, skills, and examples all follow Elixir/Phoenix best practices.

## License

MIT License - See [LICENSE](LICENSE) for details.

---

Built with Claude Code best practices. Happy coding!
