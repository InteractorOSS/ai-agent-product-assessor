# Interactor Authentication Integration Guide

> **⚙️ Auto-Synced Documentation**
>
> This file is automatically synchronized from the Interactor account-server repository.
> - **Source:** [`pulzze/account-server/docs/integration-guide.md`](https://github.com/pulzze/account-server/blob/main/docs/integration-guide.md)
> - **Last Sync:** Pending initial sync (requires authentication configuration)
> - **Sync Frequency:** Daily at 6am UTC via GitHub Actions
> - **Manual Sync:** Run `./scripts/setup/sync-external-docs.sh interactor-auth`

---

## 🚨 Sync Pending

This documentation is configured for automatic synchronization but requires proper GitHub authentication to access the source repository.

### To Enable Sync:

1. **Verify Repository Access:**
   - Ensure the `GITHUB_TOKEN` has read access to `pulzze/account-server`
   - If the repository is private, configure personal access token with `repo` scope

2. **Manual Sync:**
   ```bash
   ./scripts/setup/sync-external-docs.sh interactor-auth
   ```

3. **Automatic Sync:**
   - Daily sync via `.github/workflows/sync-external-docs.yml`
   - Trigger manually via GitHub Actions workflow dispatch

---

## Overview

**IMPORTANT**: All new applications built with this template should use Interactor server for authentication instead of implementing custom auth.

### Why Use Interactor Authentication?

- **Security**: Professionally implemented with RS256 JWT signing
- **Consistency**: Single sign-on across all Interactor ecosystem apps
- **Reduced Risk**: No need to handle password hashing, session management, etc.
- **Maintenance**: Authentication security updates handled centrally

### Integration Requirements

- **Interactor URL:** `https://console.interactor.com`
- **OAuth Issuer:** `https://interactor.com`
- **Token Verification:** JWKS endpoint at `/oauth/jwks`

---

## Quick Start

### 1. Environment Configuration

```bash
# .env
INTERACTOR_URL=https://console.interactor.com
INTERACTOR_OAUTH_ISSUER=https://interactor.com
```

### 2. Token Verification Setup

```javascript
const jwksClient = require('jwks-rsa');

const client = jwksClient({
  jwksUri: `${process.env.INTERACTOR_URL}/oauth/jwks`
});

async function getSigningKey(kid) {
  const key = await client.getSigningKey(kid);
  return key.getPublicKey();
}
```

### 3. Verify JWT Tokens

```javascript
const jwt = require('jsonwebtoken');

async function verifyToken(token) {
  const decoded = jwt.decode(token, { complete: true });
  const signingKey = await getSigningKey(decoded.header.kid);

  return jwt.verify(token, signingKey, {
    algorithms: ['RS256'],
    issuer: process.env.INTERACTOR_OAUTH_ISSUER,
  });
}
```

---

## Token Structure

Interactor tokens use RS256 with the following claims:

- **iss:** `https://interactor.com`
- **sub:** Account UUID
- **exp:** 1 hour expiry
- **iat:** Issued at timestamp

---

## Integration Checklist

- [ ] Environment variables configured
- [ ] JWKS client setup
- [ ] Token verification middleware implemented
- [ ] Error handling for expired/invalid tokens
- [ ] Refresh token flow (if applicable)
- [ ] Logout handling

---

## Additional Resources

- **Full Integration Guide:** [Source Repository](https://github.com/pulzze/account-server/blob/main/docs/integration-guide.md)
- **Interactor Console:** [console.interactor.com](https://console.interactor.com)
- **Support:** Contact Interactor team for access credentials

---

## Sync Troubleshooting

If automatic sync fails:

1. **Check Workflow Logs:**
   - GitHub Actions → `Sync External Documentation` workflow
   - Look for authentication or network errors

2. **Manual Sync:**
   ```bash
   # Preview changes without applying
   ./scripts/setup/sync-external-docs.sh --dry-run interactor-auth

   # Apply sync
   ./scripts/setup/sync-external-docs.sh interactor-auth
   ```

3. **Verify Access:**
   - Test repository access: `curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/pulzze/account-server`
   - Ensure token has `repo` scope for private repositories

4. **Create Issue:**
   - If sync continues to fail, the workflow will automatically create a GitHub issue with details

---

_This document is maintained via automated sync. Do not edit directly - changes will be overwritten._
