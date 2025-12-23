# CLAUDE.md - AI-Driven Product Development Guide

This file provides comprehensive guidance to Claude Code for AI-driven product development across all phases of the software development lifecycle.

## Project Overview

- **Project Name**: [Your Project Name]
- **Project Type**: [web | mobile | backend | cli]
- **Technology Stack**: Elixir, Phoenix Framework, PostgreSQL, LiveView
- **Current Phase**: [discovery | planning | implementation | testing | review | deployment]

## Technology Stack

### Core Technologies
- **Language**: Elixir 1.15+
- **Framework**: Phoenix 1.7+
- **Frontend**: Phoenix LiveView, TailwindCSS
- **Database**: PostgreSQL with Ecto
- **Real-time**: Phoenix Channels, PubSub
- **Background Jobs**: Oban
- **Authentication**: phx.gen.auth or custom

### Key Elixir Concepts
- **OTP**: Supervision trees, GenServers, processes
- **Contexts**: Business logic organization (Phoenix contexts)
- **Changesets**: Data validation and casting
- **Pipelines**: Use `|>` for data transformation
- **Pattern Matching**: Leverage for control flow and destructuring

## Quick Reference

### Slash Commands

| Command | Description |
|---------|-------------|
| `/start-discovery` | Begin requirements gathering phase |
| `/start-planning` | Start architecture and planning phase |
| `/start-implementation` | Begin development phase |
| `/run-review` | Execute code review workflow |
| `/prepare-release` | Prepare for deployment |

### Skills

| Skill | Usage |
|-------|-------|
| `code-review` | Comprehensive code quality analysis |
| `security-audit` | OWASP-based security scanning |
| `doc-generator` | Auto-generate documentation |
| `test-generator` | Generate test scaffolds |
| `architecture-planner` | Design system architecture |
| `deployment` | Deployment preparation and verification |
| `validator` | **Validate any artifact for correctness** (use after every generation) |

---

## Development Workflow

### Phase 1: Discovery

**Objective**: Understand the problem space and gather requirements.

When working on discovery tasks:
1. Use `/start-discovery` to initialize the phase
2. Reference `docs/phases/01-discovery/` for templates
3. Create stakeholder analysis using provided template
4. Document requirements in user story format
5. Validate requirements against business goals

**Key deliverables**:
- Problem statement document
- Stakeholder analysis
- Requirements document with user stories
- Research summary

**Exit criteria**: Requirements prioritized and approved by stakeholders.

---

### Phase 2: Planning

**Objective**: Design architecture and create implementation plan.

When working on planning tasks:
1. Use `/start-planning` to initialize the phase
2. Create architecture using `docs/templates/design-doc-template.md`
3. Break down work using `docs/phases/02-planning/task-breakdown.md`
4. Document decisions using ADR template
5. Identify and assess risks

**Key deliverables**:
- Architecture design document
- Task breakdown with estimates
- Architecture Decision Records (ADRs)
- Risk assessment

**Exit criteria**: Architecture approved, tasks estimated, risks mitigated.

---

### Phase 3: Implementation

**Objective**: Write code following established standards.

When writing code:
1. Use `/start-implementation` to setup the phase
2. Follow `.claude/rules/code-style.md` for formatting
3. Apply TDD - write tests first when possible
4. Use meaningful commit messages per `.claude/rules/git-workflow.md`
5. Reference `docs/phases/03-implementation/ai-collaboration-guide.md`

**Best practices**:
- Commit frequently with atomic changes
- Write self-documenting code
- Handle errors appropriately
- Never hardcode secrets or credentials

**Exit criteria**: Feature complete, tests passing, code reviewed.

---

### Phase 4: Testing

**Objective**: Ensure quality through comprehensive testing.

When testing:
1. Follow `.claude/rules/testing.md` for requirements
2. Achieve minimum coverage thresholds
3. Include unit, integration, and e2e tests
4. Use `test-generator` skill for scaffolding
5. Document test scenarios

**Coverage requirements**:
- Minimum overall: 80%
- Critical paths: 100%
- New code: Must include tests

**Exit criteria**: All tests passing, coverage met, quality gates passed.

---

### Phase 5: Review

**Objective**: Validate code quality, security, and performance.

When reviewing:
1. Use `/run-review` to execute review workflow
2. Use `code-review` skill for automated analysis
3. Complete security checklist from `security-audit` skill
4. Check performance benchmarks
5. Verify accessibility requirements

**Review checklist**:
- [ ] Code quality and maintainability
- [ ] Security vulnerabilities
- [ ] Performance issues
- [ ] Test coverage
- [ ] Documentation completeness

**Exit criteria**: All review items addressed, approvals obtained.

---

### Phase 6: Deployment

**Objective**: Release to production safely.

When deploying:
1. Use `/prepare-release` to run deployment checklist
2. Use `deployment` skill for verification
3. Complete release checklist
4. Verify CI/CD pipeline
5. Set up monitoring and alerts

**Pre-deployment checklist**:
- [ ] All tests passing
- [ ] Security audit complete
- [ ] Documentation updated
- [ ] Rollback plan documented
- [ ] Monitoring configured

**Exit criteria**: Successful production deployment, monitoring active.

---

## AI Collaboration Guidelines

### DO

- Ask clarifying questions before major implementations
- Propose architecture before coding complex features
- Write tests alongside implementation
- Document decisions and rationale
- Reference existing patterns in codebase
- Use provided skills and commands for workflows
- Break down large tasks into smaller steps

### DON'T

