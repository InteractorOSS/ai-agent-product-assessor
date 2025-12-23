# Testing Rules - Elixir/ExUnit

Guidelines for writing effective, maintainable tests in Elixir with ExUnit.

## Coverage Requirements

| Metric | Minimum | Target |
|--------|---------|--------|
| Overall Coverage | 80% | 90% |
| Critical Paths | 100% | 100% |
| New Code | 80% | 95% |
| Branch Coverage | 70% | 85% |

### Critical Paths (100% Required)
- Authentication/authorization
- Payment processing
- Data mutations
- Security-sensitive operations
- Core business logic (contexts)

---

## Running Tests

```bash
# Run all tests
mix test

# Run with coverage
mix test --cover

# Run specific file
mix test test/my_app/accounts_test.exs

# Run specific test at line
mix test test/my_app/accounts_test.exs:42

# Run tests matching a pattern
mix test --only integration
mix test --exclude slow

# Run only changed tests
mix test --stale

# Run with seed for reproducibility
mix test --seed 12345

# Verbose output
mix test --trace
```

---

## Test Types

### Unit Tests (Context Tests)
**What to test:**
- Context functions
- Schema validations
- Pure business logic
- Utility functions
- Data transformations

**Characteristics:**
- Fast (< 10ms per test)
- Use `async: true` when possible
- Test through public context APIs

### Integration Tests (Controller/LiveView)
**What to test:**
- HTTP endpoints
- LiveView interactions
- WebSocket channels
- Database transactions

**Characteristics:**
- May use database sandbox
- Test realistic user flows
- Use `ConnCase` or custom case modules

### E2E Tests (Wallaby/Hound)
**What to test:**
- Critical user journeys
- JavaScript interactions
- Full browser rendering

**Characteristics:**
- Slower to execute
- Run against full application
- Test from user perspective

---

## Test Structure

### Naming Convention
```elixir
defmodule MyApp.AccountsTest do
  use MyApp.DataCase, async: true

  alias MyApp.Accounts
  alias MyApp.Accounts.User

  describe "users" do
    test "list_users/0 returns all users" do
      # test implementation
    end

    test "create_user/1 with valid data creates a user" do
      # test implementation
    end

    test "create_user/1 with invalid data returns error changeset" do
      # test implementation
    end
  end

  describe "authentication" do
    test "authenticate_user/2 with valid credentials returns user" do
      # test implementation
    end

    test "authenticate_user/2 with invalid password returns error" do
      # test implementation
    end
  end
end
```

### AAA Pattern (Arrange, Act, Assert)
```elixir
test "create_user/1 with valid data creates a user" do
  # Arrange - Set up test data
  valid_attrs = %{
    email: "test@example.com",
    name: "Test User",
    password: "valid_password123"
  }

  # Act - Execute the code
  result = Accounts.create_user(valid_attrs)

  # Assert - Verify results
  assert {:ok, %User{} = user} = result
  assert user.email == "test@example.com"
  assert user.name == "Test User"
end
```

---

## Test Cases Module

### DataCase (Context Testing)
```elixir
# test/support/data_case.ex
defmodule MyApp.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias MyApp.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import MyApp.DataCase
    end
  end

  setup tags do
    MyApp.DataCase.setup_sandbox(tags)
    :ok
  end

  def setup_sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(MyApp.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end

  @doc """
  Helper for extracting errors from a changeset.
  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
```

### ConnCase (Controller/LiveView Testing)
```elixir
# test/support/conn_case.ex
defmodule MyAppWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint MyAppWeb.Endpoint

      use MyAppWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import MyAppWeb.ConnCase
    end
  end

  setup tags do
    MyApp.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in users.
  """
  def register_and_log_in_user(%{conn: conn}) do
    user = MyApp.AccountsFixtures.user_fixture()
    %{conn: log_in_user(conn, user), user: user}
  end

  def log_in_user(conn, user) do
    token = MyApp.Accounts.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end
end
```

---

## Test Fixtures

### Fixture Module Pattern
```elixir
# test/support/fixtures/accounts_fixtures.ex
defmodule MyApp.AccountsFixtures do
  @moduledoc """
  Test fixtures for the Accounts context.
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

  def admin_fixture(attrs \\ %{}) do
    {:ok, admin} =
      attrs
      |> valid_user_attributes()
      |> Map.put(:role, :admin)
      |> MyApp.Accounts.create_user()

    admin
  end
end
```

### Using Fixtures
```elixir
defmodule MyApp.AccountsTest do
  use MyApp.DataCase, async: true

  import MyApp.AccountsFixtures

  describe "users" do
    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end
end
```

---

## Context Tests

