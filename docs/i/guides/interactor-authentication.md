# Interactor Authentication Integration Guide

This guide explains how to integrate Interactor server authentication into your application.

## Overview

Interactor server provides centralized authentication for all Interactor ecosystem applications using JWT tokens signed with RS256. This enables:

- Single sign-on across applications
- Secure token verification via JWKS
- Centralized user management
- No need to implement password hashing or session management

## Authentication Methods

### Method 1: Same Domain/Subdomain (SharedAuth)

For applications hosted on `*.interactor.com` subdomains, authentication is automatic via shared cookies.

**How it works:**
1. User logs into `console.interactor.com`
2. Session cookie is shared across subdomains
3. Your app reads the cookie and validates the session

**No additional implementation required** - just deploy to an Interactor subdomain.

### Method 2: JWT Token Exchange (Different Domain)

For applications on different domains, use JWT token exchange.

**Flow:**
1. Redirect user to Interactor login
2. User authenticates on Interactor
3. Interactor redirects back with JWT token
4. Your app verifies the JWT using JWKS

### Method 3: API-to-API (Bearer Token)

For backend services calling Interactor APIs.

**Flow:**
1. Obtain JWT token via login API
2. Include token in `Authorization: Bearer <token>` header
3. Target API verifies token via JWKS

---

## Environment Configuration

Add these variables to your `.env` file:

```bash
# Interactor Authentication
INTERACTOR_URL=https://console.interactor.com
INTERACTOR_OAUTH_ISSUER=https://interactor.com

# Optional: API Key for server-to-server calls
# INTERACTOR_API_KEY=your_api_key

# Optional: Custom JWKS URL (auto-derived from INTERACTOR_URL if not set)
# INTERACTOR_JWKS_URL=https://console.interactor.com/oauth/jwks
```

---

## API Endpoints

### Login
```
POST /api/v1/auth/login
Content-Type: application/json

{
  "account": {
    "email": "user@example.com",
    "password": "password"
  }
}

Response:
{
  "success": true,
  "token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "account": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "User Name"
  }
}
```

### Validate Token
```
POST /api/v1/auth/validate_token
Content-Type: application/json

{
  "token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
}

Response:
{
  "valid": true,
  "account": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "User Name",
    "display_name": "Display Name",
    "full_name": "Full Name"
  }
}
```

### JWKS (Public Keys)
```
GET /oauth/jwks

Response:
{
  "keys": [
    {
      "kty": "RSA",
      "use": "sig",
      "alg": "RS256",
      "kid": "key-id",
      "n": "modulus...",
      "e": "AQAB"
    }
  ]
}
```

### OAuth Metadata
```
GET /oauth/.well-known/oauth-authorization-server

Response:
{
  "issuer": "https://interactor.com",
  "jwks_uri": "https://interactor.com/oauth/jwks",
  "token_endpoint": "https://interactor.com/api/v1/auth/login",
  ...
}
```

---

## Implementation Examples

### Elixir/Phoenix Implementation

#### 1. Add Dependencies

```elixir
# mix.exs
defp deps do
  [
    {:joken, "~> 2.6"},
    {:jason, "~> 1.4"},
    {:req, "~> 0.4"}  # or HTTPoison
  ]
end
```

#### 2. JWKS Client Module

```elixir
defmodule MyApp.Auth.JWKSClient do
  @moduledoc "Fetches and caches JWKS from Interactor server"

  use GenServer

  @refresh_interval :timer.hours(1)

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get_signing_key(kid) do
    GenServer.call(__MODULE__, {:get_key, kid})
  end

  @impl true
  def init(_) do
    schedule_refresh()
    {:ok, %{keys: fetch_jwks()}}
  end

  @impl true
  def handle_call({:get_key, kid}, _from, state) do
    key = Enum.find(state.keys, fn k -> k["kid"] == kid end)
    {:reply, key, state}
  end

  @impl true
  def handle_info(:refresh, _state) do
    schedule_refresh()
    {:noreply, %{keys: fetch_jwks()}}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  defp fetch_jwks do
    jwks_url = "#{System.get_env("INTERACTOR_URL")}/oauth/jwks"

    case Req.get(jwks_url) do
      {:ok, %{status: 200, body: %{"keys" => keys}}} -> keys
      _ -> []
    end
  end
end
```

#### 3. Token Verification Module

```elixir
defmodule MyApp.Auth.Token do
  @moduledoc "Verifies JWT tokens from Interactor"

  alias MyApp.Auth.JWKSClient

  @issuer System.get_env("INTERACTOR_OAUTH_ISSUER", "https://interactor.com")

  def verify(token) do
    with {:ok, header} <- peek_header(token),
         {:ok, jwk} <- get_signing_key(header["kid"]),
         {:ok, claims} <- verify_signature(token, jwk),
         :ok <- verify_claims(claims) do
      {:ok, claims}
    end
  end

  defp peek_header(token) do
    case Joken.peek_header(token) do
      {:ok, header} -> {:ok, header}
      _ -> {:error, :invalid_token}
    end
  end

  defp get_signing_key(kid) do
    case JWKSClient.get_signing_key(kid) do
      nil -> {:error, :unknown_key}
      key -> {:ok, key}
    end
  end

  defp verify_signature(token, jwk) do
    signer = Joken.Signer.create("RS256", jwk)

    case Joken.verify(token, signer) do
      {:ok, claims} -> {:ok, claims}
      _ -> {:error, :invalid_signature}
    end
  end

  defp verify_claims(claims) do
    cond do
      claims["iss"] != @issuer -> {:error, :invalid_issuer}
      claims["exp"] < DateTime.utc_now() |> DateTime.to_unix() -> {:error, :token_expired}
      true -> :ok
    end
  end
end
```

