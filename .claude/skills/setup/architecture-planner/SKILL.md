---
name: architecture-planner
description: Design and document system architecture including component diagrams, data flow, API design, and scalability planning. Use during planning phase or for architectural decisions.
author: David Jung
---

# Architecture Planner Skill

Guide architectural decisions with structured analysis and comprehensive documentation.

## When to Use

- Starting a new project
- Planning major features
- Making technology decisions
- Scaling existing systems
- Documenting system design

## Instructions

### Step 1: Requirements Analysis

Before designing, gather:

#### Functional Requirements
- Core features and capabilities
- User workflows
- Integration points
- Data requirements

#### Non-Functional Requirements
- **Performance**: Response time, throughput
- **Scalability**: Expected growth, peak load
- **Availability**: Uptime requirements (99.9%?)
- **Security**: Compliance, data sensitivity
- **Maintainability**: Team size, skill set

#### Constraints
- Budget limitations
- Timeline requirements
- Technology mandates
- Team expertise
- Regulatory compliance

### Step 2: Architecture Style Selection

Choose based on requirements:

| Style | Best For | Trade-offs |
|-------|----------|------------|
| **Monolith** | Simple apps, small teams | Easy to start, hard to scale |
| **Microservices** | Complex domains, large teams | Scalable, complex to operate |
| **Serverless** | Event-driven, variable load | Cost-effective, vendor lock-in |
| **Event-Driven** | Async workflows, decoupling | Scalable, harder to debug |

### Step 3: Component Design

Define each component:

```markdown
## Component: [Name]

**Responsibility**: Single sentence describing what it does

**Interfaces**:
- Input: [What it receives]
- Output: [What it produces]

**Dependencies**:
- [Component/Service it depends on]

**Technology**: [Implementation tech]

**Scaling Strategy**: [How it scales]
```

### Step 4: Data Architecture

#### Data Model
- Entity relationships
- Data ownership
- Access patterns

#### Storage Selection
| Data Type | Storage | Reason |
|-----------|---------|--------|
| Transactional | PostgreSQL | ACID compliance, Ecto support |
| Session | ETS/Redis | In-memory, distributed |
| Cache | Cachex/ETS | Built-in Elixir, fast access |
| Search | PostgreSQL Full-Text / Elasticsearch | Native or dedicated |
| Files | S3 | Scalable storage |
| Jobs Queue | Oban (PostgreSQL) | Persistent, reliable |

### Step 5: API Design

#### REST API Guidelines
```
GET    /resources          # List
GET    /resources/:id      # Get one
POST   /resources          # Create
PUT    /resources/:id      # Full update
PATCH  /resources/:id      # Partial update
DELETE /resources/:id      # Delete
```

#### API Versioning
- URL: `/api/v1/resources`
- Header: `Accept: application/vnd.api+json; version=1`

### Step 6: Infrastructure Design

#### Environments
- Development: Local/shared dev
- Staging: Production-like
- Production: Live system

#### Deployment Strategy
- Blue-Green
- Canary releases
- Rolling updates

## Output Format

```markdown
# Architecture Design Document

## Overview

[Brief description of the system]

## Requirements Summary

### Functional
- [FR-1] [Description]
- [FR-2] [Description]

### Non-Functional
| Requirement | Target | Priority |
|-------------|--------|----------|
| Response Time | < 200ms | High |
| Availability | 99.9% | High |
| Throughput | 1000 req/s | Medium |

## Architecture Decision

**Selected Style**: [Style name]

**Rationale**: [Why this style]

**Trade-offs Accepted**:
- [Trade-off 1]
- [Trade-off 2]

## System Components

```
┌─────────────────────────────────────────────────────────┐
│                      Load Balancer                       │
└─────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│   Web Server  │   │   Web Server  │   │   Web Server  │
└───────────────┘   └───────────────┘   └───────────────┘
        │                   │                   │
        └───────────────────┼───────────────────┘
                            ▼
                    ┌───────────────┐
                    │   API Gateway │
                    └───────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│ User Service  │   │ Order Service │   │Product Service│
└───────────────┘   └───────────────┘   └───────────────┘
        │                   │                   │
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│   User DB     │   │   Order DB    │   │  Product DB   │
└───────────────┘   └───────────────┘   └───────────────┘
```

## Component Details

### [Component Name]
- **Responsibility**: [What it does]
- **Technology**: [Tech stack]
- **Interfaces**: [APIs exposed]
- **Dependencies**: [What it needs]
- **Scaling**: [How it scales]

## Data Flow

### [Flow Name] (e.g., User Registration)
1. User submits form
2. API Gateway validates request
3. User Service creates account
4. Notification Service sends email
5. Response returned to user

## API Design

### Endpoints
| Method | Path | Description |
|--------|------|-------------|
| POST | /api/v1/users | Create user |
| GET | /api/v1/users/:id | Get user |

## Infrastructure

### Environment Configuration
| Env | Purpose | Resources |
|-----|---------|-----------|
| Dev | Development | Minimal |
| Staging | Testing | Production-like |
| Production | Live | Full scale |

### Deployment
- Strategy: [Blue-Green/Canary/Rolling]
- CI/CD: [Tool]
- Monitoring: [Tool]

## Security

- Authentication: [Method]
- Authorization: [Method]
- Data Encryption: [At rest/In transit]

## Scalability Strategy

### Horizontal Scaling
- [Component] scales based on [metric]

### Caching Strategy
- [What is cached]
- [Cache invalidation strategy]

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| [Risk 1] | High | Medium | [Strategy] |

## Decision Log

| Decision | Date | Rationale |
|----------|------|-----------|
| Use PostgreSQL | YYYY-MM-DD | ACID compliance needed |
```

