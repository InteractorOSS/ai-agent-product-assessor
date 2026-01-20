# Product Development Template - Setup Guide

**⚠️ PROPRIETARY - INTERNAL USE ONLY**

This guide contains the proprietary project setup methodology. For shareable template documentation, see `README_i.md`.

---

## What This Template Provides

- **AI-Powered Development** - Skills, commands, and rules optimized for Claude Code
- **Full SDLC Coverage** - Discovery → Planning → Implementation → Testing → Review → Deployment
- **Continuous Validation** - Every artifact is validated for correctness before proceeding
- **Elixir/Phoenix Best Practices** - Phoenix contexts, Ecto patterns, LiveView, Oban
- **Comprehensive Documentation** - Templates, checklists, and guides for every phase

## Prerequisites

- [Claude Code](https://claude.ai/claude-code) installed
- Git

**Note**: Elixir, Erlang, Node.js, and PostgreSQL will be auto-installed by `./scripts/start.sh` if missing!

---

## Quick Start - New Project Setup

### Step 0: Document Your Project Idea

Before running the initialization script, capture your project requirements:

1. Open `docs/project-idea-intake.md`
2. Fill in your project details:
   - Project name and description
   - Target users and use cases
   - Key features and requirements
   - Technology preferences

**The init script uses this information** to set up your project correctly.

### Step 1: Create Your Project

```bash
# Clone the template
git clone https://github.com/pulzze/product-dev-template.git my-project
cd my-project

# Fill out docs/project-idea-intake.md first (see Step 0 above)

# Run the initialization script
./scripts/setup/init-project.sh my-project web

# Project types: web, mobile, backend, cli
```

**Note:** After running `init-project.sh`, proceed to the Development Environment Setup section below.

### Step 2: Start Development with Claude Code

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

**Note:** Before starting development, you'll need to set up your development environment. See the Development Environment Setup section after the phases below.

---

## Development Workflow - The Six Phases

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

### Phase 1: Discovery

**Command**: `/start-discovery`

**Purpose**: Understand the problem space and gather requirements.

**Templates**:
- `docs/setup/phases/01-discovery/requirements-template.md`
- `docs/setup/phases/01-discovery/stakeholder-analysis.md`
- `docs/setup/phases/01-discovery/user-story-template.md`

**Outputs**:
- Problem statement document
- Stakeholder analysis
- Requirements document with user stories
- Research summary

**Exit Criteria**: Requirements prioritized and approved by stakeholders

---

### Phase 2: Planning

**Command**: `/start-planning`

**Purpose**: Design architecture and create implementation plan.

**Templates**:
- `docs/setup/templates/design-doc-template.md`
- `docs/setup/templates/adr-template.md`
- `docs/setup/phases/02-planning/task-breakdown.md`

**Outputs**:
- Architecture design document
- Task breakdown with estimates
- Architecture Decision Records (ADRs)
- Risk assessment

**Exit Criteria**: Architecture approved, tasks estimated, risks mitigated

---

### Phase 3: Implementation

**Command**: `/start-implementation`

**Purpose**: Write code following established standards.

**Best Practices**:
- Use TDD - write tests first when possible
- Follow `.claude/rules/i/code-style.md`
- Commit frequently with atomic changes
- Reference `docs/setup/phases/03-implementation/ai-collaboration-guide.md`

**Exit Criteria**: Feature complete, tests passing, code reviewed

---

### Phase 4: Testing

**Purpose**: Ensure quality through comprehensive testing.

**Coverage Requirements**:
- Minimum overall: 80%
- Critical paths: 100%
- New code: Must include tests

**Exit Criteria**: All tests passing, coverage met, quality gates passed

---

### Phase 5: Review

**Command**: `/run-review`

**Purpose**: Validate code quality, security, and performance.

**Review Checklist**:
- [ ] Code quality and maintainability
- [ ] Security vulnerabilities
- [ ] Performance issues
- [ ] Test coverage
- [ ] Documentation completeness

**Exit Criteria**: All review items addressed, approvals obtained

---

### Phase 6: Deployment

**Command**: `/prepare-release`

**Purpose**: Release to production safely.

**Pre-Deployment Checklist**:
- [ ] All tests passing
- [ ] Security audit complete
- [ ] Documentation updated
- [ ] Rollback plan documented
- [ ] Monitoring configured

**Exit Criteria**: Successful production deployment, monitoring active

---

## Development Environment Setup

After creating your project with `init-project.sh`, set up your development environment:

```bash
# This single command does everything:
./scripts/start.sh --setup
```

**The start.sh --setup script automatically:**
- ✅ Installs Elixir/Erlang (via asdf or Homebrew)
- ✅ Installs Node.js 18+
- ✅ Creates Phoenix project if missing
- ✅ Creates and configures `.env` file
- ✅ Generates security keys (SECRET_KEY_BASE, etc.)
- ✅ Installs all dependencies
- ✅ Creates database and runs migrations
- ✅ Validates everything works
- ✅ Starts the development server

**This is a one-time setup step** that prepares your development environment. After this completes, you're ready to begin the discovery phase with Claude Code.

### Daily Development

After the initial setup, simply run:

```bash
./scripts/start.sh
```

This starts the development server without repeating the full setup process.

---

## Iterative Changes & Rework

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

**Change Types**:
- **Small changes**: Update code + tests, continue implementation
- **Medium changes**: Quick planning, update docs, mini-cycle
- **Large changes**: Revisit Planning phase, update ADR, re-estimate

See `docs/templates/change-request-template.md` for formal change tracking.

---

## Setup Slash Commands

| Command | When to Use | Location |
|---------|------------|----------|
| `/start-discovery` | Starting a new project - gather requirements | `.claude/commands/setup/` |
| `/start-planning` | After requirements clear - design architecture | `.claude/commands/setup/` |
| `/start-implementation` | After planning complete - begin coding | `.claude/commands/setup/` |
| `/run-review` | Before merging - comprehensive code review | `.claude/commands/i/` |
| `/prepare-release` | Before deployment - release checklist | `.claude/commands/i/` |
| `/handle-change` | Requirements/design changed - assess and adapt | `.claude/commands/i/` |

**Note**: Commands in `setup/` are proprietary and for internal use only.

---

## Setup Skills

| Skill | Purpose | Location |
|-------|---------|----------|
| `architecture-planner` | Design system architecture for new projects | `.claude/skills/setup/` |

**Note**: This skill is proprietary and part of the setup methodology.

---

## Example Workflow - Starting a New Project

### 1. Document Your Idea in project-idea-intake.md

Fill out `docs/project-idea-intake.md` with your project details:

```markdown
# Project Name: TaskFlow

## Brief Description
A task management app where teams can track projects,
assign tasks, and set deadlines. Should have real-time updates.

## Target Users
- Small to medium teams (5-50 people)
- Project managers and team leads

## Key Features
- Project creation and tracking
- Task assignment with deadlines
- Real-time updates via LiveView
- Team collaboration
```

**Note**: `./scripts/setup/init-project.sh` reads this file to configure your project.

### 2. Claude Processes Through Discovery (`/start-discovery`)

- Extracts requirements from your description
- Asks clarifying questions
- Creates structured user stories
- Validates completeness

### 3. Move to Planning (`/start-planning`)

- Designs Phoenix contexts (Projects, Tasks, Teams)
- Creates database schema with Ecto
- Documents architectural decisions

### 4. Implementation (`/start-implementation`)

- Generates code following Phoenix patterns
- Validates after every change
- Writes tests alongside code

### 5. Review and Deploy (`/run-review`, `/prepare-release`)

- Comprehensive code review
- Security audit
- Release validation

---

## Setup Documentation Structure

```
docs/
├── project-idea-intake.md      # ⚠️ SETUP - Initial project requirements
└── setup/                      # ⚠️ PROPRIETARY
    ├── phases/
    │   ├── 01-discovery/
    │   │   ├── README.md
    │   │   ├── requirements-template.md
    │   │   ├── stakeholder-analysis.md
    │   │   └── user-story-template.md
    │   ├── 02-planning/
    │   │   ├── README.md
    │   │   ├── task-breakdown.md
    │   │   └── risk-assessment.md
    │   └── 03-implementation/
    │       ├── README.md
    │       └── ai-collaboration-guide.md
    ├── templates/
    │   ├── prd-template.md          # Product Requirements Doc
    │   ├── design-doc-template.md   # Technical Design Doc
    │   └── adr-template.md          # Architecture Decision Record
    └── checklists/
        └── project-kickoff.md
```

**Key Setup Files**:
- **`docs/project-idea-intake.md`**: Initial project requirements and specifications (used by init-project.sh)
- **`docs/setup/`**: Phase-specific templates, checklists, and guides
- **`.claude/commands/setup/`**: Phase initialization commands
- **`.claude/skills/setup/`**: Architecture planning and setup skills
- **`scripts/setup/`**: Initialization and setup scripts

---

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

---

## Technology Stack

This template is optimized for:

- **Elixir 1.15+** with OTP 26+
- **Phoenix 1.7+** with LiveView
- **PostgreSQL** with Ecto
- **Oban** for background jobs
- **TailwindCSS** for styling

The validation commands, skills, and examples all follow Elixir/Phoenix best practices.

---

## Security Note

**This README_SETUP.md file and all files in `/setup/` directories contain proprietary project creation methodology.**

When sharing projects with external engineers, use `README_i.md` instead and ensure setup folders are not included.

See `docs/SETUP-FOLDER-SECURITY.md` for complete security documentation.

---

**For Template Documentation**: See `README_i.md`
**For Security Info**: See `docs/SETUP-FOLDER-SECURITY.md`

---

Built with Claude Code best practices for internal project creation.
