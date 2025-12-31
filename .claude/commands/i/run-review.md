# Run Review

Execute comprehensive code review workflow.

## Instructions

When this command is invoked, perform the following:

### 1. Determine Review Scope

Ask or detect:
- Specific files to review
- Recent changes (git diff)
- Pull request scope
- Full codebase review

### 2. Execute Review Workflow

#### Step 1: Code Quality Review
Use the `code-review` skill to analyze:
- Code style adherence
- Naming conventions
- Function complexity
- DRY violations
- Error handling

#### Step 2: Security Review (OWASP Top 10)

Use the `security-audit` skill to check all OWASP Top 10 categories:

**A01: Broken Access Control**
- Authorization checks on all endpoints
- IDOR vulnerability testing (users can't access others' data)
- Role-based access control verification
- Deny-by-default enforcement

**A02: Cryptographic Failures**
- Sensitive data encrypted at rest
- TLS/HTTPS for data in transit
- Strong password hashing (bcrypt/argon2)
- No weak/deprecated algorithms (MD5, SHA1)
- Secure key management

**A03: Injection**
- SQL injection (Ecto parameterized queries)
- Command injection prevention
- XSS (output encoding)
- Template injection

**A04: Insecure Design**
- Threat modeling completed
- Secure design patterns used
- Business logic flaws

**A05: Security Misconfiguration**
- Security headers configured
- CORS properly restricted
- Debug/dev mode disabled in prod
- Default credentials changed
- Unnecessary features disabled

**A06: Vulnerable Components**
- `mix hex.audit` passes
- No known CVEs in dependencies
- Dependencies up to date

**A07: Authentication Failures**
- Strong password requirements
- Session timeout configured
- Brute force protection
- Multi-factor authentication (if applicable)
- Secure password reset flow

**A08: Data Integrity Failures**
- Signed data verification
- CI/CD pipeline security
- Deserialization safety

**A09: Logging & Monitoring Failures**
- Security events logged
- No sensitive data in logs
- Failed auth attempts logged
- Audit trail for sensitive operations
- Alerting configured

**A10: Server-Side Request Forgery (SSRF)**
- URL validation on user input
- Allowlist for external requests
- Internal network access restricted

#### Step 2b: Phoenix/Elixir Security

**Framework Security**
- CSRF tokens on all forms (`protect_from_forgery` plug)
- Secure session configuration (`:secure`, `:http_only`)
- Content Security Policy header
- X-Frame-Options: DENY or SAMEORIGIN
- X-Content-Type-Options: nosniff
- Strict-Transport-Security (HSTS)
- Referrer-Policy header

**Ecto Security**
- No raw SQL with user input
- Parameterized queries only
- Schema validation on all inputs

**LiveView Security** (if applicable)
- Event handlers validate user permissions
- No sensitive data in assigns
- Rate limiting on events

**API Security** (if applicable)
- API authentication (tokens, JWT)
- Rate limiting
- Input validation on all endpoints

#### Step 3: Test Coverage
Analyze test coverage:
- Check coverage percentage
- Identify untested code paths
- Review test quality

#### Step 4: Documentation Review
Check documentation:
- README accuracy
- API documentation
- Code comments
- CHANGELOG updates

### 3. Display Review Checklist