#### 4. Authentication Plug

```elixir
defmodule MyAppWeb.Plugs.InteractorAuth do
  @moduledoc "Authenticates requests using Interactor JWT tokens"

  import Plug.Conn
  alias MyApp.Auth.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Token.verify(token) do
      conn
      |> assign(:current_user, %{
        id: claims["sub"],
        email: claims["email"],
        name: claims["name"]
      })
      |> assign(:authenticated, true)
    else
      _ ->
        conn
        |> assign(:current_user, nil)
        |> assign(:authenticated, false)
    end
  end
end
```

### Node.js/Express Implementation

#### 1. Install Dependencies

```bash
npm install jsonwebtoken jwks-rsa
```

#### 2. JWKS Client

```javascript
// auth/jwks-client.js
const jwksClient = require('jwks-rsa');

const client = jwksClient({
  jwksUri: `${process.env.INTERACTOR_URL}/oauth/jwks`,
  cache: true,
  cacheMaxEntries: 5,
  cacheMaxAge: 3600000, // 1 hour
});

function getSigningKey(kid) {
  return new Promise((resolve, reject) => {
    client.getSigningKey(kid, (err, key) => {
      if (err) return reject(err);
      resolve(key.getPublicKey());
    });
  });
}

module.exports = { getSigningKey };
```

#### 3. Token Verification

```javascript
// auth/verify-token.js
const jwt = require('jsonwebtoken');
const { getSigningKey } = require('./jwks-client');

const ISSUER = process.env.INTERACTOR_OAUTH_ISSUER || 'https://interactor.com';

async function verifyInteractorToken(token) {
  // Decode header to get kid
  const decoded = jwt.decode(token, { complete: true });
  if (!decoded || !decoded.header.kid) {
    throw new Error('Invalid token');
  }

  // Get public key from JWKS
  const publicKey = await getSigningKey(decoded.header.kid);

  // Verify token
  return jwt.verify(token, publicKey, {
    algorithms: ['RS256'],
    issuer: ISSUER,
  });
}

module.exports = { verifyInteractorToken };
```

#### 4. Express Middleware

```javascript
// middleware/interactor-auth.js
const { verifyInteractorToken } = require('../auth/verify-token');

async function interactorAuth(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    req.user = null;
    return next();
  }

  const token = authHeader.substring(7);

  try {
    const claims = await verifyInteractorToken(token);
    req.user = {
      id: claims.sub,
      email: claims.email,
      name: claims.name,
    };
  } catch (error) {
    req.user = null;
  }

  next();
}

function requireAuth(req, res, next) {
  if (!req.user) {
    return res.status(401).json({ error: 'Authentication required' });
  }
  next();
}

module.exports = { interactorAuth, requireAuth };
```

#### 5. Usage in Routes

```javascript
// routes/api.js
const express = require('express');
const { interactorAuth, requireAuth } = require('../middleware/interactor-auth');

const router = express.Router();

// Apply auth middleware to all routes
router.use(interactorAuth);

// Public route
router.get('/public', (req, res) => {
  res.json({ message: 'Public endpoint' });
});

// Protected route
router.get('/protected', requireAuth, (req, res) => {
  res.json({
    message: 'Protected endpoint',
    user: req.user
  });
});

module.exports = router;
```

---

## JWT Token Structure

Interactor JWT tokens contain these claims:

```json
{
  "iss": "https://interactor.com",
  "sub": "account-uuid",
  "aud": "api",
  "exp": 1704067200,
  "iat": 1704063600,
  "nbf": 1704063600,
  "jti": "unique-token-id",
  "email": "user@example.com",
  "name": "User Name",
  "scope": "api"
}
```

| Claim | Description |
|-------|-------------|
| `iss` | Issuer - always `https://interactor.com` |
| `sub` | Subject - the account UUID |
| `aud` | Audience - typically `api` |
| `exp` | Expiration timestamp |
| `iat` | Issued at timestamp |
| `nbf` | Not before timestamp |
| `jti` | Unique token identifier |
| `email` | User's email address |
| `name` | User's name |
| `scope` | Token scope |

---

## Security Considerations

1. **Always verify the token signature** using the JWKS endpoint
2. **Check the `iss` claim** matches `https://interactor.com`
3. **Check the `exp` claim** - reject expired tokens
4. **Cache JWKS keys** but refresh periodically (hourly recommended)
5. **Use HTTPS** for all communication
6. **Never log full tokens** - they contain sensitive information

---

## Troubleshooting

### Token validation fails

1. Check that `INTERACTOR_URL` is correct
2. Verify the token hasn't expired
3. Ensure JWKS endpoint is accessible from your server
4. Check the token was issued by Interactor (not another service)

### JWKS fetch fails

1. Check network connectivity to Interactor server
2. Verify firewall rules allow outbound HTTPS
3. Check for DNS resolution issues

### User not found after token validation

1. The `sub` claim contains the account UUID
2. Use `/api/v1/auth/validate_token` to get full user details if needed

---

## Migration from Custom Auth

If migrating from custom authentication:

1. Keep existing auth working during transition
2. Add Interactor auth as an alternative
3. Migrate users to Interactor accounts
4. Remove custom auth once migration complete

---

## Support

For issues with Interactor authentication:
- Check the Interactor server logs
- Verify environment configuration
- Test token validation with the `/api/v1/auth/validate_token` endpoint
