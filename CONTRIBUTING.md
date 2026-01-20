# Contributing to Product Dev Template

This template is designed to improve over time based on real-world usage. Here's how to contribute improvements back.

---

## Iterative Improvement Process

The template improves through a continuous feedback loop across all projects that use it:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    Template Improvement Lifecycle                        │
└─────────────────────────────────────────────────────────────────────────┘

  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
  │   Project A  │     │   Project B  │     │   Project C  │
  │  uses template│     │  uses template│     │  uses template│
  └──────┬───────┘     └──────┬───────┘     └──────┬───────┘
         │                    │                    │
         ▼                    ▼                    ▼
  ┌──────────────────────────────────────────────────────────┐
  │              Capture Feedback During Development          │
  │                                                          │
  │  • What worked well?                                     │
  │  • What needed modification?                             │
  │  • What was missing?                                     │
  │  • What caused friction?                                 │
  │                                                          │
  │  Log in: docs/template-feedback.md                       │
  └──────────────────────────┬───────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────┐
  │                  Review at Phase Gates                    │
  │                                                          │
  │  After each phase completion, review:                    │
  │  • Did the phase documentation help?                     │
  │  • Were the checklists complete?                         │
  │  • Did skills produce good output?                       │
  │  • Were validation steps sufficient?                     │
  └──────────────────────────┬───────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────┐
  │              Contribute Back to Template                  │
  │                                                          │
  │  At project end (or anytime):                            │
  │  1. Review docs/template-feedback.md                     │
  │  2. Extract improvements worth sharing                   │
  │  3. Submit PR or Issue to template repo                  │
  │  4. Include: what changed, why, tested on which project  │
  └──────────────────────────┬───────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────┐
  │                Template Repository                        │
  │                                                          │
  │  Maintainers:                                            │
  │  • Review contributions                                  │
  │  • Merge improvements                                    │
  │  • Update CHANGELOG.md                                   │
  │  • Tag new version                                       │
  └──────────────────────────┬───────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────┐
  │              Projects Sync Updates                        │
  │                                                          │
  │  ./scripts/setup/sync-template.sh                        │
  │                                                          │
  │  Projects pull improvements from template                │
  └──────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
  │   Project A  │     │   Project B  │     │   Project D  │
  │  gets updates│     │  gets updates│     │  new project │
  └──────────────┘     └──────────────┘     └──────────────┘
```

### When to Capture Feedback

Capture feedback **as you work**, not just at the end:

| Moment | What to Log |
|--------|-------------|
| **During Discovery** | Missing intake questions, unclear templates |
| **During Planning** | Gaps in architecture templates, missing ADR scenarios |
| **During Implementation** | Code patterns that should be examples, missing rules |
| **During Testing** | Test patterns worth adding, coverage gaps |
| **During Review** | Checklist items missing, skill improvements needed |
| **During Deployment** | CI/CD examples needed, monitoring gaps |

### Where to Log Feedback

Use `docs/template-feedback.md` (created by init-project.sh):

```markdown
## Phase: Implementation
**Date**: 2024-01-15

### What Worked
- Code review skill caught security issue early

### What Needed Modification
- Added custom Oban job testing pattern to testing.md rule

### What Was Missing
- No example for testing LiveView components with JS hooks

### Suggested Improvement
- Add LiveView JS hook testing example to test-generator skill
```

### Phase Gate Reviews

At each phase transition, take 5 minutes to review:

```
Discovery → Planning
├── Were requirements templates comprehensive?
├── Did stakeholder analysis capture everyone?
└── Any questions Claude should have asked?

Planning → Implementation
├── Was architecture template sufficient?
├── Did task breakdown match actual work?
└── Any ADR scenarios missing?

Implementation → Testing
├── Were coding rules helpful?
├── Any patterns worth adding as examples?
└── Did AI collaboration guide help?

Testing → Review
├── Was test coverage guidance clear?
├── Any test patterns worth sharing?
└── Quality gates appropriate?

Review → Deployment
├── Did code review checklist catch issues?
├── Security audit thorough enough?
└── Any review steps missing?

Deployment → Done
├── Was deployment documentation complete?
├── Rollback procedures accurate?
└── Monitoring guidance sufficient?
```

---

## Template Improvement Workflow

### 1. Usage Tracking

When using this template for a project, track what works and what doesn't:

```markdown
## Template Feedback Log

