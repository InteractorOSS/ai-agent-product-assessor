# Release Checklist

Comprehensive checklist for Elixir/Phoenix releases with validation at every step.

## Release Information

| Field | Value |
|-------|-------|
| **Version** | [X.Y.Z] |
| **Date** | [Date] |
| **Release Manager** | [Name] |
| **Type** | Major / Minor / Patch / Hotfix |

---

## Pre-Release Validation (ALL MUST PASS)

### Code Quality

```bash
# Run all validation commands
mix compile --warnings-as-errors    # Zero warnings
mix format --check-formatted        # Code formatted
mix test                            # All tests pass
mix test --cover                    # Coverage ≥ 80%
mix credo --strict                  # No credo issues
```

| Check | Command | Status |
|-------|---------|--------|
| Compiles without warnings | `mix compile --warnings-as-errors` | [ ] |
| Code formatted | `mix format --check-formatted` | [ ] |
| All tests pass | `mix test` | [ ] |
| Coverage ≥ 80% | `mix test --cover` | [ ] |
| No credo issues | `mix credo --strict` | [ ] |

### Security (ALL MUST PASS)

```bash
mix sobelow --config    # No security vulnerabilities
mix hex.audit           # No vulnerable dependencies
```

| Check | Command | Status |
|-------|---------|--------|
| Security audit | `mix sobelow` | [ ] |
| Dependency audit | `mix hex.audit` | [ ] |
| No secrets in code | Manual review | [ ] |

### Type Checking (SHOULD PASS)

```bash
mix dialyzer            # No type errors
```

| Check | Command | Status |
|-------|---------|--------|
| Dialyzer | `mix dialyzer` | [ ] |

### Database Validation

```bash
mix ecto.migrate        # Migrations run
mix ecto.rollback       # Rollback works
mix ecto.migrate        # Re-migrate works
```

| Check | Command | Status |
|-------|---------|--------|
| Migrations run | `mix ecto.migrate` | [ ] |
| Rollback works | `mix ecto.rollback` | [ ] |
| Re-migrate works | `mix ecto.migrate` | [ ] |

### Release Build (MUST PASS)

```bash
MIX_ENV=prod mix release    # Release builds successfully
```

| Check | Command | Status |
|-------|---------|--------|
| Release builds | `MIX_ENV=prod mix release` | [ ] |

---

## One-Liner Validation

Run all validation at once:

```bash
mix format --check-formatted && \
mix compile --warnings-as-errors && \
mix credo --strict && \
mix test --cover && \
mix sobelow && \
mix hex.audit && \
MIX_ENV=prod mix release
```

Or add to `mix.exs`:

```elixir
defp aliases do
  [
    "release.validate": [
      "format --check-formatted",
      "compile --warnings-as-errors",
      "credo --strict",
      "test --cover",
      "sobelow",
      "hex.audit"
    ]
  ]
end
```

Then run: `mix release.validate && MIX_ENV=prod mix release`

---

## Documentation

- [ ] CHANGELOG.md updated with release notes
- [ ] Version bumped in `mix.exs`
- [ ] README.md current and accurate
- [ ] API documentation updated
- [ ] Migration guide written (if breaking changes)
- [ ] Release notes drafted

---

## Configuration

### Environment Variables
- [ ] Variables documented in `.env.example`
- [ ] `config/runtime.exs` verified for production
- [ ] `SECRET_KEY_BASE` configured
- [ ] `DATABASE_URL` configured
- [ ] `PHX_HOST` configured

### Feature Flags
- [ ] Flags configured correctly
- [ ] Gradual rollout plan (if applicable)

### Database
- [ ] Migrations tested (`mix ecto.migrate`)
- [ ] Rollback tested (`mix ecto.rollback`)
- [ ] Backup verified

---

## Infrastructure

### Deployment
- [ ] Release builds successfully
- [ ] CI/CD pipeline configured
- [ ] Rollback procedure documented

### Monitoring
- [ ] Health endpoint configured (`/api/health`)
- [ ] Ready endpoint configured (`/api/health/ready`)
- [ ] Error tracking active (Sentry, etc.)
- [ ] Telemetry metrics flowing
- [ ] Alerts configured

### Scaling
- [ ] Ecto pool size configured
- [ ] Phoenix endpoint concurrency set
- [ ] Load balancer health checks configured

---

## Communication

### Internal
- [ ] Engineering team notified
- [ ] Support team briefed
- [ ] Stakeholders informed

### External
- [ ] Release notes prepared
- [ ] Status page ready
- [ ] Customer communication (if needed)

---

## Deployment Steps

### 1. Pre-Deployment (T-1 hour)
- [ ] Final code freeze
- [ ] Create release branch/tag
- [ ] Backup production database
- [ ] Notify team of deployment start
- [ ] Run `mix release.validate`