```markdown
## Code Review Checklist

### Code Quality
- [ ] Clear naming conventions
- [ ] Single responsibility principle
- [ ] No code duplication
- [ ] Proper error handling
- [ ] Consistent formatting

### Security (OWASP Top 10 + Phoenix)

#### A01: Broken Access Control
- [ ] Authorization on all endpoints
- [ ] No IDOR vulnerabilities
- [ ] Proper RBAC implementation
- [ ] Deny by default

#### A02: Cryptographic Failures
- [ ] Sensitive data encrypted at rest
- [ ] TLS for all connections
- [ ] Strong password hashing (bcrypt/argon2)
- [ ] No weak algorithms (MD5, SHA1)

#### A03: Injection
- [ ] Parameterized queries (Ecto)
- [ ] Output encoding (XSS)
- [ ] No command injection
- [ ] No template injection

#### A05: Security Misconfiguration
- [ ] Security headers set
- [ ] CORS properly restricted
- [ ] Debug mode disabled (prod)
- [ ] Default credentials changed

#### A06: Vulnerable Components
- [ ] `mix hex.audit` passes
- [ ] No known CVEs in dependencies

#### A07: Authentication Failures
- [ ] Strong password policy
- [ ] Session timeouts configured
- [ ] Brute force protection
- [ ] Secure password reset flow

#### A09: Logging & Monitoring
- [ ] Security events logged
- [ ] No secrets in logs
- [ ] Auth failures logged

#### Phoenix Specific
- [ ] CSRF protection enabled
- [ ] Secure session config
- [ ] Security headers set (CSP, HSTS, X-Frame-Options)
- [ ] Rate limiting on auth endpoints
- [ ] No hardcoded secrets

### Testing
- [ ] Tests exist for new code
- [ ] Edge cases covered
- [ ] Tests are meaningful
- [ ] Coverage threshold met

### Documentation
- [ ] Code comments where needed
- [ ] README updated
- [ ] API docs current
- [ ] CHANGELOG entry added

### Performance
- [ ] No obvious bottlenecks
- [ ] Efficient queries
- [ ] Appropriate caching
- [ ] No memory leaks
```

### 4. Generate Review Report

```markdown
## Code Review Report

**Date**: [Date]
**Reviewer**: Claude AI
**Scope**: [Files/PR description]

### Summary
- **Overall Assessment**: [APPROVE | REQUEST_CHANGES | COMMENT]
- **Critical Issues**: X
- **Suggestions**: X
- **Notes**: X

### Critical Issues (Must Fix)
1. [Issue with location and fix suggestion]

### Suggestions (Should Fix)
1. [Suggestion with reasoning]

### Minor Notes
1. [Optional improvements]

### Positive Highlights
- [Good practices observed]

### Test Coverage
- Current: X%
- Required: 80%
- Status: [Pass/Fail]

### Security Findings (OWASP Top 10)

| Category | Status | Severity | Details |
|----------|--------|----------|---------|
| A01: Access Control | ✓/✗ | - | |
| A02: Cryptography | ✓/✗ | - | |
| A03: Injection | ✓/✗ | - | |
| A05: Misconfiguration | ✓/✗ | - | |
| A06: Components | ✓/✗ | - | |
| A07: Authentication | ✓/✗ | - | |
| A09: Logging | ✓/✗ | - | |

**Critical** (Must fix before deploy):
- [List critical findings]

**High** (Fix within 24h):
- [List high findings]

**Medium** (Fix within sprint):
- [List medium findings]

**Low** (Track in backlog):
- [List low findings]

**Phoenix Security Headers**:
- CSP: [Set/Missing]
- HSTS: [Set/Missing]
- X-Frame-Options: [Set/Missing]
- X-Content-Type-Options: [Set/Missing]

### Next Steps
1. [Action items]
```

## Output

```markdown
## Review Workflow Started

**Review Type**: [Full/Diff/PR]
**Files in Scope**: [Count or list]

### Running Checks...

1. Code Quality Analysis
   - Analyzing code style...
   - Checking complexity...
   - Finding duplication...

2. Security Audit (OWASP Top 10)
   - A01: Checking access control...
   - A02: Validating cryptography...
   - A03: Testing for injection...
   - A05: Checking configuration...
   - A06: Auditing dependencies...
   - A07: Reviewing authentication...
   - A09: Checking logging...
   - Phoenix: Validating headers & CSRF...

3. Test Analysis
   - Calculating coverage...
   - Reviewing test quality...

4. Documentation Check
   - Verifying README...
   - Checking API docs...

### Review Complete

[Full review report]

### Quick Actions
- "Fix the critical issues"
- "Improve test coverage for [file]"
- "Add documentation for [function]"
- "Explain [finding] in more detail"
```

## Validation Requirements

### Automated Validation Suite

Run ALL validation commands during review:

