# Backend Project Configuration - Elixir/Phoenix

## Technology Stack

This is an Elixir/Phoenix backend project. Apply the following technology-specific guidance.

### Language/Runtime
- **Elixir 1.15+** on Erlang/OTP 26+

### Framework
- **Phoenix 1.7+** with LiveView

### Database
- **PostgreSQL** with Ecto

### Key Libraries
- **Ecto** - Database wrapper and query DSL
- **Phoenix LiveView** - Real-time UI
- **Phoenix PubSub** - Distributed pub/sub
- **Oban** - Background job processing
- **Tesla/Req** - HTTP clients
- **Jason** - JSON encoding/decoding
- **Swoosh** - Email delivery

---

## Project Structure

```
lib/
├── my_app/                     # Core business logic (contexts)
│   ├── application.ex          # OTP Application supervisor
│   ├── repo.ex                 # Ecto Repo
│   ├── accounts/               # Accounts context
│   │   ├── accounts.ex         # Public API functions
│   │   ├── user.ex             # User schema
│   │   └── user_token.ex       # Token schema
│   ├── catalog/                # Catalog context (example)
│   │   ├── catalog.ex          # Public API functions
│   │   ├── product.ex          # Product schema
│   │   └── category.ex         # Category schema
│   └── workers/                # Oban workers
│       └── email_worker.ex
│
├── my_app_web/                 # Web interface layer
│   ├── endpoint.ex             # HTTP endpoint config
│   ├── router.ex               # Route definitions
│   ├── telemetry.ex            # Metrics/telemetry
│   ├── gettext.ex              # Internationalization
│   │
│   ├── controllers/            # REST/HTML controllers
│   │   ├── page_controller.ex
│   │   ├── api/                # JSON API controllers
│   │   │   └── user_json.ex
│   │   └── fallback_controller.ex
│   │
│   ├── live/                   # LiveView modules
│   │   ├── page_live.ex
│   │   └── user_live/
│   │       ├── index.ex
│   │       ├── show.ex
│   │       └── form_component.ex
│   │
│   ├── components/             # Phoenix components
│   │   ├── core_components.ex  # Core UI components
│   │   └── layouts/
│   │       ├── root.html.heex
│   │       └── app.html.heex
│   │
│   └── channels/               # WebSocket channels
│       └── user_socket.ex
│
├── config/
│   ├── config.exs              # Base configuration
│   ├── dev.exs                 # Development config
│   ├── test.exs                # Test config
│   ├── prod.exs                # Production config
│   └── runtime.exs             # Runtime config (env vars)
│
├── priv/
│   ├── repo/
│   │   ├── migrations/         # Database migrations
│   │   └── seeds.exs           # Seed data
│   ├── static/                 # Static assets
│   └── gettext/                # Translation files
│
└── test/
    ├── my_app/                 # Context tests
    ├── my_app_web/             # Web layer tests
    │   ├── controllers/
    │   └── live/
    └── support/                # Test helpers
        ├── conn_case.ex
        ├── data_case.ex
        └── fixtures/
```

---

## Commands

```bash
# Development
mix phx.server                          # Start server (localhost:4000)
iex -S mix phx.server                   # Start with IEx shell
MIX_ENV=dev mix run --no-halt           # Run without web server
mix deps.get                            # Install dependencies
mix deps.compile                        # Compile dependencies
mix compile                             # Compile application

# Database
mix ecto.create                         # Create database
mix ecto.drop                           # Drop database
mix ecto.migrate                        # Run pending migrations
mix ecto.rollback                       # Rollback last migration
mix ecto.reset                          # Drop + create + migrate + seed
mix ecto.gen.migration add_users        # Generate migration
mix ecto.dump                           # Dump schema to structure.sql

# Code Generation
mix phx.gen.live Accounts User users email:string name:string
mix phx.gen.html Catalog Product products name:string price:decimal
mix phx.gen.json API Article articles title:string body:text
mix phx.gen.context Accounts User users email:string
mix phx.gen.schema User users email:string
mix phx.gen.auth Accounts User users
mix phx.gen.channel Room
mix phx.gen.presence Presence

# Testing
mix test                                # Run all tests
mix test --cover                        # With coverage report
mix test test/my_app/accounts_test.exs  # Specific file
mix test test/my_app_web/live/:42       # Specific line
mix test --only integration             # Tagged tests
mix test --stale                        # Only changed tests

# Code Quality
mix format                              # Format all files
mix format --check-formatted            # CI format check
mix credo --strict                      # Static analysis
mix dialyzer                            # Type checking
mix sobelow                             # Security analysis
mix hex.audit                           # Dependency audit

# Release
mix release                             # Build release
mix phx.gen.release                     # Generate release files
MIX_ENV=prod mix assets.deploy          # Deploy assets
```

