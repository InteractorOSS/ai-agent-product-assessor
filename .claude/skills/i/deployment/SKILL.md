---
name: deployment
description: Guide deployment preparation, verification, and release management for Elixir/Phoenix applications. Use before releases for validation, during deployment for verification, and after for monitoring setup.
author: David Jung
---

# Deployment Skill

Comprehensive deployment preparation, execution, and verification for Elixir/Phoenix applications.

## When to Use

- Preparing for a release
- During deployment process
- Setting up CI/CD pipelines
- Configuring monitoring
- Creating rollback procedures

## Instructions

### Step 1: Pre-Deployment Validation

Run ALL validation commands before deployment:

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

### Step 2: Pre-Deployment Checklist

#### Code Quality
- [ ] All tests passing (`mix test`)
- [ ] Code coverage ≥ 80% (`mix test --cover`)
- [ ] No compiler warnings (`mix compile --warnings-as-errors`)
- [ ] No credo issues (`mix credo --strict`)
- [ ] Code review completed
- [ ] Security audit passed (`mix sobelow`)

#### Documentation
- [ ] README updated
- [ ] API documentation current
- [ ] CHANGELOG updated
- [ ] Migration guide (if breaking changes)
- [ ] Release notes drafted

#### Configuration
- [ ] Environment variables documented in `.env.example`
- [ ] Production config verified (`config/runtime.exs`)
- [ ] Secrets configured in deployment environment
- [ ] Feature flags configured (if applicable)

#### Infrastructure
- [ ] Database migrations tested (`mix ecto.migrate`)
- [ ] Rollback tested (`mix ecto.rollback`)
- [ ] Backup verified
- [ ] Rollback plan documented
- [ ] Monitoring alerts configured
- [ ] Load testing completed (if applicable)

### Step 3: Deployment Strategy

#### Blue-Green Deployment
```
┌─────────────────────────────────────────┐
│             Load Balancer               │
└─────────────────────────────────────────┘
          │                    │
          ▼                    ▼
┌─────────────────┐   ┌─────────────────┐
│   Blue (Live)   │   │  Green (New)    │
│    v1.0.0       │   │    v1.1.0       │
└─────────────────┘   └─────────────────┘
```

**Process**:
1. Deploy new version to Green
2. Run smoke tests on Green
3. Switch traffic to Green
4. Keep Blue for quick rollback
5. After validation, Blue becomes staging

#### Canary Deployment
```
┌─────────────────────────────────────────┐
│             Load Balancer               │
│         (Traffic Split: 90/10)          │
└─────────────────────────────────────────┘
          │                    │
          ▼                    ▼
┌─────────────────┐   ┌─────────────────┐
│  Stable (90%)   │   │  Canary (10%)   │
│    v1.0.0       │   │    v1.1.0       │
└─────────────────┘   └─────────────────┘
```

**Process**:
1. Deploy to canary instances (10%)
2. Monitor error rates and performance
3. Gradually increase traffic
4. Full rollout if metrics are good
5. Rollback if issues detected

#### Rolling Deployment
```
Instance 1: v1.1.0 ✓
Instance 2: v1.1.0 ✓
Instance 3: v1.0.0 → v1.1.0 (updating)
Instance 4: v1.0.0 (waiting)
```

**Process**:
1. Update one instance at a time
2. Wait for health check
3. Proceed to next instance
4. Continue until all updated

### Step 4: CI/CD Pipeline

#### Pipeline Stages
```yaml
stages:
  - compile       # Compilation with warnings-as-errors
  - format        # Code formatting check
  - lint          # Credo static analysis
  - security      # Sobelow security scan
  - test          # ExUnit tests with coverage
  - dialyzer      # Type checking (optional)
  - build         # Build release
  - deploy-staging
  - verify-staging
  - deploy-prod
  - verify-prod
```