```bash
# Compilation
mix compile --warnings-as-errors

# Formatting
mix format --check-formatted

# Static Analysis
mix credo --strict

# Security Scan (fail on high severity)
mix sobelow --config --exit high

# Type Checking (if dialyzer configured)
mix dialyzer

# Tests with Coverage
mix test --cover

# Dependency Audit
mix hex.audit
```

### Manual Security Checks

Run these additional checks for comprehensive security review:

```bash
# Find potential hardcoded secrets
grep -rn "secret\|password\|api_key\|token" --include="*.ex" lib/ | grep -v "secret_key_base"

# Check for raw SQL usage
grep -rn "raw_sql\|fragment\|Repo.query" --include="*.ex" lib/

# Find command execution
grep -rn "System.cmd\|:os.cmd\|Port.open" --include="*.ex" lib/

# Check for unsafe deserialization
grep -rn ":erlang.binary_to_term\|:erlang.term_to_binary" --include="*.ex" lib/

# Find external HTTP calls (SSRF risk)
grep -rn "HTTPoison\|Finch\|Tesla\|:httpc" --include="*.ex" lib/
```

### Review Validation Checklist

| Check | Command | Required |
|-------|---------|----------|
| Compiles | `mix compile --warnings-as-errors` | MUST PASS |
| Formatted | `mix format --check-formatted` | MUST PASS |
| Tests Pass | `mix test` | MUST PASS |
| Coverage ≥ 80% | `mix test --cover` | MUST PASS |
| No Credo Issues | `mix credo --strict` | SHOULD PASS |
| No High Security Issues | `mix sobelow --exit high` | MUST PASS |
| Dependencies Safe | `mix hex.audit` | MUST PASS |
| Type Specs Valid | `mix dialyzer` | OPTIONAL |

### Security Severity Guide

| Severity | Response Time | Examples |
|----------|---------------|----------|
| **Critical** | Immediate (block deploy) | SQL injection, auth bypass, exposed secrets |
| **High** | Fix within 24 hours | XSS, CSRF missing, weak crypto |
| **Medium** | Fix within sprint | Missing rate limiting, verbose errors |
| **Low** | Track in backlog | Minor header issues, informational |

### Validation Report Format

Generate a validation report showing:

```markdown
## Validation Results

### Required Checks
✓ PASS: Compilation (0 warnings)
✓ PASS: Formatting
✓ PASS: Tests (42 tests, 0 failures)
✓ PASS: Coverage (87.3%)
✓ PASS: Sobelow (0 high-severity findings)
✓ PASS: Hex Audit (0 vulnerable dependencies)

### Quality Checks
✓ PASS: Credo (0 issues)
⚠ WARN: Sobelow (2 low-severity findings)

### Security Status (OWASP Top 10)
✓ A01: Access Control - No issues
✓ A02: Cryptography - Strong hashing in use
✓ A03: Injection - Parameterized queries verified
✓ A05: Configuration - Headers configured
✓ A06: Components - Dependencies up to date
✓ A07: Authentication - Secure implementation
⚠ A09: Logging - Minor improvements suggested

### Phoenix Security Headers
✓ CSP: Set
✓ HSTS: Set
✓ X-Frame-Options: DENY
✓ X-Content-Type-Options: nosniff

### Summary
**Status**: READY FOR DEPLOYMENT
**Blockers**: 0
**Warnings**: 2
**Security Score**: 9/10
```

### Exit Gate Validation
Before proceeding to `/prepare-release`:

**Required (Must Pass)**
- [ ] All compilation checks pass
- [ ] All tests pass with ≥80% coverage
- [ ] `mix sobelow --exit high` passes (no high/critical findings)
- [ ] `mix hex.audit` passes (no vulnerable dependencies)
- [ ] No critical code review findings

**Security (Must Address)**
- [ ] All OWASP Top 10 categories reviewed
- [ ] Critical/High security findings fixed
- [ ] Medium findings documented with remediation plan
- [ ] Phoenix security headers configured
- [ ] CSRF protection verified
- [ ] No hardcoded secrets in codebase

**Quality (Should Pass)**
- [ ] `mix credo --strict` passes
- [ ] Documentation is up to date
- [ ] Low-severity findings tracked in backlog

Run the `validator` skill:
```
"Run full validation before deployment"
```