---

## Contexts (Domain Design)

### Context Structure
```elixir
# lib/my_app/accounts/accounts.ex
defmodule MyApp.Accounts do
  @moduledoc """
  The Accounts context - manages users and authentication.
  """

  import Ecto.Query
  alias MyApp.Repo
  alias MyApp.Accounts.{User, UserToken}

  ## User functions

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.
  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a user by email.
  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
```

### Schema Pattern
```elixir
# lib/my_app/accounts/user.ex
defmodule MyApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :role, Ecto.Enum, values: [:user, :admin], default: :user

    has_many :posts, MyApp.Blog.Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :role])
    |> validate_required([:email, :name])
    |> validate_email()
    |> validate_password()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, MyApp.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_length(:password, min: 12, max: 72)
    |> maybe_hash_password()
  end

  defp maybe_hash_password(changeset) do
    password = get_change(changeset, :password)

    if password && changeset.valid? do
      changeset
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end
end
```

---

## LiveView Patterns

### LiveView Module
```elixir
# lib/my_app_web/live/user_live/index.ex
defmodule MyAppWeb.UserLive.Index do
  use MyAppWeb, :live_view

  alias MyApp.Accounts
  alias MyApp.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :users, Accounts.list_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, Accounts.get_user!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Users")
    |> assign(:user, nil)
  end

  @impl true
  def handle_info({MyAppWeb.UserLive.FormComponent, {:saved, user}}, socket) do
    {:noreply, stream_insert(socket, :users, user)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)

    {:noreply, stream_delete(socket, :users, user)}
  end
end
```

### Form Component
```elixir
# lib/my_app_web/live/user_live/form_component.ex
defmodule MyAppWeb.UserLive.FormComponent do
  use MyAppWeb, :live_component

  alias MyApp.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="user-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:email]} type="email" label="Email" />
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :edit, user_params) do
    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        notify_parent({:saved, user})

        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        notify_parent({:saved, user})

        {:noreply,
         socket
         |> put_flash(:info, "User created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
```

---

## API Design (JSON)

### Controller Pattern
```elixir
# lib/my_app_web/controllers/api/user_controller.ex
defmodule MyAppWeb.API.UserController do
  use MyAppWeb, :controller

  alias MyApp.Accounts
  alias MyApp.Accounts.User

  action_fallback MyAppWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
```

### JSON View
```elixir
# lib/my_app_web/controllers/api/user_json.ex
defmodule MyAppWeb.API.UserJSON do
  alias MyApp.Accounts.User

  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end
```

### Fallback Controller
```elixir
# lib/my_app_web/controllers/fallback_controller.ex
defmodule MyAppWeb.FallbackController do
  use MyAppWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: MyAppWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: MyAppWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: MyAppWeb.ErrorJSON)
    |> render(:"401")
  end
end
```

---

## Background Jobs (Oban)

### Worker Pattern
```elixir
# lib/my_app/workers/email_worker.ex
defmodule MyApp.Workers.EmailWorker do
  use Oban.Worker, queue: :emails, max_attempts: 3

  alias MyApp.Mailer
  alias MyApp.Emails

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"type" => "welcome", "user_id" => user_id}}) do
    user = MyApp.Accounts.get_user!(user_id)

    Emails.welcome_email(user)
    |> Mailer.deliver()
  end

  def perform(%Oban.Job{args: %{"type" => "password_reset", "user_id" => user_id}}) do
    user = MyApp.Accounts.get_user!(user_id)

    Emails.password_reset_email(user)
    |> Mailer.deliver()
  end
end

# Enqueue job
%{type: "welcome", user_id: user.id}
|> MyApp.Workers.EmailWorker.new()
|> Oban.insert()

# Schedule job
%{type: "reminder", user_id: user.id}
|> MyApp.Workers.EmailWorker.new(scheduled_at: DateTime.add(DateTime.utc_now(), 3600, :second))
|> Oban.insert()
```

---

## Testing

### Context Test
```elixir
# test/my_app/accounts_test.exs
defmodule MyApp.AccountsTest do
  use MyApp.DataCase, async: true

  alias MyApp.Accounts
  alias MyApp.Accounts.User

  describe "users" do
    import MyApp.AccountsFixtures

    @invalid_attrs %{email: nil, name: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "test@example.com", name: "Test User"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "test@example.com"
      assert user.name == "Test User"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 with duplicate email returns error" do
      user = user_fixture()
      attrs = %{email: user.email, name: "Another User"}

      assert {:error, changeset} = Accounts.create_user(attrs)
      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end
  end
end
```

