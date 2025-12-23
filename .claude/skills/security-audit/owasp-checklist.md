# OWASP Top 10 (2021) Security Checklist

## A01:2021 - Broken Access Control

### Description
Access control enforces policy such that users cannot act outside of their intended permissions.

### Checklist
- [ ] Deny access by default (except for public resources)
- [ ] Implement access control mechanisms once and reuse
- [ ] Model access controls enforce record ownership
- [ ] Unique application business limit requirements enforced
- [ ] Disable web server directory listing
- [ ] File metadata and backup files not in web roots
- [ ] Log access control failures and alert administrators
- [ ] Rate limit API and controller access
- [ ] Stateless session tokens invalidated on logout
- [ ] JWTs invalidated on server after logout

### Common Vulnerabilities
- IDOR (Insecure Direct Object References)
- Path traversal
- Missing function-level access control
- CORS misconfiguration
- Force browsing to authenticated pages

---

## A02:2021 - Cryptographic Failures

### Description
Failures related to cryptography which often lead to sensitive data exposure.

### Checklist
- [ ] Classify data by sensitivity level
- [ ] Don't store sensitive data unnecessarily
- [ ] Encrypt all sensitive data at rest
- [ ] Use strong, up-to-date algorithms and protocols
- [ ] Encrypt data in transit with TLS
- [ ] Disable caching for sensitive data
- [ ] Use proper key management
- [ ] Don't use deprecated hash functions (MD5, SHA1)
- [ ] Generate cryptographic keys using proper RNG
- [ ] Don't use ECB mode for encryption

### Data Classification
| Type | Examples | Protection Level |
|------|----------|------------------|
| Public | Marketing content | None |
| Internal | Employee directories | Access control |
| Confidential | Customer data, PII | Encryption + Access control |
| Restricted | Financial data, health records | Strong encryption + Audit |

---

## A03:2021 - Injection

### Description
Injection flaws occur when untrusted data is sent to an interpreter.

### Checklist
- [ ] Use parameterized queries / prepared statements
- [ ] Use positive server-side input validation
- [ ] Escape special characters for interpreters
- [ ] Use LIMIT to prevent mass disclosure in SQL
- [ ] Use ORM frameworks properly
- [ ] Validate all client-supplied input

### Prevention by Type

#### SQL Injection
```javascript
// Bad
query(`SELECT * FROM users WHERE id = '${userId}'`)

// Good
query('SELECT * FROM users WHERE id = ?', [userId])
```

#### Command Injection
```javascript
// Bad
exec(`convert ${filename}`)

// Good
execFile('convert', [sanitizedFilename])
```

#### XSS
```javascript
// Bad
element.innerHTML = userInput

// Good
element.textContent = userInput
// or use DOMPurify
element.innerHTML = DOMPurify.sanitize(userInput)
```

---

## A04:2021 - Insecure Design

### Description
Missing or ineffective control design. Different from implementation bugs.

### Checklist
- [ ] Establish secure development lifecycle
- [ ] Use threat modeling for critical authentication
- [ ] Write unit and integration tests for security
- [ ] Design for segregation at all tiers
- [ ] Limit resource consumption by user/service
- [ ] Implement business logic validation

### Threat Modeling Steps
1. Identify assets
2. Create architecture overview
3. Decompose application
4. Identify threats (STRIDE)
5. Document threats
6. Rate threats (DREAD)
7. Mitigation strategies

---

## A05:2021 - Security Misconfiguration

### Description
Missing appropriate security hardening across any part of the application stack.

### Checklist
- [ ] Repeatable hardening process
- [ ] Remove or don't install unused features
- [ ] Review cloud storage permissions
- [ ] Send security directives to clients (headers)
- [ ] Automated process to verify configurations
- [ ] Separate environments (dev, staging, prod)

### Required Security Headers
```
Content-Security-Policy: default-src 'self'; script-src 'self'
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: geolocation=(), camera=()
```

---

## A06:2021 - Vulnerable and Outdated Components

### Description
Using components with known vulnerabilities.

### Checklist
- [ ] Remove unused dependencies
- [ ] Inventory versions of components
- [ ] Monitor for vulnerabilities (CVE, NVD)
- [ ] Only obtain components from official sources
- [ ] Monitor for unmaintained libraries
- [ ] Have update/patch management plan

### Tools
- `npm audit` / `yarn audit`
- `pip-audit` / `safety`
- Snyk
- Dependabot
- OWASP Dependency-Check

---

## A07:2021 - Identification and Authentication Failures

### Description
Confirmation of user's identity, authentication, and session management.

### Checklist
- [ ] Implement multi-factor authentication
- [ ] Don't ship with default credentials
- [ ] Implement weak password checks
- [ ] Follow NIST 800-63b guidelines
- [ ] Harden account recovery flows
- [ ] Use secure session management
- [ ] Limit failed authentication attempts
- [ ] Log authentication failures

### Password Requirements (NIST 800-63b)
- Minimum 8 characters (12+ recommended)
- Check against breach databases
- Allow all ASCII characters + space
- No complexity requirements
- No password hints
- No security questions

---

## A08:2021 - Software and Data Integrity Failures

### Description
Assumptions about software updates, critical data, and CI/CD without verifying integrity.

### Checklist
- [ ] Use digital signatures to verify software
- [ ] Use trusted repositories for dependencies
- [ ] Use software supply chain security tool
- [ ] Review changes to CI/CD pipeline
- [ ] Ensure CI/CD has proper access control
- [ ] Unsigned or unencrypted serialized data not sent to untrusted clients

---

## A09:2021 - Security Logging and Monitoring Failures

### Description
Without logging and monitoring, breaches cannot be detected.

### Checklist
- [ ] Log all login, access control, input validation failures
- [ ] Logs have enough context for forensics
- [ ] Logs in format suitable for log management
- [ ] High-value transactions have audit trail
- [ ] Effective monitoring and alerting
- [ ] Incident response plan exists

### What to Log
- Authentication events (success/failure)
- Authorization failures
- Input validation failures
- Application errors
- System events
- High-value transactions

### What NOT to Log
- Passwords
- Session tokens
- Personal data (without purpose)
- Encryption keys
- Database connection strings

---

## A10:2021 - Server-Side Request Forgery (SSRF)

### Description
SSRF occurs when fetching a remote resource without validating the user-supplied URL.

### Checklist
- [ ] Sanitize and validate all client-supplied input
- [ ] Use allowlist for URL schemes, ports, destinations
- [ ] Don't send raw responses to clients
- [ ] Disable HTTP redirections
- [ ] URL consistency to avoid DNS rebinding

### Prevention
```javascript
// Validate URL before fetching
const allowedHosts = ['api.example.com', 'cdn.example.com'];
const url = new URL(userInput);

if (!allowedHosts.includes(url.hostname)) {
  throw new Error('Host not allowed');
}

// Use allowlist for internal services
if (url.hostname.match(/^(localhost|127\.|10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[01])\.)/)) {
  throw new Error('Internal hosts not allowed');
}
```
