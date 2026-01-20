# Product Development Template - Template Components

A comprehensive AI-driven development template with built-in validation, code quality tools, and best practices for Elixir/Phoenix applications.

**Note**: This README covers the shareable template components (in `/i/` folders). For project setup instructions, see your internal documentation.

---

## What This Template Provides

- **AI-Powered Development Tools** - Skills, commands, and rules optimized for Claude Code
- **Continuous Validation** - Validator skill ensures correctness at every step
- **Code Quality** - Automated code review, security audits, and test generation
- **Best Practices** - Coding standards, testing patterns, documentation templates
- **Comprehensive Documentation** - Guides and checklists for ongoing development

---

## Prerequisites

- [Claude Code](https://claude.ai/claude-code) installed
- Git
- Elixir 1.15+ with OTP 26+
- Phoenix 1.7+
- PostgreSQL

---

## Quick Start

For already-configured projects, start the development environment:

```bash
./scripts/start.sh
```

**The start script automatically:**
- ✅ Validates prerequisites (Elixir, Node.js, PostgreSQL)
- ✅ Installs/updates dependencies
- ✅ Runs database migrations
- ✅ Starts the Phoenix development server
- ✅ Opens http://localhost:4000 in your browser

**Common Development Commands:**

```bash
# Start development server
./scripts/start.sh

# Run tests
mix test

# Run with coverage
mix test --cover

# Format code
mix format

# Run quality checks
mix credo --strict

# Security audit
mix sobelow
```

---

## Project Structure - Template Components

The `/i/` folder convention indicates template-owned files that are safe to sync:

```
.claude/
├── agents/i/              # Template-provided agents
├── assets/i/              # Brand assets (logos, icons)
├── commands/i/            # General-purpose commands
│   ├── run-review.md
│   ├── prepare-release.md
│   ├── handle-change.md
│   └── debug-ui-logs.md
├── rules/i/               # Development standards (auto-applied)
│   ├── code-style.md
│   ├── testing.md
│   ├── security.md
│   ├── documentation.md
│   ├── git-workflow.md
│   └── ui-design.md
├── skills/i/              # Development skills
│   ├── validator/         # ⭐ Use frequently!
│   ├── code-review/
│   ├── security-audit/
│   ├── test-generator/
│   ├── deployment/
│   ├── doc-generator/
│   └── ui-design/
└── templates/i/           # Code templates

docs/i/                    # Template documentation
├── guides/                # Integration guides
│   └── interactor-authentication.md
├── ui-design/             # UI design system
│   ├── material-ui/
│   ├── buttons.md
│   ├── forms.md
│   ├── colors.md
│   └── ...
└── checklists/
    └── validation-checklist.md

scripts/i/                 # Template scripts
└── sync-template.sh       # Sync template updates
```

---

## Using Template Skills

Skills provide specialized AI capabilities. Invoke with: `use <skill-name> skill`

### Core Skills

| Skill | Purpose | When to Use |
|-------|---------|-------------|
| **`validator`** | ⭐ Validate any artifact | After generating ANY output |
| `code-review` | Comprehensive code analysis | Before merging code |
| `security-audit` | OWASP-based security scan | Before deployment |
| `test-generator` | Generate test scaffolds | When creating new features |
| `deployment` | Deployment preparation | Before releases |
| `doc-generator` | Auto-generate documentation | When code structure changes |
| `ui-design` | Validate UI compliance | Before completing UI work |

### Example Usage

```
# Validate requirements document
use validator skill to check these requirements

# Comprehensive code review
use code-review skill for the UserController module

# Security audit before deployment
use security-audit skill on the authentication system

# Generate tests for new feature
use test-generator skill to create tests for the Order module

# Validate UI design compliance
use ui-design skill to validate the dashboard layout
```

**Pro Tip**: Use the `validator` skill frequently - it catches issues early!

---

## Using Template Commands

Commands automate common workflows. Execute with: `/<command-name>`

| Command | Purpose |
|---------|---------|
| `/run-review` | Execute comprehensive code review workflow |
| `/prepare-release` | Run release checklist and validation |
| `/handle-change` | Process requirement/design changes mid-project |
| `/debug-ui-logs` | Debug UI issues with log analysis |

---

## Template Rules (Auto-Applied)

Rules in `.claude/rules/i/` are automatically applied to matching files:

| Rule | Applies To | Purpose |
|------|-----------|---------|
| **code-style.md** | `**/*.ex`, `**/*.exs` | Elixir formatting and conventions |
| **testing.md** | `**/*_test.exs` | Testing standards and coverage |
| **security.md** | All files | Security best practices |
| **documentation.md** | `**/*.md`, code files | Documentation standards |
| **git-workflow.md** | All files | Git commit and branching |
| **ui-design.md** | `**/*.heex`, `**/*.css`, UI components | UI design standards |

These rules guide Claude Code automatically - no need to manually invoke them.

---

## Validation at Every Step

The template enforces validation at every phase. After generating any artifact:

### Essential Validation Commands

```bash
# Must pass after every code change
mix compile --warnings-as-errors  # Must pass
mix format --check-formatted      # Must pass
mix test                          # Must pass

# Should pass before commits
mix credo --strict               # Should pass
mix test --cover                 # Coverage ≥ 80%

# Must pass before deployment
mix sobelow --config             # Security check
mix hex.audit                    # Dependency audit
MIX_ENV=prod mix release         # Release builds
```

### Quick Validation One-Liners

```bash
# Pre-commit validation
mix format && mix compile --warnings-as-errors && mix credo --strict && mix test

# Full validation suite
mix format --check-formatted && mix compile --warnings-as-errors && \
mix credo --strict && mix test --cover && mix sobelow && mix hex.audit
```

---

## Keeping the Template Updated

Projects using this template can pull in improvements using the sync script.

### Sync Template Updates

```bash
# Interactive sync (recommended)
./scripts/i/sync-template.sh

# Select from menu:
#   1) Agents
#   2) Assets (brand + icons)
#   3) Commands
#   4) Rules
#   5) Skills
#   6) Scripts
#   7) Documentation
#   8) Validator only
#   9) All (use with caution)
```

### Sync Specific Components

```bash
# Sync just skills
./scripts/i/sync-template.sh skills

# Sync validator skill only
./scripts/i/sync-template.sh validator

# Sync documentation
./scripts/i/sync-template.sh docs

# Sync everything (reviews changes first)
./scripts/i/sync-template.sh all
```

### What Gets Synced

The sync script **only** syncs files in `/i/` folders:
- ✅ `.claude/agents/i/`
- ✅ `.claude/assets/i/`
- ✅ `.claude/commands/i/`
- ✅ `.claude/rules/i/`
- ✅ `.claude/skills/i/`
- ✅ `.claude/templates/i/`
- ✅ `scripts/i/`
- ✅ `docs/i/`

**Protected** (never synced):
- ❌ Your `CLAUDE.md` (project-specific)
- ❌ Your custom files outside `/i/`
- ❌ Setup methodology folders

### Automatic Sync (GitHub Actions)

Set up weekly automatic sync checking:

1. The included workflow runs weekly
2. Creates a PR when template updates are available
3. Or trigger manually: **Actions** > **Sync Template Updates** > **Run workflow**

---

## Contributing Improvements

Found something useful? Contribute back to help others!

### How to Contribute

1. **Track What Works**: Document improvements in `docs/templates/template-feedback.md`
2. **Fork the Template**: `https://github.com/your-org/product-dev-template`
3. **Make Your Changes**: Improve skills, rules, or documentation
4. **Submit a PR**: Describe what was improved and why

### What to Contribute

- **New Skills**: Domain-specific AI capabilities
- **Better Rules**: Improved coding standards
- **Documentation**: Clearer guides or examples
- **Bug Fixes**: Corrections to existing content
- **UI Components**: Reusable design patterns

See `CONTRIBUTING.md` for detailed guidelines.

---

## Customization

### Modify CLAUDE.md (Your Project Config)

Customize for your project:
- Project name and type
- Technology stack specifics
- Custom workflows
- Phase overrides

### Add Custom Skills

Create in `.claude/skills/my-skill/SKILL.md`:

```markdown
---
name: my-skill
description: What this skill does
allowed-tools: [Read, Write, Edit]
---

# My Skill

## When to Use
[Trigger conditions]

## Instructions
[What Claude should do]
```

**Note**: Custom skills go in `.claude/skills/` (not `/i/`) so they're yours.

### Add Custom Rules

Create in `.claude/rules/my-rule.md`:

```markdown
---
paths: ["src/**/*.ex"]  # Optional: apply to specific files
alwaysApply: true
---

# My Rule

[Rule content that applies to your project]
```

**Note**: Custom rules go in `.claude/rules/` (not `/i/`) so they're yours.

### Extend Template Skills

You can create wrappers that invoke template skills with your defaults:

```markdown
---
name: my-validator
description: Validate with project-specific checks
---

# My Validator

First, use the validator skill from the template:
[Invoke template validator]

Then apply these additional checks:
- Custom validation 1
- Custom validation 2
```

---

## MCP Servers

Pre-configured MCP servers in `.mcp.json`:

| Server | Purpose | Status |
|--------|---------|--------|
| **filesystem** | File system access | Enabled |
| **github** | GitHub integration | Disabled by default |
| **postgres** | PostgreSQL access | Disabled by default |
| **memory** | Persistent memory | Disabled by default |

**To Enable**: Set `"disabled": false` in `.mcp.json`

---

## Technology Stack

This template is optimized for:

- **Elixir 1.15+** with OTP 26+
- **Phoenix 1.7+** with LiveView
- **PostgreSQL** with Ecto
- **Oban** for background jobs
- **TailwindCSS** for styling

All validation commands, skills, and examples follow Elixir/Phoenix best practices.

---

## UI Design System

The template includes a comprehensive UI design system in `docs/i/ui-design/`:

### Universal Standards (Auto-Applied)

`.claude/rules/i/ui-design.md` enforces:
- Color palette (primary green `#4CD964`)
- Border radius standards (pill-shaped buttons)
- Spacing scale (8px, 12px, 16px, 24px)
- Typography system
- Icon styles (outlined, stroke-width 1.5)
- Accessibility requirements (WCAG AA minimum)

### Material UI Patterns (Optional)

If using Material UI layout, see `docs/i/ui-design/material-ui/`:
- 3-panel layout (AppBar + Drawer + Content)
- Lottie animated logo
- Quick Create button patterns
- Notification badge patterns
- Feedback section patterns

### UI Validation

Before completing UI work:

```
use ui-design skill to validate this component
```

The skill validates:
- ✅ Universal standards compliance
- ✅ Framework-specific patterns (if applicable)
- ✅ Accessibility requirements
- ✅ Dark mode support
- ✅ Responsive design

---

## File Organization

### Template Files (in `/i/` - Safe to Sync)

```
.claude/
├── commands/i/      # Template commands
├── rules/i/         # Template rules
├── skills/i/        # Template skills
└── templates/i/     # Code templates

docs/i/              # Template documentation
scripts/i/           # Template scripts
```

### Your Files (outside `/i/` - Your Customizations)

```
.claude/
├── commands/        # Your custom commands
├── rules/           # Your custom rules
└── skills/          # Your custom skills

docs/
├── project-idea-intake.md    # Your project info
└── (your docs)

CLAUDE.md            # Your project configuration
```

**Convention**: Anything in `/i/` belongs to the template. Anything outside `/i/` is yours.

---

## Getting Help

### Template Issues

If you find issues with template components:
1. Check if newer version available: `./scripts/i/sync-template.sh`
2. Report in template repository issues
3. Submit PR with fix

### Project Issues

For project-specific problems:
1. Use the `validator` skill to check artifacts
2. Use the `code-review` skill for code quality
3. Use the `security-audit` skill for security issues
4. Consult `.claude/rules/i/` for standards

---

## License

MIT License - See [LICENSE](LICENSE) for details.

---

## Summary

This template provides:
- ✅ Comprehensive AI development skills
- ✅ Automated validation and code review
- ✅ Best practice enforcement through rules
- ✅ Easy syncing of template improvements
- ✅ Complete UI design system
- ✅ Security and quality standards

**Focus on building your product** - the template handles development best practices.

---

Built with Claude Code best practices. Happy coding! 🚀