### LiveView Test
```elixir
# test/my_app_web/live/user_live_test.exs
defmodule MyAppWeb.UserLiveTest do
  use MyAppWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import MyApp.AccountsFixtures

  describe "Index" do
    setup [:create_user]

    test "lists all users", %{conn: conn, user: user} do
      {:ok, _index_live, html} = live(conn, ~p"/users")

      assert html =~ "Users"
      assert html =~ user.email
    end

    test "saves new user", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("a", "New User") |> render_click() =~
               "New User"

      assert_patch(index_live, ~p"/users/new")

      assert index_live
             |> form("#user-form", user: %{email: "new@example.com", name: "New User"})
             |> render_submit()

      assert_patch(index_live, ~p"/users")

      html = render(index_live)
      assert html =~ "User created successfully"
      assert html =~ "new@example.com"
    end

    test "deletes user in listing", %{conn: conn, user: user} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("#users-#{user.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#users-#{user.id}")
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
```

### Test Fixtures
```elixir
# test/support/fixtures/accounts_fixtures.ex
defmodule MyApp.AccountsFixtures do
  @moduledoc """
  Test fixtures for Accounts context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      name: "Test User",
      password: "valid_password123"
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> MyApp.Accounts.create_user()

    user
  end
end
```

---

## Performance

### Database Queries
```elixir
# Preload associations to avoid N+1
users = Repo.all(from u in User, preload: [:posts, :comments])

# Use select for specific fields
emails = Repo.all(from u in User, select: u.email)

# Use streams for large datasets
Repo.stream(from u in User)
|> Stream.each(&process_user/1)
|> Stream.run()

# Index important columns
create index(:users, [:email])
create index(:posts, [:user_id, :inserted_at])
```

### Caching with ETS
```elixir
# In your application.ex
children = [
  {Cachex, name: :app_cache}
]

# Usage
Cachex.get(:app_cache, "key")
Cachex.put(:app_cache, "key", value, ttl: :timer.hours(1))
```

---

## Security

### Authentication (phx.gen.auth)
```bash
mix phx.gen.auth Accounts User users
```

### Authorization Pattern
```elixir
# lib/my_app_web/plugs/authorize.ex
defmodule MyAppWeb.Plugs.Authorize do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, required_role) do
    user = conn.assigns[:current_user]

    if user && user.role in List.wrap(required_role) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> put_view(MyAppWeb.ErrorJSON)
      |> render(:"403")
      |> halt()
    end
  end
end

# Usage in router
pipeline :admin do
  plug MyAppWeb.Plugs.Authorize, [:admin]
end
```

### Input Validation
- Always use changesets for validation
- Use `Ecto.Changeset.cast/4` to whitelist fields
- Validate at the schema level
- Use `unsafe_validate_unique/3` for real-time feedback

---

## Health Checks

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
      cache: check_cache()
    }

    status = if Enum.all?(checks, fn {_, v} -> v == :ok end), do: :ok, else: :error
    http_status = if status == :ok, do: 200, else: 503

    conn
    |> put_status(http_status)
    |> json(%{status: status, checks: checks})
  end

  defp check_database do
    case Ecto.Adapters.SQL.query(MyApp.Repo, "SELECT 1", []) do
      {:ok, _} -> :ok
      _ -> :error
    end
  end

  defp check_cache do
    case Cachex.get(:app_cache, :health_check) do
      {:ok, _} -> :ok
      _ -> :error
    end
  end
end
```

---

## Deployment

### Release Configuration
```elixir
# config/runtime.exs
import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise "DATABASE_URL environment variable is not set"

  config :my_app, MyApp.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true,
    ssl_opts: [verify: :verify_none]

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "SECRET_KEY_BASE environment variable is not set"

  host =
    System.get_env("PHX_HOST") ||
      raise "PHX_HOST environment variable is not set"

  config :my_app, MyAppWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [port: String.to_integer(System.get_env("PORT") || "4000")],
    secret_key_base: secret_key_base,
    server: true
end
```

### Dockerfile
```dockerfile
FROM elixir:1.15-alpine AS build

RUN apk add --no-cache build-base git

WORKDIR /app

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

COPY config config
COPY lib lib
COPY priv priv
COPY assets assets

RUN mix assets.deploy
RUN mix compile
RUN mix release

FROM alpine:3.18 AS app

RUN apk add --no-cache libstdc++ openssl ncurses-libs

WORKDIR /app

COPY --from=build /app/_build/prod/rel/my_app ./

ENV HOME=/app
CMD ["bin/my_app", "start"]
```
