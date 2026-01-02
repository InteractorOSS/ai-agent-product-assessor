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
