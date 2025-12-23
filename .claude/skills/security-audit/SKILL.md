---
name: security-audit
description: Perform OWASP-based security audit identifying vulnerabilities, misconfigurations, and security best practice violations. Use before releases or when security concerns arise.
---

# Security Audit Skill

Comprehensive security analysis based on OWASP guidelines and industry best practices.

## When to Use

- Before production releases
- After adding authentication/authorization features
- When handling sensitive data
- Periodic security assessments
- After dependency updates

## Instructions

### Step 1: Dependency Audit

Check for vulnerable dependencies:

```bash
# Node.js
npm audit
npx better-npm-audit audit

# Python
pip-audit
safety check

# General
snyk test
```

Review:
- [ ] No critical vulnerabilities
- [ ] No high vulnerabilities without mitigation plan
- [ ] Dependencies are up to date
- [ ] No unmaintained packages

### Step 2: OWASP Top 10 Analysis

Reference: [owasp-checklist.md](owasp-checklist.md)

#### A01:2021 - Broken Access Control
- [ ] Access controls enforced server-side
- [ ] Deny by default policy
- [ ] CORS properly configured
- [ ] Directory listing disabled
- [ ] JWT tokens validated properly

#### A02:2021 - Cryptographic Failures
- [ ] Data classified by sensitivity
- [ ] Sensitive data encrypted at rest
- [ ] Strong encryption algorithms used
- [ ] Proper key management
- [ ] TLS 1.2+ enforced

#### A03:2021 - Injection
- [ ] Parameterized queries used
- [ ] Input validation implemented
- [ ] Output encoding applied
- [ ] ORM used correctly
- [ ] No dynamic code execution

#### A04:2021 - Insecure Design
- [ ] Threat modeling completed
- [ ] Security requirements defined
- [ ] Secure design patterns used
- [ ] Business logic validated
- [ ] Rate limiting implemented

#### A05:2021 - Security Misconfiguration
- [ ] Hardening applied
- [ ] Default credentials changed
- [ ] Error messages don't leak info
- [ ] Security headers configured
- [ ] Unnecessary features disabled

#### A06:2021 - Vulnerable Components
- [ ] Component inventory maintained
- [ ] Components from official sources
- [ ] Automated vulnerability scanning
- [ ] Update process defined
- [ ] No unsupported components

#### A07:2021 - Authentication Failures
- [ ] Strong password policy
- [ ] Multi-factor authentication available
- [ ] Session management secure
- [ ] Brute force protection
- [ ] Secure password storage

#### A08:2021 - Integrity Failures
- [ ] CI/CD pipeline secured
- [ ] Dependency integrity verified
- [ ] Code signing implemented
- [ ] Update mechanism secure
- [ ] No unsigned/unverified resources

#### A09:2021 - Logging Failures
- [ ] Security events logged
- [ ] Logs protected from tampering
- [ ] Log data validated
- [ ] Monitoring/alerting active
- [ ] Audit trail maintained

#### A10:2021 - SSRF
- [ ] URL validation implemented
- [ ] Allowlist for remote resources
- [ ] Network segmentation
- [ ] Firewall rules configured
- [ ] DNS resolution controlled

### Step 3: Configuration Review

#### Security Headers
```
Content-Security-Policy: default-src 'self'
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Strict-Transport-Security: max-age=31536000; includeSubDomains
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: geolocation=(), camera=(), microphone=()
```

#### Environment
- [ ] Production debug disabled
- [ ] Secrets in environment variables
- [ ] No secrets in code
- [ ] Proper file permissions
- [ ] Firewall configured

### Step 4: Code Pattern Analysis

Search for dangerous patterns:

```bash
# Hardcoded secrets
grep -r "password\s*=" --include="*.js" --include="*.ts"
grep -r "api[_-]?key" --include="*.js" --include="*.ts"

# SQL injection risks
grep -r "query\s*(" --include="*.js" --include="*.ts"

# Unsafe deserialization
grep -r "JSON.parse\|eval\|Function(" --include="*.js"

# Command injection
grep -r "exec\|spawn\|execSync" --include="*.js" --include="*.ts"
```

## Output Format

```markdown
## Security Audit Report

**Date**: [YYYY-MM-DD]
**Scope**: [Description of what was audited]
**Auditor**: Claude AI

---

### Executive Summary

- **Critical**: X findings
- **High**: X findings
- **Medium**: X findings
- **Low**: X findings

---

### Critical Findings

#### [Finding Title]
- **Category**: [OWASP Category]
- **Location**: [File:Line or Component]
- **Description**: [What was found]
- **Impact**: [Potential impact]
- **Remediation**: [How to fix]
- **Priority**: Immediate

---

### High Priority Findings

[Same format as critical]

---

### Medium Priority Findings

[Same format]

---

### Low Priority Findings

[Same format]

---

### Recommendations

1. [Prioritized recommendation]
2. [Next recommendation]

---

### Appendix

- Tools used
- Files reviewed
- Testing methodology
```

## Common Patterns to Flag

### Dangerous Code

```javascript
// SQL Injection - DANGEROUS
db.query(`SELECT * FROM users WHERE id = '${userId}'`);

// Command Injection - DANGEROUS
exec(`ls ${userInput}`);

// XSS - DANGEROUS
element.innerHTML = userInput;

// Hardcoded Secret - DANGEROUS
const apiKey = "sk-1234567890abcdef";
```

### Secure Alternatives

```javascript
// SQL - SAFE
db.query('SELECT * FROM users WHERE id = ?', [userId]);

// Command - SAFE
execFile('ls', [sanitizedInput]);

// XSS - SAFE
element.textContent = userInput;

// Secret - SAFE
const apiKey = process.env.API_KEY;
```
