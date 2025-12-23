# Prepare Release

Prepare for deployment with comprehensive release checklist and validation.

## Instructions

When this command is invoked, perform the following:

### 1. Entry Validation

Before starting release preparation, verify all review checks passed:
```
"Run full validation before deployment"
```

### 2. Gather Release Information

Ask for:
- Version number (semantic versioning)
- Release type (major/minor/patch)
- Target environment (staging/production)

### 3. Execute Pre-Release Validation

Run ALL validation commands - every check must pass:

```bash
# Required - ALL MUST PASS
mix compile --warnings-as-errors    # Zero warnings
mix format --check-formatted        # Code formatted
mix test                            # All tests pass
mix test --cover                    # Coverage ≥ 80%
mix credo --strict                  # No credo issues

# Security - MUST PASS
mix sobelow --config                # No security issues
mix hex.audit                       # No vulnerable dependencies

# Type checking - SHOULD PASS
mix dialyzer                        # No type errors

# Release build - MUST PASS
MIX_ENV=prod mix release            # Release builds successfully
```

### 4. Pre-Release Checklist

#### Code Quality
- [ ] All tests passing (`mix test`)
- [ ] Code coverage ≥ 80% (`mix test --cover`)
- [ ] No compiler warnings (`mix compile --warnings-as-errors`)
- [ ] Code formatted (`mix format --check-formatted`)
- [ ] No credo issues (`mix credo --strict`)

#### Security
- [ ] Security audit passed (`mix sobelow`)
- [ ] No vulnerable dependencies (`mix hex.audit`)
- [ ] No secrets in codebase
- [ ] Environment variables documented

#### Documentation
- [ ] CHANGELOG updated
- [ ] README current
- [ ] API docs updated
- [ ] Migration guide (if breaking changes)

### 5. Display Release Checklist

```markdown
## Release Checklist v[VERSION]

### Pre-Release Validation (ALL MUST PASS)
| Check | Command | Status |
|-------|---------|--------|
| Compiles | `mix compile --warnings-as-errors` | |
| Formatted | `mix format --check-formatted` | |
| Tests | `mix test` | |
| Coverage | `mix test --cover` (≥80%) | |
| Credo | `mix credo --strict` | |
| Security | `mix sobelow` | |
| Dependencies | `mix hex.audit` | |
| Dialyzer | `mix dialyzer` | |
| Release | `MIX_ENV=prod mix release` | |

### Documentation
- [ ] CHANGELOG.md updated
- [ ] Version bumped in mix.exs
- [ ] README.md current
- [ ] API documentation updated
- [ ] Release notes drafted

### Configuration
- [ ] Environment variables documented in `.env.example`
- [ ] Production config verified (`config/runtime.exs`)
- [ ] Secrets configured in deployment environment
- [ ] Feature flags configured (if applicable)

### Database
- [ ] Migrations tested on staging (`mix ecto.migrate`)
- [ ] Rollback tested (`mix ecto.rollback`)
- [ ] Backup verified
- [ ] Data migration plan (if needed)

### Infrastructure
- [ ] Release builds successfully
- [ ] Health check endpoint responds (`/health` or `/api/health`)
- [ ] Rollback procedure documented
- [ ] Monitoring/alerting configured

### Communication
- [ ] Team notified
- [ ] Stakeholders informed
- [ ] Support team briefed
- [ ] Status page ready

### Post-Deployment Plan
- [ ] Smoke tests defined
- [ ] Monitoring dashboard ready
- [ ] Rollback criteria defined
- [ ] On-call schedule confirmed
```

### 6. Generate Release Notes

```markdown
## Release Notes v[VERSION]

**Release Date**: [Date]
**Release Type**: [Major/Minor/Patch]

### Highlights
- [Key feature or change]

### New Features
- [Feature 1]
- [Feature 2]

### Improvements
- [Improvement 1]

### Bug Fixes
- [Fix 1]

### Breaking Changes
- [Breaking change with migration guide]

### Security Updates
- [Security fix]

### Dependencies Updated
- [Dependency changes]

### Known Issues
- [Any known issues]

### Upgrade Guide
[Steps to upgrade from previous version]
```

### 7. Use Deployment Skill

Invoke the `deployment` skill for:
- Detailed deployment procedures
- Monitoring setup
- Rollback procedures