- Skip testing or security considerations
- Make breaking changes without discussion
- Hard-code secrets, credentials, or environment-specific values
- Bypass pre-commit hooks or quality gates
- Assume requirements - ask when unclear
- Over-engineer simple solutions

---

## Validation Requirements

**Every generated artifact must be validated before moving forward.**

### Automatic Validation

After generating any output, run the `validator` skill to ensure correctness:

| Artifact | Validation |
|----------|------------|
| Requirements/User Stories | Completeness, clarity, no ambiguity |
| Architecture/Design | Technical correctness, Phoenix patterns |
| Code (Elixir) | Compiles, formatted, passes credo |
| Migrations | Reversible, safe, correct types |
| Tests | Pass, adequate coverage, no flaky tests |

### Validation Commands

```bash
# Always run after code generation
mix compile --warnings-as-errors  # Must pass
mix format --check-formatted      # Must pass
mix credo --strict                # Should pass
mix test                          # Must pass

# Before commits
mix test --cover                  # Check coverage
mix sobelow                       # Security check
```

### Phase Gate Validation

Before transitioning between phases, validate:

| Transition | Required Validations |
|------------|---------------------|
| Discovery → Planning | Requirements complete, stakeholders identified |
| Planning → Implementation | Architecture reviewed, tasks broken down |
| Implementation → Testing | Code compiles, basic tests pass |
| Testing → Review | All tests pass, coverage met |
| Review → Deployment | Security audit, performance checked |

### Validation Report Format

After validation, report results as:

```
✓ PASS: [Check name]
✗ FAIL: [Check name] - [Issue and fix]
⚠ WARN: [Check name] - [Recommendation]
```

---

## Project Structure

<!-- Phoenix Application Structure -->

```
lib/
├── my_app/                    # Core business logic
│   ├── accounts/              # Accounts context (users, auth)
│   │   ├── user.ex           # User schema
│   │   └── accounts.ex       # Context functions
│   ├── catalog/               # Example business context
│   │   ├── product.ex        # Product schema
│   │   └── catalog.ex        # Context functions
│   └── application.ex         # OTP Application
│
├── my_app_web/                # Web layer
│   ├── components/            # Phoenix components
│   │   └── core_components.ex
│   ├── controllers/           # Traditional controllers
│   ├── live/                  # LiveView modules
│   │   ├── page_live.ex
│   │   └── user_live/
│   ├── router.ex              # Routes
│   ├── endpoint.ex            # HTTP endpoint
│   └── telemetry.ex           # Metrics
│
├── priv/
│   ├── repo/migrations/       # Ecto migrations
│   └── static/                # Static assets
│
└── test/
    ├── my_app/                # Context tests
    ├── my_app_web/            # Web layer tests
    └── support/               # Test helpers
```

---

## Common Commands

```bash
# Development
mix phx.server                 # Start Phoenix server (localhost:4000)
iex -S mix phx.server          # Start with interactive shell
mix deps.get                   # Install dependencies
mix deps.compile               # Compile dependencies

# Database
mix ecto.create                # Create database
mix ecto.migrate               # Run migrations
mix ecto.rollback              # Rollback last migration
mix ecto.reset                 # Drop, create, migrate, seed
mix ecto.gen.migration <name>  # Generate migration

# Code Generation
mix phx.gen.live <Context> <Schema> <table> [fields]    # LiveView CRUD
mix phx.gen.html <Context> <Schema> <table> [fields]    # HTML CRUD
mix phx.gen.context <Context> <Schema> <table> [fields] # Context only
mix phx.gen.schema <Schema> <table> [fields]            # Schema only
mix phx.gen.auth Accounts User users                    # Auth scaffolding

# Testing
mix test                       # Run all tests
mix test --cover               # Run with coverage
mix test test/path/to_test.exs # Run specific file
mix test test/path:42          # Run specific test at line

# Code Quality
mix format                     # Format code (auto-fixes)
mix format --check-formatted   # Check formatting
mix credo                      # Static analysis
mix dialyzer                   # Type checking
mix sobelow                    # Security analysis
```

---

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `MIX_ENV` | Environment (dev/test/prod) | Yes |
| `DATABASE_URL` | PostgreSQL connection string | Yes |
| `SECRET_KEY_BASE` | Phoenix secret key (generate with `mix phx.gen.secret`) | Yes (prod) |
| `PHX_HOST` | Host for production (e.g., example.com) | Yes (prod) |
| `PORT` | HTTP port (default: 4000) | No |
| `POOL_SIZE` | Database connection pool size | No |

See `.env.example` for all available variables.

---

## Key Resources

### Documentation

- `docs/phases/` - Phase-specific documentation and templates
- `docs/templates/` - Document templates (PRD, ADR, Design Doc)
- `docs/checklists/` - Comprehensive project checklists

### Configuration

- `.claude/skills/` - AI skills for specialized tasks
- `.claude/commands/` - Slash commands for workflows
- `.claude/rules/` - Modular development rules
- `.claude/settings.json` - Team settings and permissions

### Platform-Specific

- `config/web/` - Web project configuration
- `config/mobile/` - Mobile project configuration
- `config/backend/` - Backend project configuration
- `config/cli/` - CLI project configuration

---

## Getting Started

1. Run `./scripts/setup/init-project.sh <project-name> <type>` to initialize
2. Update this CLAUDE.md with your project specifics
3. Configure `.claude/settings.json` for your team
4. Set up environment variables from `.env.example`
5. Use `/start-discovery` to begin the development process
