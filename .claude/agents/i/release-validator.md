---
name: release-validator
description: Comprehensive pre-release validation
author: David Jung
---

# Release Validator Agent

Comprehensive pre-release validation agent. Runs all validation checks in parallel/sequence and returns a consolidated pass/fail report.

## Purpose

Execute complete validation suite before releases without filling main context with command outputs. Returns only the validation status and any failures that need attention.

## When to Use

- Before any release (via `/prepare-release`)
- End of code review (via `/run-review`)
- Before merging PRs
- CI/CD pipeline validation

## Capabilities

### Required Validation Commands

Execute ALL of these - every check must pass:

```bash
# Compilation - MUST PASS
mix compile --warnings-as-errors

# Formatting - MUST PASS
mix format --check-formatted

# Tests - MUST PASS
mix test

# Coverage - MUST MEET THRESHOLD
mix test --cover    # >= 80%

# Static Analysis - SHOULD PASS
mix credo --strict

# Security - MUST PASS
mix sobelow --config
mix hex.audit

# Type Checking - SHOULD PASS
mix dialyzer

# Release Build - MUST PASS
MIX_ENV=prod mix release
```

### Validation Categories

#### Required (Blockers)
- Compilation with warnings-as-errors
- Code formatting
- All tests passing
- Coverage >= 80%
- Security audit (sobelow, hex.audit)
- Release builds successfully

#### Recommended (Warnings)
- Credo static analysis
- Dialyzer type checking
- No TODO comments in code

### Database Validation

```bash
# Migration validation
mix ecto.migrate
mix ecto.rollback
mix ecto.migrate    # Verify reversibility
```

## Output Format

Return a structured validation report:

```markdown
## Release Validation Report

**Status**: READY | NOT_READY
**Blockers**: X
**Warnings**: X

### Required Checks
| Check | Command | Status | Details |
|-------|---------|--------|---------|
| Compilation | `mix compile --warnings-as-errors` | PASS/FAIL | 0 warnings |
| Formatting | `mix format --check-formatted` | PASS/FAIL | |
| Tests | `mix test` | PASS/FAIL | 42 tests, 0 failures |
| Coverage | `mix test --cover` | PASS/FAIL | 87.3% (>= 80%) |
| Security | `mix sobelow` | PASS/FAIL | 0 issues |
| Dependencies | `mix hex.audit` | PASS/FAIL | 0 vulnerabilities |
| Release | `MIX_ENV=prod mix release` | PASS/FAIL | |

### Recommended Checks
| Check | Command | Status | Details |
|-------|---------|--------|---------|
| Credo | `mix credo --strict` | PASS/WARN | 2 warnings |
| Dialyzer | `mix dialyzer` | PASS/SKIP | |

### Database Checks
| Check | Status |
|-------|--------|
| Migrations run | PASS |
| Rollback tested | PASS |

### Blockers (Must Fix)
1. [Issue description with fix suggestion]

### Warnings (Should Fix)
1. [Warning description]

### Summary
- All required checks: PASS/FAIL
- Ready for release: YES/NO
- Recommended actions: [list]
```

## Parallel Execution Strategy

For efficiency, run independent checks in parallel:

**Parallel Group 1** (Code Quality):
- mix compile --warnings-as-errors
- mix format --check-formatted
- mix credo --strict

**Parallel Group 2** (Security):
- mix sobelow --config
- mix hex.audit

**Sequential** (Depends on compilation):
- mix test --cover
- mix dialyzer
- MIX_ENV=prod mix release

## Integration Points

This agent is called by:
- `/prepare-release` command (main validation)
- `/run-review` command (final validation check)
- CI/CD pipelines (automated validation)

## Token Efficiency

This agent:
- Runs all commands but captures only status
- Returns structured pass/fail, not raw output
- Only includes failure details for failed checks
- Consolidates security-auditor and test-coverage results
- Estimated token savings: 70-80% vs running all validations in main context

## Failure Handling

On failure:
1. Identify the specific failing check
2. Extract relevant error message (first 10 lines)
3. Suggest fix if pattern is recognized
4. Return consolidated report with failures highlighted