#### Example GitHub Actions for Elixir/Phoenix
```yaml
name: CI/CD

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  MIX_ENV: test
  ELIXIR_VERSION: '1.15'
  OTP_VERSION: '26'

jobs:
  validate:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v4

      - name: Setup Elixir
        uses: erlef/setup-beam@v1
        with:
          elixir-version: ${{ env.ELIXIR_VERSION }}
          otp-version: ${{ env.OTP_VERSION }}

      - name: Cache deps
        uses: actions/cache@v3
        with:
          path: deps
          key: ${{ runner.os }}-mix-${{ hashFiles('**/mix.lock') }}

      - name: Cache build
        uses: actions/cache@v3
        with:
          path: _build
          key: ${{ runner.os }}-build-${{ hashFiles('**/mix.lock') }}

      - name: Install dependencies
        run: mix deps.get

      - name: Compile with warnings as errors
        run: mix compile --warnings-as-errors

      - name: Check formatting
        run: mix format --check-formatted

      - name: Run Credo
        run: mix credo --strict

      - name: Run Sobelow
        run: mix sobelow --config

      - name: Run tests with coverage
        run: mix test --cover
        env:
          DATABASE_URL: postgres://postgres:postgres@localhost/test

      - name: Check hex audit
        run: mix hex.audit

  build-release:
    needs: validate
    runs-on: ubuntu-latest
    env:
      MIX_ENV: prod

    steps:
      - uses: actions/checkout@v4

      - name: Setup Elixir
        uses: erlef/setup-beam@v1
        with:
          elixir-version: ${{ env.ELIXIR_VERSION }}
          otp-version: ${{ env.OTP_VERSION }}

      - name: Install dependencies
        run: mix deps.get --only prod

      - name: Build release
        run: mix release

      - name: Upload release artifact
        uses: actions/upload-artifact@v3
        with:
          name: release
          path: _build/prod/rel/

  deploy-staging:
    needs: build-release
    runs-on: ubuntu-latest
    environment: staging

    steps:
      - name: Download release
        uses: actions/download-artifact@v3
        with:
          name: release

      - name: Deploy to Staging
        run: ./scripts/deploy.sh staging

      - name: Run migrations
        run: ./scripts/migrate.sh staging

      - name: Verify staging health
        run: curl -f https://staging.example.com/health

  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: production

    steps:
      - name: Download release
        uses: actions/download-artifact@v3
        with:
          name: release

      - name: Deploy to Production
        run: ./scripts/deploy.sh production

      - name: Run migrations
        run: ./scripts/migrate.sh production

      - name: Verify production health
        run: curl -f https://production.example.com/health
```

### Step 5: Monitoring Setup

#### Key Metrics
| Metric | Threshold | Action |
|--------|-----------|--------|
| Error Rate | > 1% | Alert |
| Response Time (p99) | > 500ms | Investigate |
| VM Memory | > 85% | Alert |
| Process Count | > 100k | Investigate |
| Request Rate | Anomaly | Investigate |
| Ecto Pool Usage | > 80% | Scale |

#### Health Checks (Phoenix)
```elixir
# lib/my_app_web/controllers/health_controller.ex
defmodule MyAppWeb.HealthController do
  use MyAppWeb, :controller

  def index(conn, _params) do
    json(conn, %{status: "ok", timestamp: DateTime.utc_now()})
  end

  def ready(conn, _params) do
    checks = %{
      database: check_database(),
      redis: check_redis(),
      external_api: check_external_api()
    }

    healthy = Enum.all?(checks, fn {_k, v} -> v.status == :ok end)

    conn
    |> put_status(if healthy, do: 200, else: 503)
    |> json(%{
      status: if(healthy, do: "ok", else: "degraded"),
      checks: checks,
      timestamp: DateTime.utc_now()
    })
  end

  defp check_database do
    case Ecto.Adapters.SQL.query(MyApp.Repo, "SELECT 1", []) do
      {:ok, _} -> %{status: :ok}
      {:error, reason} -> %{status: :error, reason: inspect(reason)}
    end
  end

  defp check_redis do
    # Add Redis check if using Redis
    %{status: :ok}
  end

  defp check_external_api do
    # Add external API check if needed
    %{status: :ok}
  end
end

# Add to router.ex
scope "/api", MyAppWeb do
  get "/health", HealthController, :index
  get "/health/ready", HealthController, :ready
end
```

