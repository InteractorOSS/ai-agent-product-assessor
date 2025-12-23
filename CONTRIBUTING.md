# Contributing to Product Dev Template

This template is designed to improve over time based on real-world usage. Here's how to contribute improvements back.

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

Projects created from this template can pull in updates:

### Manual Sync

```bash
# Add template as a remote (one-time)
git remote add template https://github.com/your-org/product-dev-template.git

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