## Output

```markdown
## Release Preparation Started

**Version**: v[VERSION]
**Type**: [Major/Minor/Patch]
**Target**: [Environment]

### Running Pre-Release Validation...

#### Validation Results
| Check | Status | Output |
|-------|--------|--------|
| Compilation | ✓ PASS | 0 warnings |
| Formatting | ✓ PASS | All files formatted |
| Tests | ✓ PASS | 42 tests, 0 failures |
| Coverage | ✓ PASS | 87.3% |
| Credo | ✓ PASS | 0 issues |
| Sobelow | ✓ PASS | No vulnerabilities |
| Hex Audit | ✓ PASS | No vulnerable deps |
| Dialyzer | ✓ PASS | No warnings |
| Release Build | ✓ PASS | Release created |

### Database Validation
- Migrations: ✓ Run successfully
- Rollback: ✓ Tested successfully

### Checklist Status
- [X] All validation checks pass
- [X] Security audit complete
- [ ] CHANGELOG updated
- [ ] Version bumped in mix.exs
- [ ] Release notes drafted

### Actions Required
1. Update CHANGELOG.md with release notes
2. Bump version in mix.exs
3. Create release notes
4. Tag release in git

### Quick Actions
- "Update the CHANGELOG for this release"
- "Generate release notes"
- "Create the git tag for v[VERSION]"
- "Review the deployment checklist"

Ready to proceed with release preparation?
```

## Deployment Validation

### Pre-Deployment Validation (Staging)

Before deploying to production, validate on staging:

```bash
# Deploy to staging
MIX_ENV=prod mix release
# Deploy release to staging environment

# Run staging validation
curl -f https://staging.example.com/health
mix run priv/repo/seeds.exs  # If needed

# Run smoke tests against staging
mix test --only integration
```

### Production Deployment Validation

After deploying to production:

```bash
# Health check
curl -f https://production.example.com/health

# Verify application started
# Check logs for successful boot

# Run smoke tests
mix test --only smoke
```

### Post-Deployment Validation Checklist

- [ ] Health endpoint responds (200 OK)
- [ ] Application logs show successful startup
- [ ] Database connections established
- [ ] Background jobs running (Oban dashboard)
- [ ] No errors in error tracking (Sentry, etc.)
- [ ] Metrics flowing to monitoring (if configured)

### Rollback Validation

If rollback is needed:

```bash
# Rollback database migrations
mix ecto.rollback --step 1

# Deploy previous release
# (depends on deployment platform)

# Verify rollback successful
curl -f https://production.example.com/health
```

### Validation Report

Generate a deployment validation report:

```markdown
## Deployment Validation Report

**Version**: v[VERSION]
**Date**: YYYY-MM-DD HH:MM UTC
**Environment**: Production
**Deployer**: [Name/Claude]

### Pre-Deployment Validation
| Check | Status |
|-------|--------|
| mix compile --warnings-as-errors | ✓ PASS |
| mix format --check-formatted | ✓ PASS |
| mix test | ✓ PASS (X tests) |
| mix test --cover | ✓ PASS (X%) |
| mix credo --strict | ✓ PASS |
| mix sobelow | ✓ PASS |
| mix hex.audit | ✓ PASS |
| MIX_ENV=prod mix release | ✓ PASS |

### Staging Validation
| Check | Status |
|-------|--------|
| Health endpoint | ✓ PASS |
| Smoke tests | ✓ PASS |
| Database migrations | ✓ PASS |

### Production Validation
| Check | Status |
|-------|--------|
| Deployment | ✓ SUCCESS |
| Health endpoint | ✓ PASS |
| Application logs | ✓ Normal |
| Error rate | ✓ < 0.1% |
| Response time | ✓ p99 < 200ms |

### Summary
**Status**: DEPLOYMENT SUCCESSFUL
**Rollback Required**: No
**Issues**: None

### Monitoring Links
- Dashboard: [URL]
- Logs: [URL]
- Errors: [URL]
```

## Exit Gate

Deployment is complete when:
- [ ] All pre-deployment validation passed
- [ ] Staging deployment validated
- [ ] Production deployment successful
- [ ] Health checks passing
- [ ] No elevated error rates
- [ ] Monitoring confirmed active
- [ ] Stakeholders notified
