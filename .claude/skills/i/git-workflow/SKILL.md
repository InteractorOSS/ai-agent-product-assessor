# Git Workflow Skill

Standards for version control, branching, and collaboration.

## Quick Reference

### Branch Types
| Type | Pattern | Purpose |
|------|---------|---------|
| `main` | `main` | Production-ready code |
| `develop` | `develop` | Integration branch |
| `feature` | `feature/<name>` | New features |
| `bugfix` | `bugfix/<name>` | Bug fixes |
| `hotfix` | `hotfix/<name>` | Production fixes |
| `release` | `release/<version>` | Release preparation |

### Commit Message Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:** feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert

### Example Commits
```bash
feat(auth): add password reset functionality
fix(api): handle null user in profile endpoint
docs(readme): update installation instructions
```

---

## Detailed Guidelines

### Branch Naming
```bash
# Good
feature/user-authentication
feature/ABC-123-add-payment-processing
bugfix/fix-login-redirect
hotfix/security-patch-xss
release/v1.2.0

# Bad
feature/new-stuff
john/my-changes
fix
temp
```

### Commit Rules
1. Subject line: Max 72 characters, imperative mood
2. Body: Explain what and why (not how)
3. Footer: Reference issues, breaking changes

### PR Description Template
```markdown
## Summary
Brief description of what this PR does.

## Changes
- Change 1
- Change 2

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing performed

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests pass locally
```

### PR Size Guidelines
| Size | Lines | Review Time |
|------|-------|-------------|
| Small | < 200 | < 30 min |
| Medium | 200-500 | 30-60 min |
| Large | 500-1000 | 1-2 hours |
| Too Large | > 1000 | Split it! |

### Code Review Feedback Types
```markdown
🔴 **[Required]**: Must be addressed
🟡 **[Suggestion]**: Should consider
🟢 **[Nit]**: Optional improvement
❓ **[Question]**: For understanding
👍 **[Nice]**: Positive feedback
```

### Merge Strategies
| Strategy | When to Use |
|----------|-------------|
| Squash merge | Feature branches with messy history |
| Merge commit | Release branches, preserving history |
| Rebase | Keeping linear history (small PRs) |

### Daily Workflow
```bash
# Start new feature
git checkout develop && git pull origin develop
git checkout -b feature/my-feature

# Work and commit
git add . && git commit -m "feat: add new functionality"

# Keep up to date
git fetch origin && git rebase origin/develop

# Push
git push origin feature/my-feature
```

### Semantic Versioning
```
MAJOR.MINOR.PATCH
1.0.0 - Initial release
1.0.1 - Patch: bug fixes
1.1.0 - Minor: new features (backward compatible)
2.0.0 - Major: breaking changes
```

### Protected Branch Rules
**main:**
- No direct pushes
- Require PR with approval
- Require passing CI
- No force pushes

**develop:**
- No direct pushes
- Require PR with approval
- Require passing CI