### 2. Staging Deployment
- [ ] Deploy release to staging
- [ ] Run migrations: `./bin/my_app eval "MyApp.Release.migrate"`
- [ ] Verify health endpoint: `curl -f https://staging.example.com/api/health`
- [ ] Run smoke tests
- [ ] Verify all features

### 3. Production Deployment
- [ ] Deploy release to production
- [ ] Run migrations
- [ ] Verify health endpoint: `curl -f https://production.example.com/api/health`
- [ ] Run smoke tests
- [ ] Verify critical paths

### 4. Post-Deployment
- [ ] Check error rates
- [ ] Verify performance metrics
- [ ] Test key user flows
- [ ] Confirm Oban jobs processing
- [ ] Verify monitoring active

---

## Smoke Tests

### Critical Paths (Must Pass)
- [ ] Health endpoint responds (200 OK)
- [ ] Ready endpoint shows all healthy
- [ ] User can log in
- [ ] User can log out
- [ ] [Critical feature 1]
- [ ] [Critical feature 2]

### Secondary Checks
- [ ] LiveView connections stable
- [ ] Forms submit correctly
- [ ] Error pages display correctly
- [ ] Static assets loading

---

## Rollback Checklist

### Rollback Triggers
- [ ] Error rate > 5%
- [ ] Critical bug discovered
- [ ] Security issue found
- [ ] Data integrity problem
- [ ] Performance severely degraded

### Rollback Steps

```bash
# 1. Stop current release
./bin/my_app stop

# 2. Rollback database (if migration caused issue)
mix ecto.rollback --step 1

# 3. Switch to previous release
ln -sfn /opt/my_app/releases/previous_version /opt/my_app/current

# 4. Start previous release
./bin/my_app start

# 5. Verify rollback
curl -f https://production.example.com/api/health
```

### Rollback Verification
- [ ] Health endpoint responds
- [ ] Error rates normalized
- [ ] Issue resolved
- [ ] Team notified
- [ ] Incident documented

---

## Post-Release

### Immediate (0-1 hour)
- [ ] Monitor error rates
- [ ] Check performance metrics
- [ ] Verify Oban jobs processing
- [ ] Watch for support tickets

### Short-term (1-24 hours)
- [ ] Continue monitoring
- [ ] Address any issues
- [ ] Gather feedback
- [ ] Update documentation

### Follow-up (1-7 days)
- [ ] Review release metrics
- [ ] Document lessons learned
- [ ] Plan fixes for any issues
- [ ] Update runbooks

---

## Sign-offs

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Engineering Lead | | | |
| QA Lead | | | |
| Product Owner | | | |
| DevOps | | | |

---

## Validation Report Template

```markdown
## Release Validation Report

**Version**: v[VERSION]
**Date**: YYYY-MM-DD HH:MM UTC
**Deployer**: [Name]

### Pre-Deployment Validation
| Check | Command | Status |
|-------|---------|--------|
| Compilation | `mix compile --warnings-as-errors` | ✓ PASS |
| Formatting | `mix format --check-formatted` | ✓ PASS |
| Tests | `mix test` | ✓ PASS ([X] tests) |
| Coverage | `mix test --cover` | ✓ PASS ([X]%) |
| Credo | `mix credo --strict` | ✓ PASS |
| Sobelow | `mix sobelow` | ✓ PASS |
| Hex Audit | `mix hex.audit` | ✓ PASS |
| Dialyzer | `mix dialyzer` | ✓ PASS |
| Release | `MIX_ENV=prod mix release` | ✓ PASS |

### Database Validation
| Check | Status |
|-------|--------|
| Migrations | ✓ PASS |
| Rollback test | ✓ PASS |

### Staging Validation
| Check | Status |
|-------|--------|
| Health endpoint | ✓ PASS |
| Ready endpoint | ✓ PASS |
| Smoke tests | ✓ PASS |

### Production Deployment
| Check | Status |
|-------|--------|
| Deploy | ✓ SUCCESS |
| Health endpoint | ✓ PASS |
| Smoke tests | ✓ PASS |
| Error rate | ✓ Normal |

### Summary
**Status**: DEPLOYMENT SUCCESSFUL
**Rollback Required**: No
**Issues**: None
```

---

## Release Notes Template

```markdown
## [Version] - [Date]

### Highlights
- [Main feature or change]

### New Features
- [Feature 1]
- [Feature 2]

### Improvements
- [Improvement 1]

### Bug Fixes
- [Fix 1]

### Breaking Changes
- [Breaking change with migration guide]

### Database Migrations
- [Migration description]

### Known Issues
- [Known issue]

### Upgrade Guide
[Steps to upgrade from previous version]
```
