# Code Style Rules - Elixir/Phoenix

These rules apply to all Elixir code in the project. Follow these guidelines for consistent, maintainable code.

## General Principles

1. **Readability over cleverness** - Code should be easy to understand
2. **Consistency** - Follow existing patterns in the codebase
3. **Let it crash** - Use supervisors for fault tolerance, not defensive coding
4. **Immutability** - Embrace immutable data structures
5. **Pipeline-oriented** - Use `|>` for data transformation chains

---

## Formatting

### Automatic Formatting
Always use `mix format` for consistent formatting:
```bash
mix format           # Format all files
mix format --check-formatted  # CI check
```

### Line Length
- Maximum 98 characters (default for Elixir formatter)
- Break long lines at logical points

### Indentation
- 2 spaces for indentation
- No tabs

---

## Naming Conventions

### Modules
```elixir
# Good - CamelCase, descriptive
defmodule MyApp.Accounts.User do
defmodule MyAppWeb.UserController do
defmodule MyApp.Workers.EmailWorker do

# Bad
defmodule Myapp.accounts.user do
defmodule MyApp.User_Controller do
```

### Functions
```elixir
# Good - snake_case, verb + noun
def get_user(id), do: ...
def list_users, do: ...
def create_user(attrs), do: ...
def update_user(user, attrs), do: ...
def delete_user(user), do: ...

# With bang (!) - raises on error
def get_user!(id), do: ...

# With question mark (?) - returns boolean
def valid_email?(email), do: ...
def admin?(user), do: ...

# Bad - unclear purpose
def process(data), do: ...
def handle(x), do: ...
```

### Variables
```elixir
# Good - snake_case, descriptive
user_email = "user@example.com"
is_authenticated = true
order_items = []
max_retry_count = 3

# Bad - abbreviated or unclear
ue = "user@example.com"
auth = true
arr = []
```

### Module Attributes
```elixir
# Good - ALL_CAPS for compile-time constants
@max_retries 3
@default_timeout 5_000
@api_base_url "https://api.example.com"

# Module documentation
@moduledoc """
The Accounts context manages user authentication and authorization.
"""

# Function documentation
@doc """
Gets a user by ID.

## Examples

    iex> get_user(123)
    {:ok, %User{}}

"""
```

### Files and Directories
```
# Good - snake_case matching module name
lib/my_app/accounts/user.ex           # MyApp.Accounts.User
lib/my_app_web/controllers/user_controller.ex
lib/my_app_web/live/user_live/index.ex
test/my_app/accounts_test.exs

# Bad
lib/my_app/Accounts/User.ex
lib/my_app_web/controllers/UserController.ex
```

---

## Functions

### Keep Functions Small
```elixir
# Good - single responsibility, pattern matching for clarity
def process_order(%Order{status: :pending} = order) do
  order
  |> validate_items()
  |> calculate_total()
  |> apply_discounts()
  |> finalize()
end

def process_order(%Order{status: :completed}), do: {:error, :already_completed}
def process_order(%Order{status: :cancelled}), do: {:error, :cancelled}
```

### Use Pattern Matching
```elixir
# Good - pattern match in function heads
def greet(%{name: name}), do: "Hello, #{name}!"
def greet(_), do: "Hello, stranger!"

# Good - pattern match in case
case Repo.get(User, id) do
  %User{} = user -> {:ok, user}
  nil -> {:error, :not_found}
end

# Good - with statement for happy path
with {:ok, user} <- get_user(user_id),
     {:ok, order} <- create_order(user, items),
     {:ok, _email} <- send_confirmation(order) do
  {:ok, order}
end
```

### Use the Pipe Operator
```elixir
# Good - clear data flow
result =
  data
  |> parse()
  |> validate()
  |> transform()
  |> save()

# Bad - nested calls
result = save(transform(validate(parse(data))))
```

### Return Consistent Types
```elixir
# Good - consistent {:ok, value} | {:error, reason}
def create_user(attrs) do
  %User{}
  |> User.changeset(attrs)
  |> Repo.insert()
end

# Raises on failure (for "expected to succeed" cases)
def get_user!(id) do
  Repo.get!(User, id)
end
```

---

## Ecto Patterns

### Schemas
```elixir
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
    belongs_to :organization, MyApp.Organizations.Organization

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :role])
    |> validate_required([:email, :name])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_length(:password, min: 12, max: 72)
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password ->
        put_change(changeset, :hashed_password, Bcrypt.hash_pwd_salt(password))
    end
  end
end
```

### Queries
```elixir
# Good - use Ecto.Query for complex queries
import Ecto.Query

def list_active_users do
  from(u in User,
    where: u.active == true,
    order_by: [desc: u.inserted_at],
    preload: [:profile]
  )
  |> Repo.all()
end

# Good - composable queries
def base_query, do: from(u in User)

def active(query), do: where(query, [u], u.active == true)

def recent(query, days \\ 7) do
  cutoff = DateTime.add(DateTime.utc_now(), -days, :day)
  where(query, [u], u.inserted_at >= ^cutoff)
end

# Usage
User
|> base_query()
|> active()
|> recent(30)
|> Repo.all()
```

---

## Phoenix Patterns

### Controllers
```elixir
defmodule MyAppWeb.UserController do
  use MyAppWeb, :controller

  alias MyApp.Accounts
  alias MyApp.Accounts.User

  # Use action_fallback for error handling
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
end
```

