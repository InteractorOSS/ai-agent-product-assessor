---
name: validator
description: Validate artifacts, code, and deliverables for correctness at each development phase. Use this skill proactively after generating any output to ensure quality and correctness.
---

# Validator Skill

Ensure correctness of all generated artifacts throughout the development lifecycle.

## When to Use

- **After generating any artifact** (requirements, designs, code, tests)
- **Before transitioning phases** (discovery → planning → implementation)
- **After code generation** (schemas, contexts, LiveViews)
- **Before commits and PRs**
- **On demand** when user requests validation

## Validation Types

### 1. Requirements Validation

After generating requirements or user stories:

```markdown
## Requirements Validation Checklist

### Completeness
- [ ] All user types/personas identified
- [ ] Happy path and edge cases covered
- [ ] Non-functional requirements specified (performance, security, scalability)
- [ ] Acceptance criteria defined for each requirement
- [ ] Dependencies between requirements identified

### Clarity
- [ ] No ambiguous language ("should", "might", "could" → "must", "will")
- [ ] Measurable success criteria
- [ ] Clear scope boundaries (what's NOT included)
- [ ] Technical terms defined

### Consistency
- [ ] No contradicting requirements
- [ ] Terminology used consistently
- [ ] Aligns with stated problem/opportunity

### Feasibility
- [ ] Technically achievable with chosen stack
- [ ] Resource requirements realistic
- [ ] Timeline considerations noted
```

### 2. Architecture Validation

After generating architecture or design documents:

```markdown
## Architecture Validation Checklist

### Technical Correctness
- [ ] Phoenix contexts have clear boundaries
- [ ] No circular dependencies between contexts
- [ ] Data model supports all identified use cases
- [ ] API design follows REST conventions
- [ ] Database schema is normalized appropriately

### Elixir/Phoenix Specific
- [ ] Contexts don't leak implementation details
- [ ] Schemas have proper validations in changesets
- [ ] Associations are correctly defined (has_many, belongs_to)
- [ ] Indexes planned for query patterns
- [ ] PubSub topics defined for real-time features

### Scalability
- [ ] Identified potential bottlenecks
- [ ] Caching strategy defined where needed
- [ ] Background job patterns appropriate (Oban)
- [ ] Database query patterns optimized

### Security
- [ ] Authentication flow secure
- [ ] Authorization boundaries clear
- [ ] Input validation at boundaries
- [ ] Sensitive data handling defined
```

### 3. Code Validation

After generating any code:

```markdown
## Code Validation Checklist

### Syntax & Compilation
- [ ] Code compiles without errors (`mix compile`)
- [ ] No compiler warnings
- [ ] Formatting correct (`mix format --check-formatted`)

### Elixir Best Practices
- [ ] Pattern matching used appropriately
- [ ] Pipe operator for data transformations
- [ ] Consistent {:ok, result} | {:error, reason} returns
- [ ] Bang functions (!) used only when failure is exceptional
- [ ] No anti-patterns (deeply nested conditionals, magic values)

### Phoenix Patterns
- [ ] Controllers thin, contexts handle logic
- [ ] LiveView follows mount/handle_params/handle_event pattern
- [ ] Components are reusable and well-typed
- [ ] Router scopes organized logically

### Ecto Correctness
- [ ] Migrations are reversible
- [ ] Changesets validate all required fields
- [ ] Associations preloaded to avoid N+1
- [ ] Transactions used for multi-step operations
```

### 4. Test Validation

After generating tests:

```markdown
## Test Validation Checklist

### Coverage
- [ ] All public context functions tested
- [ ] Happy path and error cases covered
- [ ] Edge cases identified and tested
- [ ] LiveView interactions tested

### Test Quality
- [ ] Tests are independent (no shared state)
- [ ] Fixtures used consistently
- [ ] Async tests where possible (`async: true`)
- [ ] Meaningful assertions (not just "doesn't crash")

### Execution
- [ ] All tests pass (`mix test`)
- [ ] No flaky tests
- [ ] Coverage meets threshold (`mix test --cover`)
```

### 5. Database Migration Validation

After generating migrations:

```markdown
## Migration Validation Checklist

### Correctness
- [ ] Table and column names follow convention (snake_case, plural tables)
- [ ] Primary keys correct (`:binary_id` if using UUIDs)
- [ ] Foreign keys reference correct tables
- [ ] Indexes created for foreign keys and query patterns
- [ ] Constraints defined (unique, not null, check)

### Safety
- [ ] Migration is reversible (has `down` or uses `change`)
- [ ] No destructive operations on production data
- [ ] Large table alterations use safe patterns
- [ ] Default values set for new non-null columns

### Verification
- [ ] Migration runs successfully (`mix ecto.migrate`)
- [ ] Rollback works (`mix ecto.rollback`)
- [ ] Schema matches migration (`mix ecto.dump`)
```

## Validation Commands

Run these commands to validate generated code:

```bash
# Compilation & Formatting
mix compile --warnings-as-errors
mix format --check-formatted

# Static Analysis
mix credo --strict
mix dialyzer

# Security
mix sobelow --config

# Tests
mix test
mix test --cover

# Database
mix ecto.migrate
mix ecto.rollback
mix ecto.migrate
```

## Automated Validation Process

When validating any artifact, follow this process:

### Step 1: Identify Artifact Type
Determine what was generated (requirements, code, tests, etc.)

### Step 2: Run Appropriate Checklist
Apply the matching validation checklist above

### Step 3: Execute Automated Checks
For code artifacts, run the relevant mix commands

### Step 4: Report Findings
Present validation results in this format:

```markdown
## Validation Report

**Artifact**: [What was validated]
**Type**: [Requirements | Architecture | Code | Tests | Migration]
**Status**: [PASS | FAIL | WARNINGS]

### Checks Passed
- ✓ [Check 1]
- ✓ [Check 2]

### Issues Found
- ✗ [Issue 1]: [Description and fix]
- ✗ [Issue 2]: [Description and fix]

### Warnings
- ⚠ [Warning 1]: [Recommendation]

### Commands Executed
```bash
[Commands run and their output]
```

### Recommended Actions
1. [Action 1]
2. [Action 2]
```

### Step 5: Fix Issues
If issues are found:
1. Describe the problem clearly
2. Propose a fix
3. Apply the fix after user confirmation
4. Re-validate

## Integration Points

### After `/start-discovery`
Validate requirements completeness and clarity

### After `/start-planning`
Validate architecture correctness and consistency

### After `/start-implementation`
Validate generated code compiles and follows patterns

### After `/run-review`
Validate code quality, tests, and security

### After `/prepare-release`
Validate deployment readiness

## Usage Examples

```
"Validate the user stories I just created"
"Check if this migration is correct"
"Validate the Accounts context code"
"Run full validation before I commit"
"Check if these tests are comprehensive"
```
