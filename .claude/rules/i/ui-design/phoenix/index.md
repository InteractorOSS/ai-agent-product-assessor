# Phoenix/LiveView Adapter - Interactor Design System

**For all pattern requirements and visual specifications, see [@material-ui/index.md](../material-ui/index.md).**

This adapter provides only the translation mappings from MUI/React patterns to Phoenix LiveView and HEEX templates.

---

## When to Use

Apply this adapter when the project has `mix.exs` with Phoenix/LiveView dependencies.

---

## Concept Translation Table

### Core Patterns

| MUI/React Pattern | Phoenix/LiveView Equivalent |
|-------------------|----------------------------|
| React component | HEEX function component |
| `useState()` | LiveView assigns (`@variable`) |
| `onClick={handler}` | `phx-click="event_name"` |
| `onChange={handler}` | `phx-change="event_name"` |
| `className="..."` | `class="..."` |
| Conditional rendering `{condition && <Component />}` | `<div :if={@condition}>` |
| List rendering `{items.map(item => ...)}` | `<%= for item <- @items do %>` |
| Props destructuring | `attr :name, :type` declarations |

### State Management

| React Pattern | LiveView Equivalent |
|---------------|---------------------|
| `const [open, setOpen] = useState(false)` | `assign(socket, :open, false)` |
| `setOpen(true)` | `{:noreply, assign(socket, :open, true)}` |
| `useEffect(() => {...}, [deps])` | `handle_info/2` or `handle_async/3` |
| Context/Redux | LiveView assigns or PubSub |

### Event Handling

| React Pattern | LiveView Equivalent |
|---------------|---------------------|
| `onClick={() => setOpen(true)}` | `phx-click="open"` |
| `onClick={(e) => handler(e, id)}` | `phx-click="action" phx-value-id={id}` |
| `onClickAway={close}` | `phx-click-away="close"` |
| `onSubmit={handleSubmit}` | `phx-submit="submit"` |

---

## Component Translation Examples

### Buttons

**MUI:**
```jsx
<Button
  variant="contained"
  sx={{ bgcolor: '#4CD964' }}
  startIcon={<AddIcon />}
  onClick={handleCreate}
>
  Create
</Button>
```

**Phoenix/HEEX:**
```heex
<button
  class="bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium px-4 py-2 rounded-lg flex items-center gap-2"
  phx-click="create"
>
  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
  </svg>
  Create
</button>
```

### Badges

**MUI:**
```jsx
<Badge badgeContent={count} color="primary">
  <NotificationsIcon />
</Badge>
```

**Phoenix/HEEX:**
```heex
<button class="relative p-2">
  <svg><!-- icon --></svg>
  <span :if={@count > 0} class="absolute top-0 right-0 w-4 h-4 bg-blue-500 text-white text-xs rounded-full flex items-center justify-center">
    <%= @count %>
  </span>
</button>
```

### Conditional Rendering

**MUI/React:**
```jsx
{showPanel && <Panel onClose={() => setShowPanel(false)} />}
```

**Phoenix/HEEX:**
```heex
<.panel :if={@show_panel} />
```

---

## LiveView Hooks for JavaScript

For patterns requiring JavaScript (like Lottie animations):

```javascript
// assets/js/hooks/lottie_animation.js
import lottie from 'lottie-web';

const LottieAnimation = {
  mounted() {
    const src = this.el.dataset.src;
    this.animation = lottie.loadAnimation({
      container: this.el,
      path: src,
      loop: false,
      autoplay: true
    });
  },
  destroyed() {
    if (this.animation) this.animation.destroy();
  }
};

export default LottieAnimation;
```

Register in `app.js`:
```javascript
import LottieAnimation from './hooks/lottie_animation';
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { LottieAnimation }
});
```

Usage in HEEX:
```heex
<div phx-hook="LottieAnimation" data-src="/brand/lottie/InteractorLogo_Light.json" class="h-8 w-24"></div>
```

---

## Setup

### 1. Copy Brand Assets

```bash
cp -r .claude/assets/i/brand/lottie priv/static/brand/
cp -r .claude/assets/i/brand/icons priv/static/brand/
```

### 2. TailwindCSS Config