## Architecture Patterns

### Phoenix Layered Architecture
```
┌─────────────────────────┐
│    Web Layer            │  Controllers, LiveViews, Channels
│    (MyAppWeb)           │  HTTP/WebSocket handling
├─────────────────────────┤
│    Context Layer        │  Business logic, public APIs
│    (MyApp.Accounts)     │  Domain boundaries
├─────────────────────────┤
│    Schema Layer         │  Ecto schemas, changesets
│    (MyApp.Accounts.User)│  Data validation
├─────────────────────────┤
│    Infrastructure       │  Repo, external services
│    (MyApp.Repo)         │  Database, APIs
└─────────────────────────┘
```

### Phoenix Contexts
Contexts group related functionality and define clear boundaries:
```elixir
# Good - clear context boundaries
MyApp.Accounts         # User management, authentication
MyApp.Catalog          # Products, categories
MyApp.Orders           # Shopping cart, checkout
MyApp.Notifications    # Email, push notifications
```

### OTP Patterns
- **GenServer**: Stateful processes, in-memory state
- **Supervisor**: Process supervision, fault tolerance
- **Agent**: Simple state wrapper
- **Task**: One-off async operations
- **Registry**: Process discovery and naming

### Event-Driven with Phoenix PubSub
```elixir
# Publish events
Phoenix.PubSub.broadcast(MyApp.PubSub, "orders:#{order.id}", {:order_updated, order})

# Subscribe in LiveView
Phoenix.PubSub.subscribe(MyApp.PubSub, "orders:#{@order.id}")
```

## Best Practices

1. **Start simple** - Don't over-engineer
2. **Document decisions** - Use ADRs
3. **Plan for failure** - Design for resilience
4. **Consider operations** - How will it be maintained?
5. **Security by design** - Not an afterthought

---

## Elixir/Phoenix Specific Patterns

### Context Design Guidelines
```elixir
# Keep contexts focused on one domain
defmodule MyApp.Accounts do
  # Public API for user management
  def list_users/0
  def get_user!/1
  def create_user/1
  def update_user/2
  def delete_user/1
  def change_user/2  # Returns changeset for forms
end

# Cross-context communication via function calls
defmodule MyApp.Orders do
  alias MyApp.Accounts

  def create_order(user_id, items) do
    user = Accounts.get_user!(user_id)
    # Order creation logic
  end
end
```

### LiveView Architecture
```
┌─────────────────────────────────────────┐
│              Router                      │
└─────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        ▼                       ▼
┌───────────────┐       ┌───────────────┐
│  LiveView     │       │  LiveView     │
│  (Page)       │       │  (Page)       │
└───────────────┘       └───────────────┘
        │                       │
        ▼                       ▼
┌───────────────┐       ┌───────────────┐
│ LiveComponent │       │ LiveComponent │
│ (Form)        │       │ (Table)       │
└───────────────┘       └───────────────┘
```

### Supervision Tree Example
```elixir
# lib/my_app/application.ex
defmodule MyApp.Application do
  use Application

  def start(_type, _args) do
    children = [
      # Database
      MyApp.Repo,
      # PubSub for real-time features
      {Phoenix.PubSub, name: MyApp.PubSub},
      # Background jobs
      {Oban, Application.fetch_env!(:my_app, Oban)},
      # Cache
      {Cachex, name: :app_cache},
      # Custom GenServers
      MyApp.RateLimiter,
      # Web endpoint (must be last)
      MyAppWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

### API Versioning
```elixir
# router.ex
scope "/api", MyAppWeb.API do
  pipe_through :api

  scope "/v1", V1 do
    resources "/users", UserController
    resources "/products", ProductController
  end

  scope "/v2", V2 do
    resources "/users", UserController
    resources "/products", ProductController
  end
end
```

### Database Schema Patterns
```elixir
# UUID primary keys (recommended for distributed systems)
@primary_key {:id, :binary_id, autogenerate: true}
@foreign_key_type :binary_id

# Soft deletes
field :deleted_at, :utc_datetime

# Polymorphic associations via embedded schemas
embeds_many :metadata, Metadata, on_replace: :delete

# Enum fields
field :status, Ecto.Enum, values: [:pending, :active, :completed]
```

### Performance Patterns
```elixir
# Preload to avoid N+1
Repo.all(from u in User, preload: [:posts])

# Batch inserts
Repo.insert_all(User, users_data, on_conflict: :nothing)

# Streaming large datasets
Repo.stream(query)
|> Stream.chunk_every(1000)
|> Stream.each(&process_batch/1)
|> Stream.run()

# Async operations
Task.async(fn -> expensive_operation() end)
|> Task.await()
```