#### Logging Best Practices (Elixir)
```elixir
# Structured logging with Logger
require Logger

# Request logging
Logger.info("Request processed",
  request_id: conn.assigns.request_id,
  user_id: user.id,
  action: "order_created",
  order_id: order.id,
  duration_ms: System.monotonic_time(:millisecond) - start_time
)

# Error logging with context
Logger.error("Payment failed",
  request_id: conn.assigns.request_id,
  user_id: user.id,
  error: Exception.message(error),
  stacktrace: Exception.format_stacktrace(__STACKTRACE__),
  payment_provider: "stripe"
)

# Configure JSON logging in config/prod.exs
config :logger, :console,
  format: {MyApp.LogFormatter, :format},
  metadata: [:request_id, :user_id]
```

#### Telemetry Setup
```elixir
# lib/my_app/telemetry.ex
defmodule MyApp.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Phoenix metrics
      summary("phoenix.endpoint.stop.duration", unit: {:native, :millisecond}),
      summary("phoenix.router_dispatch.stop.duration", unit: {:native, :millisecond}),

      # Ecto metrics
      summary("my_app.repo.query.total_time", unit: {:native, :millisecond}),
      summary("my_app.repo.query.queue_time", unit: {:native, :millisecond}),

      # VM metrics
      last_value("vm.memory.total", unit: :byte),
      last_value("vm.total_run_queue_lengths.total"),
      last_value("vm.total_run_queue_lengths.cpu"),
      last_value("vm.total_run_queue_lengths.io")
    ]
  end

  defp periodic_measurements do
    [
      {MyApp.Telemetry, :measure_users, []}
    ]
  end

  def measure_users do
    :telemetry.execute([:my_app, :users], %{total: MyApp.Accounts.count_users()}, %{})
  end
end
```

### Step 6: Rollback Procedures

#### Immediate Rollback Triggers
- Error rate > 5%
- P1 bug in production
- Security vulnerability discovered
- Data corruption detected
- Performance degradation > 50%

#### Rollback Steps
1. **Identify**: Confirm issue requires rollback
2. **Communicate**: Notify stakeholders
3. **Execute**: Run rollback procedure
4. **Verify**: Confirm rollback successful
5. **Document**: Record incident details

#### Database Rollback (Ecto)
```bash
# Rollback last migration
mix ecto.rollback

# Rollback specific number of migrations
mix ecto.rollback --step 3

# Rollback to specific version
mix ecto.rollback --to 20231201000000
```

```elixir
# Safe migration pattern with explicit up/down
defmodule MyApp.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, null: false
      timestamps()
    end

    create unique_index(:users, [:email])
  end

  def down do
    drop table(:users)
  end
end
```

#### Application Rollback
```bash
# If using releases, keep previous release available
# Deploy previous release
./bin/my_app stop
# Switch symlink to previous release
ln -sfn /opt/my_app/releases/1.0.0 /opt/my_app/current
./bin/my_app start

# Verify rollback
curl -f https://production.example.com/health
```

### Step 7: Post-Deployment Verification

#### Smoke Tests
```bash
#!/bin/bash
# Post-deployment smoke tests for Phoenix app

BASE_URL="${DEPLOY_URL:-https://api.example.com}"

echo "Running post-deployment smoke tests..."

# Test health endpoint
echo "Checking health endpoint..."
curl -f "$BASE_URL/api/health" || exit 1

# Test ready endpoint (database connectivity)
echo "Checking ready endpoint..."
curl -f "$BASE_URL/api/health/ready" || exit 1

# Test authentication (if applicable)
echo "Testing authentication..."
TOKEN=$(curl -s -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test"}' \
  | jq -r '.data.token')

[ -n "$TOKEN" ] && [ "$TOKEN" != "null" ] || exit 1

# Test protected endpoint
echo "Testing protected endpoint..."
curl -f "$BASE_URL/api/users/me" \
  -H "Authorization: Bearer $TOKEN" || exit 1

echo "✓ All smoke tests passed!"
```