### LiveView
```elixir
defmodule MyAppWeb.UserLive.Index do
  use MyAppWeb, :live_view

  alias MyApp.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :users, Accounts.list_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)
    {:noreply, stream_delete(socket, :users, user)}
  end

  # Private functions at the bottom
  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "Users")
  end
end
```

---

## Error Handling

### Use Tagged Tuples
```elixir
# Good - explicit success/error tuples
def fetch_user(id) do
  case Repo.get(User, id) do
    %User{} = user -> {:ok, user}
    nil -> {:error, :not_found}
  end
end

# Handling errors
case fetch_user(user_id) do
  {:ok, user} -> render(conn, :show, user: user)
  {:error, :not_found} -> send_resp(conn, 404, "Not found")
end
```

### Custom Error Types
```elixir
defmodule MyApp.Errors do
  defmodule NotFoundError do
    defexception [:message, :resource, :id]

    @impl true
    def exception(opts) do
      resource = Keyword.fetch!(opts, :resource)
      id = Keyword.fetch!(opts, :id)
      msg = "#{resource} with id #{id} not found"
      %__MODULE__{message: msg, resource: resource, id: id}
    end
  end

  defmodule ValidationError do
    defexception [:message, :changeset]
  end
end
```

### Let It Crash (When Appropriate)
```elixir
# Good - crash on truly unexpected errors
def get_user!(id) do
  Repo.get!(User, id)  # Raises Ecto.NoResultsError if not found
end

# Good - handle expected errors gracefully
def get_user(id) do
  case Repo.get(User, id) do
    nil -> {:error, :not_found}
    user -> {:ok, user}
  end
end
```

---

## Documentation

### Module Documentation
```elixir
defmodule MyApp.Accounts do
  @moduledoc """
  The Accounts context.

  This context handles user management, authentication, and authorization.
  It provides a clean API for working with users and their associated data.

  ## Examples

      iex> list_users()
      [%User{}, ...]

      iex> create_user(%{email: "test@example.com"})
      {:ok, %User{}}

  """
end
```

### Function Documentation
```elixir
@doc """
Gets a user by ID.

Returns `{:ok, user}` if found, `{:error, :not_found}` otherwise.

## Parameters

  * `id` - The user's unique identifier (UUID)

## Examples

    iex> get_user("valid-uuid")
    {:ok, %User{}}

    iex> get_user("invalid-uuid")
    {:error, :not_found}

"""
@spec get_user(String.t()) :: {:ok, User.t()} | {:error, :not_found}
def get_user(id) do
  # implementation
end
```

### Typespecs
```elixir
@type user_params :: %{
  email: String.t(),
  name: String.t(),
  password: String.t()
}

@spec create_user(user_params()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
def create_user(attrs) do
  # implementation
end
```

---

## Avoid

### Magic Numbers and Strings
```elixir
# Bad
if user.role == "admin" do
if retries > 3 do

# Good
@admin_role :admin
@max_retries 3

if user.role == @admin_role do
if retries > @max_retries do
```

### Deeply Nested Conditionals
```elixir
# Bad
def process(data) do
  if valid?(data) do
    if authorized?(data) do
      if has_permission?(data) do
        do_process(data)
      end
    end
  end
end

# Good - use with
def process(data) do
  with :ok <- validate(data),
       :ok <- authorize(data),
       :ok <- check_permission(data) do
    do_process(data)
  end
end
```

### Unnecessary Defensive Code
```elixir
# Bad - too defensive in Elixir
def get_name(user) do
  if user != nil do
    if user.name != nil do
      user.name
    else
      "Unknown"
    end
  else
    "Unknown"
  end
end

# Good - pattern matching
def get_name(%{name: name}) when is_binary(name), do: name
def get_name(_), do: "Unknown"
```

### Commented-Out Code
```elixir
# Bad - delete, don't comment
def calculate_total(items) do
  # items
  # |> Enum.map(& &1.price)
  # |> Enum.sum()

  Enum.reduce(items, 0, & &1.price + &2)
end

# Good - just working code
def calculate_total(items) do
  Enum.reduce(items, 0, & &1.price + &2)
end
```

---

## Code Organization

### Module Structure
```elixir
defmodule MyApp.Accounts.User do
  # 1. use/import/alias/require
  use Ecto.Schema
  import Ecto.Changeset
  alias MyApp.Organizations.Organization

  # 2. Module attributes
  @primary_key {:id, :binary_id, autogenerate: true}
  @max_name_length 100

  # 3. Schema definition
  schema "users" do
    # fields
  end

  # 4. Public functions
  def changeset(user, attrs) do
    # ...
  end

  def admin?(%__MODULE__{role: :admin}), do: true
  def admin?(_), do: false

  # 5. Private functions (at the bottom)
  defp hash_password(changeset) do
    # ...
  end
end
```

### Context Organization
```elixir
defmodule MyApp.Accounts do
  # Imports and aliases at top
  import Ecto.Query
  alias MyApp.Repo
  alias MyApp.Accounts.{User, UserToken}

  # Group related functions with comments

  ## User functions

  def list_users, do: Repo.all(User)
  def get_user!(id), do: Repo.get!(User, id)
  def create_user(attrs), do: # ...
  def update_user(user, attrs), do: # ...
  def delete_user(user), do: # ...
  def change_user(user, attrs \\ %{}), do: # ...

  ## Authentication functions

  def authenticate_user(email, password), do: # ...
  def generate_user_session_token(user), do: # ...
  def get_user_by_session_token(token), do: # ...
end
```