### Testing CRUD Operations
```elixir
defmodule MyApp.AccountsTest do
  use MyApp.DataCase, async: true

  alias MyApp.Accounts
  alias MyApp.Accounts.User

  import MyApp.AccountsFixtures

  describe "users" do
    @invalid_attrs %{email: nil, name: nil, password: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        email: "test@example.com",
        name: "Test User",
        password: "valid_password123"
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "test@example.com"
      assert user.name == "Test User"
      assert user.hashed_password != nil
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 with duplicate email returns error changeset" do
      user = user_fixture()

      assert {:error, changeset} =
               Accounts.create_user(%{
                 email: user.email,
                 name: "Another User",
                 password: "valid_password123"
               })

      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{name: "Updated Name"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.name == "Updated Name"
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
```

### Testing Validations
```elixir
describe "user validations" do
  test "email must be valid format" do
    attrs = valid_user_attributes(email: "invalid-email")
    changeset = User.changeset(%User{}, attrs)
    assert %{email: ["must be a valid email"]} = errors_on(changeset)
  end

  test "email must be unique" do
    user = user_fixture()
    attrs = valid_user_attributes(email: user.email)

    {:error, changeset} = Accounts.create_user(attrs)
    assert %{email: ["has already been taken"]} = errors_on(changeset)
  end

  test "password must be at least 12 characters" do
    attrs = valid_user_attributes(password: "short")
    changeset = User.changeset(%User{}, attrs)
    assert %{password: ["should be at least 12 character(s)"]} = errors_on(changeset)
  end

  test "name is required" do
    attrs = valid_user_attributes(name: nil)
    changeset = User.changeset(%User{}, attrs)
    assert %{name: ["can't be blank"]} = errors_on(changeset)
  end
end
```

---

## Controller Tests

### JSON API Testing
```elixir
defmodule MyAppWeb.API.UserControllerTest do
  use MyAppWeb.ConnCase, async: true

  import MyApp.AccountsFixtures

  alias MyApp.Accounts.User

  @create_attrs %{
    email: "test@example.com",
    name: "Test User",
    password: "valid_password123"
  }

  @invalid_attrs %{email: nil, name: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "test@example.com",
               "name" => "Test User"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: %{name: "Updated"})
      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")
      assert %{"name" => "Updated"} = json_response(conn, 200)["data"]
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
```

---

## LiveView Tests

### Basic LiveView Testing
```elixir
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
             |> form("#user-form", user: %{email: "", name: ""})
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user-form", user: %{
               email: "new@example.com",
               name: "New User",
               password: "valid_password123"
             })
             |> render_submit()

      assert_patch(index_live, ~p"/users")

      html = render(index_live)
      assert html =~ "User created successfully"
      assert html =~ "new@example.com"
    end

    test "updates user in listing", %{conn: conn, user: user} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("#users-#{user.id} a", "Edit") |> render_click() =~
               "Edit User"

      assert_patch(index_live, ~p"/users/#{user}/edit")

      assert index_live
             |> form("#user-form", user: %{name: "Updated Name"})
             |> render_submit()

      assert_patch(index_live, ~p"/users")

      html = render(index_live)
      assert html =~ "User updated successfully"
      assert html =~ "Updated Name"
    end

    test "deletes user in listing", %{conn: conn, user: user} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("#users-#{user.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#users-#{user.id}")
    end
  end

  describe "Show" do
    setup [:create_user]

    test "displays user", %{conn: conn, user: user} do
      {:ok, _show_live, html} = live(conn, ~p"/users/#{user}")

      assert html =~ "Show User"
      assert html =~ user.email
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
```

### LiveView Event Testing
```elixir
describe "real-time updates" do
  test "receives PubSub updates", %{conn: conn} do
    {:ok, live_view, _html} = live(conn, ~p"/dashboard")

    # Simulate a PubSub broadcast
    Phoenix.PubSub.broadcast(
      MyApp.PubSub,
      "dashboard:updates",
      {:new_order, %{id: 1, total: 100}}
    )

    # Assert the LiveView received and rendered the update
    assert render(live_view) =~ "New order: $100"
  end
end
```

---

## Testing Async Operations

### Testing Background Jobs (Oban)
```elixir
defmodule MyApp.Workers.EmailWorkerTest do
  use MyApp.DataCase, async: true
  use Oban.Testing, repo: MyApp.Repo

  alias MyApp.Workers.EmailWorker

  import MyApp.AccountsFixtures

  test "enqueues welcome email job" do
    user = user_fixture()

    assert {:ok, _job} =
             %{type: "welcome", user_id: user.id}
             |> EmailWorker.new()
             |> Oban.insert()

    assert_enqueued(worker: EmailWorker, args: %{type: "welcome", user_id: user.id})
  end

  test "performs welcome email delivery" do
    user = user_fixture()

    assert :ok =
             perform_job(EmailWorker, %{type: "welcome", user_id: user.id})

    # Assert email was sent (using Swoosh test adapter)
    assert_email_sent(to: user.email)
  end
end
```