#### ExUnit Smoke Tests
```elixir
# test/smoke_test.exs
defmodule MyApp.SmokeTest do
  use ExUnit.Case, async: false

  @moduletag :smoke

  @base_url System.get_env("SMOKE_TEST_URL", "http://localhost:4000")

  test "health endpoint responds" do
    {:ok, response} = HTTPoison.get("#{@base_url}/api/health")
    assert response.status_code == 200
    assert Jason.decode!(response.body)["status"] == "ok"
  end

  test "ready endpoint shows all services healthy" do
    {:ok, response} = HTTPoison.get("#{@base_url}/api/health/ready")
    assert response.status_code == 200

    body = Jason.decode!(response.body)
    assert body["status"] == "ok"
    assert body["checks"]["database"]["status"] == "ok"
  end
end
```

Run with: `mix test --only smoke`

## Output Format

```markdown
## Deployment Validation Report

**Version**: v1.2.0
**Date**: YYYY-MM-DD HH:MM UTC
**Environment**: Production
**Deployer**: [Name/Claude]
**Status**: SUCCESS / FAILED

---

### Pre-Deployment Validation
| Check | Command | Status |
|-------|---------|--------|
| Compilation | `mix compile --warnings-as-errors` | ✓ PASS |
| Formatting | `mix format --check-formatted` | ✓ PASS |
| Tests | `mix test` | ✓ PASS (142 tests) |
| Coverage | `mix test --cover` | ✓ PASS (87.3%) |
| Credo | `mix credo --strict` | ✓ PASS |
| Sobelow | `mix sobelow` | ✓ PASS |
| Hex Audit | `mix hex.audit` | ✓ PASS |
| Dialyzer | `mix dialyzer` | ✓ PASS |
| Release Build | `MIX_ENV=prod mix release` | ✓ PASS |

### Database Validation
| Check | Status |
|-------|--------|
| Migrations run | ✓ PASS |
| Rollback tested | ✓ PASS |
| Seeds verified | ✓ PASS |

### Staging Validation
| Check | Status |
|-------|--------|
| Health endpoint | ✓ PASS |
| Ready endpoint | ✓ PASS |
| Smoke tests | ✓ PASS |

### Production Deployment
| Step | Time | Status |
|------|------|--------|
| Deploy started | 14:00 | ✓ |
| Release uploaded | 14:02 | ✓ |
| Migrations run | 14:03 | ✓ |
| App restarted | 14:05 | ✓ |
| Health check passed | 14:06 | ✓ |
| Smoke tests passed | 14:08 | ✓ |

### Post-Deployment Metrics
| Metric | Before | After | Status |
|--------|--------|-------|--------|
| Error Rate | 0.1% | 0.1% | ✓ OK |
| p99 Latency | 180ms | 185ms | ✓ OK |
| VM Memory | 45% | 48% | ✓ OK |
| Ecto Pool | 20% | 22% | ✓ OK |

### Issues Encountered
None / [List any issues]

### Rollback Status
Not required / [Details if rolled back]

### Summary
**Deployment**: SUCCESSFUL
**All Validations**: PASSED
**Rollback Required**: No

### Next Steps
- [ ] Monitor for 24 hours
- [ ] Verify Oban jobs running
- [ ] Check error tracking (Sentry)
- [ ] Update status page
- [ ] Close release ticket
```

## Environment-Specific Configs

### Development (`config/dev.exs`)
```elixir
config :my_app, MyAppWeb.Endpoint,
  debug_errors: true,
  code_reloader: true,
  check_origin: false

config :logger, :console, format: "[$level] $message\n"

config :my_app, MyApp.Repo,
  database: "my_app_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

### Staging
- Production-like config
- Real external services (sandbox mode)
- Anonymized data
- Full monitoring enabled

### Production (`config/runtime.exs`)
```elixir
config :my_app, MyAppWeb.Endpoint,
  url: [host: System.fetch_env!("PHX_HOST"), port: 443, scheme: "https"],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

config :my_app, MyApp.Repo,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

config :logger, level: :info
```

## Validation Integration

This skill integrates with the `validator` skill for pre-deployment checks:

```
"Run full validation before deployment"
```

All validation checks must pass before proceeding with deployment.
