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

---

# ⛔ STOP - MANDATORY LAYOUT STRUCTURE

> **Before writing ANY UI code, you MUST implement this layout structure.**

## Default Application Layout (MANDATORY)

**ALL applications built with this template MUST use this 3-panel layout:**

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│ APPBAR (Global Navigation Bar) - Fixed Top, h-16, z-50                           │
│ [≡][⊞][Logo]         [✨ What can I do for you?...]          [🔔¹²][?][👤][+]   │
├─────────────────┬────────────────────────────────────────────┬───────────────────┤
│ LEFT DRAWER     │                                            │ RIGHT PANE        │
│ (Sidebar)       │           MAIN CONTENT                     │ (AI Copilot)      │
│ w-64, fixed     │           (scrollable)                     │ w-80, optional    │
│                 │                                            │                   │
│ [+ Create] 🟢   │                                            │ Slides in when    │
│                 │                                            │ user submits AI   │
│ NAVIGATION      │                                            │ query or clicks   │
│ - Dashboard     │                                            │ Quick Create (+)  │
│ - Items...      │                                            │                   │
│                 │                                            │                   │
│ ⚠️ Warnings go  │                                            │                   │
│ BELOW items!    │                                            │                   │
│                 │                                            │                   │
│ ─────────────── │                                            │                   │
│ Feedback        │                                            │                   │
│ 😞 😟 😐 🙂 😊  │                                            │                   │
└─────────────────┴────────────────────────────────────────────┴───────────────────┘
```

### Layout Template Location

**Copy and customize this template:**
```
.claude/templates/ui/phoenix/app_layout.html.heex  →  lib/my_app_web/components/layouts/app.html.heex
```

### 3 MANDATORY Layout Components

| # | Component | Description | Template |
|---|-----------|-------------|----------|
| 1 | **AppBar (GNB)** | Fixed top nav with Logo, AI Input, Notifications, Profile, Quick Create | Included in app_layout.html.heex |
| 2 | **Left Drawer** | Fixed sidebar with Create button, Navigation, Feedback at bottom | Included in app_layout.html.heex |
| 3 | **Main Content** | Scrollable content area that adjusts margins for drawer/pane | Included in app_layout.html.heex |

### Optional: Right Pane (AI Copilot)

The Right Pane slides in from the right when:
- User submits a query in the AI Assistant input
- User clicks the Quick Create (+) button
- Any feature needs a slide-in panel

---

## ⚠️ MATERIAL UI DESIGN SYSTEM - MANDATORY

> **STOP! Before writing ANY UI code, you MUST read this section.**

**All applications built with this template MUST follow Material UI design patterns.** This is enforced by `.claude/rules/i/material-ui-enforcement.md` which auto-applies to all UI files.

### Required Reading (In This Order)

| Priority | Document | Purpose |
|----------|----------|---------|
| **1. CRITICAL** | `.claude/rules/i/material-ui-enforcement.md` | Auto-enforced design rules |
| **2. CRITICAL** | `docs/i/ui-design/material-ui/index.md` | Complete design specification |
| **3. CRITICAL** | `docs/i/ui-design/gnb-components.md` | Navigation patterns |
| 4. High | `docs/i/ui-design/material-ui/checklist.md` | Validation checklist |

### 6 Mandatory UI Patterns (Non-Negotiable)

| # | Pattern | ✅ Correct | ❌ Wrong |
|---|---------|-----------|----------|
| 1 | **Lottie Animated Logo** | `InteractorLogo_Light.json` | Static PNG/SVG |
| 2 | **GREEN Create Button** | `#4CD964` with `#3DBF55` hover | Blue/orange/other colors |
| 3 | **Quick Create (+)** | Green FAB in AppBar → right panel | Missing or wrong action |
| 4 | **Dual Notification Badge** | Primary count + red error count | Single badge only |
| 5 | **Warnings BELOW Items** | Warning below problematic item | Warning at top of page |
| 6 | **Feedback Section** | 5 emoji at drawer bottom | Missing or wrong position |

### Design Tokens (Use These Exactly)

```
COLORS:
  Primary Green:    #4CD964  (hover: #3DBF55)
  Error Red:        #FF3B30
  Warning Yellow:   #FFCC00
  Background:       #F5F5F5 (light) / #1E1E1E (dark)
  Surface:          #FFFFFF (light) / #2D2D2D (dark)

BORDER RADIUS:
  Buttons:          9999px  (rounded-full - pill shaped)
  Cards/Modals:     16px    (rounded-2xl)
  Inputs:           8px     (rounded-lg)

SIZING:
  AppBar:           64px    (h-16)
  Sidebar:          240px   (w-64) / 56px collapsed
  Right Panel:      320px   (w-80)
```

### TailwindCSS Quick Reference

```html
<!-- Primary Button (Create Actions) -->
<button class="bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium px-6 py-2 rounded-full shadow-md">
  Create
</button>

<!-- AppBar -->
<header class="bg-white shadow-sm h-16 fixed top-0 left-0 right-0 z-50">

<!-- Left Drawer -->
<aside class="w-64 bg-white h-screen fixed left-0 top-16 shadow-lg">

<!-- Card -->
<div class="bg-white rounded-2xl shadow-md p-6">
```

### Brand Assets