```javascript
// assets/tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        'interactor-green': '#4CD964',
        'interactor-green-hover': '#3DBF55',
        'interactor-error': '#FF3B30',
      }
    }
  }
}
```

---

## Color Reference

| Purpose | Hex | TailwindCSS |
|---------|-----|-------------|
| Interactor Green | `#4CD964` | `bg-[#4CD964]` |
| Green Hover | `#3DBF55` | `hover:bg-[#3DBF55]` |
| Error Red | `#FF3B30` | `bg-[#FF3B30]` |

See [@tailwind/colors.md](../tailwind/colors.md) for complete color mappings.

---

## Common Validation Errors

| Error | Fix |
|-------|-----|
| Using `bg-primary` for Create button | Use `bg-[#4CD964]` explicitly |
| Using `<img>` for logo | Use `phx-hook="LottieAnimation"` |
| Single notification badge | Add second badge with `:if={@error_count > 0}` |
| Warning at top of drawer | Move warning BELOW the problematic item |

---

## Feedback Modal Implementation

Complete Phoenix LiveView implementation for the 5-emoji feedback modal pattern.

### FeedbackHooks Module

Create this module to handle feedback state across all LiveViews:

```elixir
# lib/my_app_web/hooks/feedback_hooks.ex
defmodule MyAppWeb.FeedbackHooks do
  @moduledoc """
  LiveView hooks for the feedback modal system.

  Attach to your live_session to enable feedback collection on all pages:

      live_session :default,
        on_mount: [{MyAppWeb.FeedbackHooks, :default}] do
        live "/", PageLive, :index
      end
  """

  import Phoenix.LiveView
  import Phoenix.Component

  @rating_labels %{
    1 => "Very Dissatisfied",
    2 => "Dissatisfied",
    3 => "Neutral",
    4 => "Satisfied",
    5 => "Very Satisfied"
  }

  @rating_emojis %{
    1 => "😞",
    2 => "😟",
    3 => "😐",
    4 => "🙂",
    5 => "😊"
  }

  def on_mount(:default, _params, _session, socket) do
    socket =
      socket
      |> assign(:show_feedback_modal, false)
      |> assign(:feedback_rating, nil)
      |> assign(:feedback_page_url, nil)
      |> attach_hook(:feedback_events, :handle_event, &handle_feedback_event/3)
      |> attach_hook(:feedback_params, :handle_params, &capture_page_url/3)

    {:cont, socket}
  end

  defp capture_page_url(_params, uri, socket) do
    {:cont, assign(socket, :feedback_page_url, uri)}
  end

  defp handle_feedback_event("open_feedback_modal", params, socket) do
    rating = case params do
      %{"rating" => rating} when is_binary(rating) -> String.to_integer(rating)
      %{"rating" => rating} when is_integer(rating) -> rating
      _ -> nil
    end
    {:halt, socket |> assign(:show_feedback_modal, true) |> assign(:feedback_rating, rating)}
  end

  defp handle_feedback_event("close_feedback_modal", _params, socket) do
    {:halt, socket |> assign(:show_feedback_modal, false) |> assign(:feedback_rating, nil)}
  end

  defp handle_feedback_event("select_feedback_rating", %{"rating" => rating}, socket) do
    rating = if is_binary(rating), do: String.to_integer(rating), else: rating
    {:halt, assign(socket, :feedback_rating, rating)}
  end

  defp handle_feedback_event("submit_feedback", params, socket) do
    %{"rating" => rating, "comment" => comment} = params
    rating = if is_binary(rating) and rating != "", do: String.to_integer(rating), else: nil

    if rating do
      feedback_data = %{
        rating: rating,
        comment: comment,
        page_url: socket.assigns[:feedback_page_url],
        user_id: get_user_id(socket),
        user_agent: params["user_agent"],
        viewport: params["viewport"],
        timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
      }

      # Log feedback (replace with your analytics/support integration)
      require Logger
      Logger.info("[Feedback] #{rating}/5 #{rating_to_emoji(rating)} - #{feedback_data.page_url}")

      # Optional: Persist to database
      # MyApp.Feedback.create_feedback(feedback_data)

      {:halt, socket
        |> assign(:show_feedback_modal, false)
        |> assign(:feedback_rating, nil)
        |> put_flash(:info, "Thank you for your feedback!")}
    else
      {:halt, put_flash(socket, :error, "Please select a rating")}
    end
  end

  defp handle_feedback_event(_event, _params, socket), do: {:cont, socket}

  defp get_user_id(socket) do
    case socket.assigns do
      %{current_user: %{id: id}} -> id
      _ -> nil
    end
  end

  defp rating_to_emoji(rating), do: Map.get(@rating_emojis, rating, "")

  # Helper functions for templates
  def rating_label(rating), do: Map.get(@rating_labels, rating, "")
  def rating_emoji(rating), do: Map.get(@rating_emojis, rating, "")
end
```