### What Worked Well
- [ ] Discovery phase helped clarify requirements
- [ ] Validation caught issues early
- [ ] Skills were useful for [specific task]

### What Needed Modification
- [ ] Modified [file] because [reason]
- [ ] Added [new file/section] for [purpose]
- [ ] Removed [unused file] because [reason]

### Missing Features
- [ ] Needed [feature] but it wasn't available
- [ ] Would be helpful to have [capability]

### Pain Points
- [ ] [Description of friction encountered]
```

### 2. Contributing Changes

#### Option A: Direct Contribution (Recommended)

If you have improvements:

1. Fork the template repository
2. Create a branch for your improvement
3. Make your changes
4. Submit a Pull Request with:
   - Description of the improvement
   - Which project(s) it was tested on
   - Any validation results

#### Option B: Feedback Issues

If you don't have time for a PR:

1. Open an issue in the template repository
2. Describe the improvement needed
3. Include context about what project you were building
4. Tag with appropriate labels (enhancement, bug, documentation)

### 3. Types of Contributions

#### High-Value Contributions

- **Validation improvements**: Better checks, new validation commands
- **Skill enhancements**: More capable or accurate skills
- **Phase workflow improvements**: Better checklists, clearer guidance
- **Phoenix/Elixir patterns**: Better code examples, new patterns
- **Bug fixes**: Issues discovered during real usage

#### Documentation Improvements

- Clearer instructions
- Better examples
- Additional use cases
- Troubleshooting guides

#### New Features

- New skills for common tasks
- Additional slash commands
- New rules for specific scenarios
- Platform-specific configurations

## Contribution Guidelines

### Code Quality

All contributions should follow the same validation standards as the template itself:

```bash
# Documentation should be:
- Clear and concise
- Properly formatted (markdown)
- Tested for accuracy

# Code examples should:
- Compile without warnings
- Follow Elixir/Phoenix best practices
- Include validation commands where applicable
```

### Pull Request Template

```markdown
## Description
[What does this change do?]

## Motivation
[Why is this change needed? What problem does it solve?]

## Tested On
[Which project(s) was this tested with?]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Validation improvement
- [ ] Skill enhancement

## Checklist
- [ ] Documentation updated
- [ ] Examples tested
- [ ] No breaking changes (or documented)
```

## Syncing Template Updates to Projects

Projects created from this template can pull in updates automatically or manually.

### Automated Sync (GitHub Actions)

The template includes a workflow that automatically checks for updates:

**Setup (one-time):**
1. In your project's GitHub repo, go to **Settings** > **Secrets and variables** > **Actions**
2. Add a secret: `TEMPLATE_REPO` = `your-org/product-dev-template`

**How it works:**
- Runs weekly (Mondays 9am UTC) to check for updates
- Creates a PR automatically if updates are found
- You can also trigger manually via **Actions** > **Sync Template Updates**

**Manual trigger options:**
- `all` - Sync everything
- `skills` - Just `.claude/skills/`
- `commands` - Just `.claude/commands/`
- `rules` - Just `.claude/rules/`
- `docs` - Phase docs and checklists
- `validator` - Validator skill and checklist

### Manual Sync

```bash
# Add template as a remote (one-time)
git remote add template https://github.com/pulzze/product-dev-template.git

# Fetch template updates
git fetch template

# Review changes
git diff HEAD template/main -- .claude/ docs/

# Cherry-pick specific improvements
git checkout template/main -- .claude/skills/validator/SKILL.md
git checkout template/main -- docs/checklists/validation-checklist.md

# Or merge entire updates (careful with conflicts)
git merge template/main --allow-unrelated-histories
```

### Selective Updates

You can update specific parts:

```bash
# Update only skills
git checkout template/main -- .claude/skills/

# Update only validation checklist
git checkout template/main -- docs/checklists/validation-checklist.md