Copy from `.claude/assets/i/brand/` to `priv/static/brand/`:
- `lottie/InteractorLogo_Light.json`
- `lottie/InteractorLogo_Dark.json`
- `icons/icon_simple_green_v1.png`

### Additional UI Guidelines

| Guideline | Location |
|-----------|----------|
| Logo & Branding | `docs/i/ui-design/logo-branding.md` |
| Forms | `docs/i/ui-design/forms.md` |
| Buttons | `docs/i/ui-design/buttons.md` |
| Colors | `docs/i/ui-design/colors.md` |
| Modals & Dropdowns | `docs/i/ui-design/modals-dropdowns.md` |
| Panels & Toolbar | `docs/i/ui-design/panels-toolbar.md` |

---

## Quick Reference

### Slash Commands

| Command | Description |
|---------|-------------|
| `/start-discovery` | Begin requirements gathering phase |
| `/start-planning` | Start architecture and planning phase |
| `/start-implementation` | Begin development phase |
| `/run-review` | Execute code review workflow |
| `/prepare-release` | Prepare for deployment |
| `/handle-change` | Process requirement/design changes mid-project |

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

### External Documentation

Some documentation is automatically synchronized from external Interactor repositories:

| Document | Description | Manual Sync |
|----------|-------------|-------------|
| `docs/i/guides/interactor-authentication.md` | Interactor auth integration guide (auto-synced daily) | `./scripts/setup/sync-external-docs.sh interactor-auth` |

**Auto-Sync Details:**
- Daily sync at 6am UTC via GitHub Actions
- Manual trigger available in Actions → "Sync External Documentation"
- See `docs/i/guides/README.md` for complete sync system documentation

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

## Iterative Changes & Rework

Real projects rarely follow a linear path. Requirements change, designs evolve, and issues surface late. Here's how to handle changes at any phase.

### Change Triggers

| Trigger | Impact | Action |
|---------|--------|--------|
| New requirement discovered | May affect architecture | Assess scope, update docs, possibly re-plan |
| Bug found in production | Code + possibly design | Fix, add tests, update if pattern issue |
| Performance issue | Implementation | Profile, fix, document learnings |
| User feedback | Requirements + UI/UX | Update requirements, prioritize changes |
| Security vulnerability | Immediate | Hotfix, then root cause analysis |
| Scope change from stakeholder | All phases | Re-assess, update ADRs, re-plan affected areas |

### Handling Changes by Current Phase

**During Implementation (most common):**
```
Change Request
     │
     ▼
┌─────────────────────────────────────────┐
│  1. Assess Impact                       │
│     • Does this change the architecture?│
│     • Does this invalidate existing code│
│     • What tests need updating?         │
└─────────────────────────────────────────┘
     │
     ├─── Small (same architecture) ───▶ Update code + tests, continue
     │
     └─── Large (architecture change) ──▶ Go back to Planning
                                              │
                                              ▼
                                         Update ADR
                                         Revise design doc
                                         Re-estimate tasks
                                         Resume implementation
```

**After Deployment:**
```
Issue/Change Request
     │
     ▼
┌─────────────────────────────────────────┐
│  Severity Assessment                    │
│  • P0: Production down → Hotfix NOW     │
│  • P1: Major bug → Fix this sprint      │
│  • P2: Minor issue → Backlog            │
│  • Feature request → New discovery      │
└─────────────────────────────────────────┘
     │
     ├─── Hotfix ──▶ Fix → Test → Deploy → Post-mortem → Update docs
     │
     └─── Feature ──▶ Mini-discovery → Planning → Implementation → ...
```

### When to Loop Back

| Situation | Go Back To | What to Update |
|-----------|------------|----------------|
| "We need a completely different approach" | Planning | ADR, design doc, task breakdown |
| "New stakeholder requirements" | Discovery | Requirements doc, user stories |
| "This feature is more complex than expected" | Planning | Task breakdown, estimates, possibly ADR |
| "Tests revealed design flaw" | Planning | Design doc, ADR if architectural |
| "Performance won't meet SLA" | Planning | ADR for optimization approach |
| "Security audit failed" | Implementation | Fix code, update security checklist |

### Change Documentation

When making significant changes, document them:

```markdown
## Change Record

**Date**: YYYY-MM-DD
**Type**: Requirement / Architecture / Implementation / Hotfix
**Triggered by**: [What caused this change]

### Original Approach
[What was planned/built]

### New Approach
[What changed and why]

### Impact
- [ ] Requirements doc updated
- [ ] ADR created/updated
- [ ] Design doc updated
- [ ] Affected code refactored
- [ ] Tests updated
- [ ] Documentation updated

### Lessons Learned
[What to do differently next time]
```

### Mini-Cycles for Changes

For changes that don't require full phase restarts:

```
┌──────────────────────────────────────────────────────────┐
│                    Mini-Cycle                            │
│                                                          │
│   Assess → Plan (brief) → Implement → Test → Review     │
│     │                                            │       │
│     └────────────── Validate ◄───────────────────┘       │
└──────────────────────────────────────────────────────────┘
```

1. **Assess**: What's the scope? Does it change architecture?
2. **Plan**: Quick task list, update ADR if needed
3. **Implement**: Make changes following existing patterns
4. **Test**: Run full validation suite
5. **Review**: Code review, check for regressions

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
- `docs/i/guides/` - Interactor integration guides (some auto-synced from external repos)

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