### JavaScript Hook

Add this hook to capture browser context data:

```javascript
// assets/js/hooks/feedback_modal.js
const FeedbackModal = {
  mounted() {
    this.populateBrowserContext()
  },

  updated() {
    this.populateBrowserContext()
  },

  populateBrowserContext() {
    // Populate user agent
    const userAgentField = document.getElementById(`${this.el.id}-user-agent`)
    if (userAgentField) {
      userAgentField.value = navigator.userAgent
    }

    // Populate viewport dimensions
    const viewportField = document.getElementById(`${this.el.id}-viewport`)
    if (viewportField) {
      viewportField.value = `${window.innerWidth}x${window.innerHeight}`
    }
  }
}

export default FeedbackModal
```

Register in `app.js`:
```javascript
import FeedbackModal from './hooks/feedback_modal'
import LottieAnimation from './hooks/lottie_animation'

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: {
    FeedbackModal,
    LottieAnimation
  }
})
```

### Router Integration

Add the feedback hooks to your live_session:

```elixir
# lib/my_app_web/router.ex
live_session :default,
  on_mount: [{MyAppWeb.FeedbackHooks, :default}] do
  live "/", PageLive, :index
  live "/dashboard", DashboardLive, :index
  # ... other routes
end
```

### Sidebar Trigger Component

```heex
<%!-- Feedback trigger at bottom of sidebar --%>
<div class="mt-auto border-t border-[#E5E5EA] dark:border-[#3A3A3C]">
  <div class="px-4 py-3">
    <span class="text-xs font-medium text-[#8E8E93] uppercase tracking-wider">
      Feedback
    </span>
    <div class="flex justify-around mt-2">
      <%= for {rating, emoji} <- [{1, "😞"}, {2, "😟"}, {3, "😐"}, {4, "🙂"}, {5, "😊"}] do %>
        <button
          phx-click="open_feedback_modal"
          phx-value-rating={rating}
          class="text-2xl opacity-60 hover:opacity-100 hover:scale-110 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-[#4CD964] rounded-lg p-1"
          aria-label={rating_label(rating)}
        >
          <%= emoji %>
        </button>
      <% end %>
    </div>
  </div>
</div>
```

### Feedback Modal Component

