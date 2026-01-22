# Testing Guide Skill (Elixir/ExUnit)

Guidelines for writing effective, maintainable tests.

## Quick Reference

### Coverage Requirements
| Metric | Minimum | Target |
|--------|---------|--------|
| Overall | 80% | 90% |
| Critical Paths | 100% | 100% |
| New Code | 80% | 95% |

### Common Commands
```bash
mix test                    # Run all tests
mix test --cover            # With coverage
mix test path/to/test.exs   # Specific file
mix test path:42            # Specific line
mix test --only integration # Tagged tests
mix test --stale            # Changed tests only
```

### Test Types
- **Unit**: Context functions, schemas, pure logic (fast, async)
- **Integration**: Controllers, LiveView, channels (database sandbox)
- **E2E**: Full browser tests with Wallaby/Hound (slow)

---

## Detailed Guidelines

### AAA Pattern
```elixir
test "create_user/1 with valid data creates a user" do
  # Arrange - Set up test data
  valid_attrs = %{email: "test@example.com", name: "Test User"}

  # Act - Execute the code
  result = Accounts.create_user(valid_attrs)

  # Assert - Verify results
  assert {:ok, %User{} = user} = result
  assert user.email == "test@example.com"
end
```

### Fixture Pattern
```elixir
defmodule MyApp.AccountsFixtures do
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

### Testing CRUD
```elixir
describe "users" do
  test "list_users/0 returns all users" do
    user = user_fixture()
    assert Accounts.list_users() == [user]
  end

  test "create_user/1 with valid data" do
    assert {:ok, %User{}} = Accounts.create_user(valid_attrs)
  end

  test "create_user/1 with invalid data" do
    assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
  end
end
```

### LiveView Testing
```elixir
test "saves new user", %{conn: conn} do
  {:ok, index_live, _html} = live(conn, ~p"/users")

  assert index_live |> element("a", "New User") |> render_click() =~ "New User"
  assert_patch(index_live, ~p"/users/new")

  assert index_live
         |> form("#user-form", user: valid_attrs)
         |> render_submit()

  assert_patch(index_live, ~p"/users")
  assert render(index_live) =~ "User created successfully"
end
```

### Using Mox
```elixir
# Define mock
Mox.defmock(MyApp.HTTPClientMock, for: MyApp.HTTPClient)

# In test
setup :verify_on_exit!

test "fetches data from external API" do
  expect(MyApp.HTTPClientMock, :get, fn url ->
    {:ok, %{body: %{items: []}}}
  end)

  assert {:ok, []} = MyApp.ExternalAPI.fetch_items()
end
```

### Test Tags
```elixir
@tag :slow
test "processes large dataset" do
  # slow test
end

@tag :integration
test "calls external API" do
  # integration test
end

# Run: mix test --only slow
# Skip: mix test --exclude slow
```

### Anti-Patterns to Avoid

**Don't test implementation details:**
```elixir
# Bad - testing private function
test "calls hash_password internally"

# Good - test through public API
test "password is hashed on creation"
```

**Don't depend on test order:**
```elixir
# Bad - tests share state
# Good - each test is independent with fresh fixtures
```

**Don't over-mock:**
```elixir
# Bad - mocking everything
# Good - test real behavior, mock only external dependencies
```

### Critical Paths (100% Coverage Required)
- Authentication/authorization
- Payment processing
- Data mutations
- Security-sensitive operations
- Core business logic (contexts)