# Update only deployment skill
git checkout template/main -- .claude/skills/deployment/
```

---

## Syncing External Documentation

Some documentation files are automatically synchronized from external Interactor repositories (e.g., authentication guides from `pulzze/account-server`).

### Auto-Synced Files

| File | Source Repository | Sync Frequency |
|------|-------------------|----------------|
| `docs/i/guides/interactor-authentication.md` | `pulzze/account-server/docs/integration-guide.md` | Daily at 6am UTC |

### How External Doc Sync Works

1. **Automated Daily Sync:**
   - GitHub Actions workflow (`.github/workflows/sync-external-docs.yml`) runs daily
   - Checks upstream repository for changes
   - Updates local file and metadata if changes detected
   - Commits directly to `main` branch

2. **Manual Sync:**
   ```bash
   # Sync specific document
   ./scripts/setup/sync-external-docs.sh interactor-auth

   # Interactive mode
   ./scripts/setup/sync-external-docs.sh

   # Preview changes without applying
   ./scripts/setup/sync-external-docs.sh --dry-run interactor-auth
   ```

3. **Manual Workflow Trigger:**
   - Go to **Actions** tab → "Sync External Documentation"
   - Click **"Run workflow"**
   - Options:
     - `target_branch`: Which branch to sync to (default: `main`)
     - `create_pr`: Create PR instead of direct push (default: `false`)

### Metadata Tracking

Each synced file has a corresponding metadata file (e.g., `.interactor-auth-meta.json`) containing:
- Source repository and path
- Commit SHA of synced content
- Sync timestamp and user
- Content SHA256 hash for integrity verification

### Handling Sync Conflicts

If you've made local modifications to an auto-synced file:

1. **Preserve your changes:**
   ```bash
   # Backup your modifications
   cp docs/i/guides/interactor-authentication.md docs/i/guides/interactor-authentication.md.local

   # Sync latest from upstream
   ./scripts/setup/sync-external-docs.sh interactor-auth

   # Manual merge if needed
   vimdiff docs/i/guides/interactor-authentication.md.local docs/i/guides/interactor-authentication.md
   ```

2. **Disable auto-sync for specific file:**
   - Comment out the file entry in `scripts/setup/sync-external-docs.sh`
   - Remove the corresponding job from `.github/workflows/sync-external-docs.yml`
   - Document your customizations in `docs/template-feedback.md`

3. **Contribute changes upstream:**
   - If your modifications improve the guide, contribute them back to the source repository
   - Submit PR to `pulzze/account-server` so all projects benefit

### Adding New External Docs

To sync additional external documentation:

1. **Update script configuration** in `scripts/setup/sync-external-docs.sh`:
   ```bash
   declare -A EXTERNAL_DOCS=(
     ["interactor-auth"]="pulzze/account-server|docs/integration-guide.md|docs/i/guides/interactor-authentication.md|docs/i/guides/.interactor-auth-meta.json"
     ["new-doc"]="owner/repo|path/to/source.md|docs/i/guides/target.md|docs/i/guides/.target-meta.json"
   )
   ```

2. **Add workflow job** in `.github/workflows/sync-external-docs.yml` following the existing pattern

3. **Test locally:**
   ```bash
   ./scripts/setup/sync-external-docs.sh --dry-run new-doc
   ./scripts/setup/sync-external-docs.sh new-doc
   ```

4. **Document** in `docs/i/guides/README.md` and update this section

### Troubleshooting External Doc Sync

**Authentication errors:**
- Verify `GITHUB_TOKEN` has access to source repository
- For private repos, ensure token has `repo` scope

**File not found (404):**
- Verify source path is correct in configuration
- Check if file was moved or renamed in source repository

**Content appears outdated:**
- Check metadata file for last sync timestamp
- Force fresh sync by deleting metadata file and running sync again

For detailed troubleshooting, see `docs/i/guides/README.md`.

---

## Versioning

The template uses semantic versioning:

- **MAJOR**: Breaking changes to workflow or structure
- **MINOR**: New features, skills, or commands
- **PATCH**: Bug fixes, documentation improvements

Check `CHANGELOG.md` for version history and upgrade notes.

## Feedback Channels

- **GitHub Issues**: Bug reports and feature requests
- **Pull Requests**: Direct contributions
- **Discussions**: General feedback and questions

## Recognition

Contributors will be acknowledged in:
- `CHANGELOG.md` for their specific contributions
- `CONTRIBUTORS.md` for ongoing contributors