```heex
<%!-- Feedback Modal - include in your app layout or root layout --%>
<div
  :if={@show_feedback_modal}
  id="feedback-modal"
  phx-hook="FeedbackModal"
  class="fixed inset-0 bg-black/50 flex items-center justify-center z-50"
  phx-click-away="close_feedback_modal"
>
  <div
    class="relative w-full max-w-md mx-4 bg-white dark:bg-[#2C2C2E] rounded-2xl shadow-2xl"
    phx-click="noop"
  >
    <%!-- Close button --%>
    <button
      phx-click="close_feedback_modal"
      class="absolute top-4 right-4 p-1 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white rounded-full hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors"
    >
      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
      </svg>
    </button>

    <%!-- Modal content --%>
    <form phx-submit="submit_feedback" class="p-6 pt-8">
      <%!-- Title --%>
      <h3 class="text-xl font-bold text-[#1C1C1E] dark:text-white mb-1 text-center">
        Share Your Feedback
      </h3>
      <p class="text-sm text-[#8E8E93] mb-6 text-center">
        How are you feeling about your experience?
      </p>

      <%!-- Emoji rating selector --%>
      <div class="flex justify-center gap-2 mb-2">
        <%= for {rating, emoji} <- [{1, "😞"}, {2, "😟"}, {3, "😐"}, {4, "🙂"}, {5, "😊"}] do %>
          <button
            type="button"
            phx-click="select_feedback_rating"
            phx-value-rating={rating}
            class={[
              "text-3xl p-2 rounded-xl transition-all duration-200",
              if(@feedback_rating == rating,
                do: "opacity-100 ring-2 ring-[#4CD964] bg-[#E8F8EB] dark:bg-[#4CD964]/10",
                else: "opacity-60 hover:opacity-100 hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C]"
              )
            ]}
            aria-label={"#{rating_label(rating)} - #{rating} star"}
          >
            <%= emoji %>
          </button>
        <% end %>
      </div>

      <%!-- Rating label --%>
      <p class="text-sm text-center text-[#4CD964] font-medium mb-6 h-5">
        <%= if @feedback_rating, do: rating_label(@feedback_rating) %>
      </p>

      <%!-- Hidden rating input --%>
      <input type="hidden" name="rating" value={@feedback_rating || ""} />

      <%!-- Comment textarea --%>
      <div class="mb-4">
        <label class="block text-sm font-medium text-[#1C1C1E] dark:text-white mb-2">
          What can we improve? <span class="text-[#8E8E93] font-normal">(optional)</span>
        </label>
        <textarea
          name="comment"
          rows="3"
          class="w-full px-4 py-3 bg-[#F5F5F7] dark:bg-[#3A3A3C] border-0 rounded-xl text-[#1C1C1E] dark:text-white placeholder-[#8E8E93] focus:outline-none focus:ring-2 focus:ring-[#4CD964] resize-none"
          placeholder="Tell us more about your experience..."
        ></textarea>
      </div>

      <%!-- Context display --%>
      <div class="flex items-center gap-2 text-sm text-[#8E8E93] mb-6">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
        </svg>
        <span>Feedback for: <span class="text-[#1C1C1E] dark:text-white"><%= @feedback_page_url %></span></span>
      </div>

      <%!-- Hidden fields for context data (populated by JS hook) --%>
      <input type="hidden" name="user_agent" id="feedback-modal-user-agent" />
      <input type="hidden" name="viewport" id="feedback-modal-viewport" />

      <%!-- Action buttons --%>
      <div class="flex gap-3">
        <button
          type="button"
          phx-click="close_feedback_modal"
          class="flex-1 px-6 py-3 bg-[#F5F5F7] dark:bg-[#3A3A3C] text-[#1C1C1E] dark:text-white font-medium rounded-full hover:bg-[#E5E5EA] dark:hover:bg-[#4A4A4C] transition-colors"
        >
          Cancel
        </button>
        <button
          type="submit"
          disabled={is_nil(@feedback_rating)}
          class={[
            "flex-1 px-6 py-3 text-white font-semibold rounded-full transition-colors",
            if(@feedback_rating,
              do: "bg-[#4CD964] hover:bg-[#3DBF55]",
              else: "bg-[#4CD964] opacity-50 cursor-not-allowed"
            )
          ]}
        >
          Submit Feedback
        </button>
      </div>
    </form>
  </div>
</div>
```

### Helper Functions for Templates

Import these in your views or use a helper module:

```elixir
# In your view or component
defp rating_label(1), do: "Very Dissatisfied"
defp rating_label(2), do: "Dissatisfied"
defp rating_label(3), do: "Neutral"
defp rating_label(4), do: "Satisfied"
defp rating_label(5), do: "Very Satisfied"
defp rating_label(_), do: ""
```

### Usage Example

In your app layout (`lib/my_app_web/components/layouts/app.html.heex`):

```heex
<div class="flex h-screen">
  <%!-- Sidebar --%>
  <aside class="w-64 flex flex-col border-r border-[#E5E5EA] dark:border-[#3A3A3C]">
    <%!-- Navigation content --%>
    <nav class="flex-1 overflow-y-auto">
      <%!-- ... navigation items ... --%>
    </nav>

    <%!-- Feedback trigger (from above) --%>
    <.feedback_trigger />
  </aside>

  <%!-- Main content --%>
  <main class="flex-1">
    <%= @inner_content %>
  </main>
</div>

<%!-- Feedback modal (from above) --%>
<.feedback_modal
  show={@show_feedback_modal}
  rating={@feedback_rating}
  page_url={@feedback_page_url}
/>