### Testing GenServers
```elixir
defmodule MyApp.CacheTest do
  use ExUnit.Case, async: true

  alias MyApp.Cache

  setup do
    {:ok, pid} = Cache.start_link(name: nil)
    %{cache: pid}
  end

  test "stores and retrieves values", %{cache: cache} do
    :ok = Cache.put(cache, :key, "value")
    assert {:ok, "value"} = Cache.get(cache, :key)
  end

  test "returns error for missing keys", %{cache: cache} do
    assert {:error, :not_found} = Cache.get(cache, :missing)
  end

  test "expires values after TTL", %{cache: cache} do
    :ok = Cache.put(cache, :key, "value", ttl: 10)
    Process.sleep(15)
    assert {:error, :not_found} = Cache.get(cache, :key)
  end
end
```

---

## Mocking and Test Doubles

### Using Mox for Mocking
```elixir
# In test/support/mocks.ex
Mox.defmock(MyApp.HTTPClientMock, for: MyApp.HTTPClient)

# In config/test.exs
config :my_app, :http_client, MyApp.HTTPClientMock

# In tests
defmodule MyApp.ExternalAPITest do
  use MyApp.DataCase, async: true

  import Mox

  setup :verify_on_exit!

  test "fetches data from external API" do
    expect(MyApp.HTTPClientMock, :get, fn url ->
      assert url == "https://api.example.com/data"
      {:ok, %{body: %{items: []}}}
    end)

    assert {:ok, []} = MyApp.ExternalAPI.fetch_items()
  end

  test "handles API errors" do
    expect(MyApp.HTTPClientMock, :get, fn _url ->
      {:error, :timeout}
    end)

    assert {:error, :api_unavailable} = MyApp.ExternalAPI.fetch_items()
  end
end
```

### Stub Modules
```elixir
# For testing modules that send emails
defmodule MyApp.MailerStub do
  def deliver(email) do
    send(self(), {:email_sent, email})
    {:ok, email}
  end
end

# In test
test "sends welcome email on registration" do
  Application.put_env(:my_app, :mailer, MyApp.MailerStub)

  {:ok, _user} = Accounts.register_user(%{email: "test@example.com"})

  assert_receive {:email_sent, email}
  assert email.to == "test@example.com"
  assert email.subject =~ "Welcome"
end
```

---

## Test Tags and Configuration

### Using Tags
```elixir
# Skip slow tests by default
@tag :slow
test "processes large dataset" do
  # slow test
end

# Mark integration tests
@tag :integration
test "calls external API" do
  # integration test
end

# Run with: mix test --only slow
# Skip with: mix test --exclude slow
```

### Configure in test_helper.exs
```elixir
# test/test_helper.exs
ExUnit.start()

# Exclude integration tests by default
ExUnit.configure(exclude: [:integration])

Ecto.Adapters.SQL.Sandbox.mode(MyApp.Repo, :manual)
```

---

## Anti-Patterns to Avoid

### Don't Test Implementation Details
```elixir
# Bad - testing internal function
test "calls hash_password internally" do
  # Don't test private functions directly
end

# Good - test through public API
test "password is hashed on user creation" do
  {:ok, user} = Accounts.create_user(%{
    email: "test@example.com",
    password: "valid_password123"
  })

  assert user.hashed_password != nil
  assert user.hashed_password != "valid_password123"
end
```

### Don't Depend on Test Order
```elixir
# Bad - tests share state
test "creates user" do
  @user = user_fixture()
  # ...
end

test "uses created user" do
  # Fails if previous test didn't run
  Accounts.update_user(@user, %{name: "New"})
end

# Good - each test is independent
test "creates user" do
  user = user_fixture()
  # ...
end

test "updates user" do
  user = user_fixture()  # Create fresh user
  {:ok, updated} = Accounts.update_user(user, %{name: "New"})
  assert updated.name == "New"
end
```

### Don't Over-Mock
```elixir
# Bad - mocking everything
test "creates user" do
  mock(Repo, :insert, fn _ -> {:ok, %User{}} end)
  mock(User, :changeset, fn _, _ -> %Changeset{} end)
  # Test is now meaningless
end

# Good - test real behavior, mock only external dependencies
test "creates user" do
  {:ok, user} = Accounts.create_user(valid_attrs)
  assert user.email == valid_attrs.email
end
```
