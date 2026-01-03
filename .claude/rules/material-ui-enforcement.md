---
paths: ["**/*.ex", "**/*.heex", "**/*.html", "**/*.css", "**/*.js", "**/*.ts", "**/*.tsx", "**/*.jsx"]
alwaysApply: true
---

# Material UI Design System - MANDATORY ENFORCEMENT

**ALL applications built with this template MUST follow Material UI design patterns.**

This rule is auto-applied to ALL UI-related files. Non-compliance will result in inconsistent user experience across Interactor applications.

---

## STOP - Before Writing ANY UI Code

You MUST read these files in order:

1. `.claude/rules/i/ui-design/material-ui/index.md` - Source of truth for all patterns
2. `.claude/rules/i/ui-design/gnb-components.md` - Critical navigation patterns
3. `.claude/rules/i/ui-design/material-ui/checklist.md` - Validation checklist

---

## 6 MANDATORY Patterns (Non-Negotiable)

| # | Pattern | Correct Implementation | Common Mistake |
|---|---------|------------------------|----------------|
| 1 | **Lottie Animated Logo** | `InteractorLogo_Light.json` or `_Dark.json` | Using static PNG/SVG |
| 2 | **GREEN Create Button** | `#4CD964` with hover `#3DBF55` | Using blue/orange/other |
| 3 | **Quick Create (+)** | Green FAB in AppBar opens right panel | Missing or wrong action |
| 4 | **Dual Notification Badge** | Primary count + secondary red error count | Single badge only |
| 5 | **Warnings BELOW Items** | Warning placed immediately BELOW problematic item | Warning at TOP |
| 6 | **Feedback Section** | 5 emoji faces fixed at drawer bottom | Missing or wrong position |

---

## Design Tokens (Use These Exactly)

### Colors
```
Primary Green:    #4CD964  (hover: #3DBF55)
Error Red:        #FF3B30
Warning Yellow:   #FFCC00
Background:       #F5F5F5  (light) / #1E1E1E (dark)
Surface:          #FFFFFF  (light) / #2D2D2D (dark)
```

### Border Radius
```
Buttons:          9999px  (pill-shaped, rounded-full)
Cards/Modals:     16px    (rounded-2xl)
Inputs:           8px     (rounded-lg)
Chips/Tags:       9999px  (rounded-full)
```

### Sizing
```
AppBar Height:    64px    (h-16)
Sidebar Width:    240px   (w-64, open) / 56px (collapsed)
Right Panel:      320px   (w-80)
Icon Size:        24px    (size-6)
```

### Shadows
```
Elevated:         shadow-lg
Cards:            shadow-md
Subtle:           shadow-sm
```

---

## TailwindCSS Component Mappings

### Primary Button (Create Actions)
```html
<button class="bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium px-6 py-2 rounded-full shadow-md transition-colors">
  Create
</button>
```

### Secondary Button
```html
<button class="bg-white hover:bg-gray-50 text-gray-700 font-medium px-6 py-2 rounded-full border border-gray-200 shadow-sm transition-colors">
  Cancel
</button>
```

### AppBar
```html
<header class="bg-white shadow-sm h-16 fixed top-0 left-0 right-0 z-50 flex items-center px-4">
  <!-- Logo | Search | Actions -->
</header>
```

### Left Drawer
```html
<aside class="w-64 bg-white h-screen fixed left-0 top-16 shadow-lg flex flex-col">
  <!-- Create Button | Navigation | Flex Spacer | Feedback -->
</aside>
```

### Card
```html
<div class="bg-white rounded-2xl shadow-md p-6">
  <!-- Content -->
</div>
```

### FAB (Floating Action Button)
```html
<button class="bg-[#4CD964] hover:bg-[#3DBF55] rounded-full w-12 h-12 shadow-lg flex items-center justify-center text-white">
  <svg class="w-6 h-6"><!-- + icon --></svg>
</button>
```

---

## Phoenix/LiveView Component Patterns

### In core_components.ex

```elixir
# Primary button (GREEN for create actions)
attr :variant, :string, default: "primary", values: ~w(primary secondary danger)

def button(assigns) do
  ~H"""
  <button class={[
    "font-medium px-6 py-2 rounded-full shadow-md transition-colors",
    @variant == "primary" && "bg-[#4CD964] hover:bg-[#3DBF55] text-white",
    @variant == "secondary" && "bg-white hover:bg-gray-50 text-gray-700 border border-gray-200",
    @variant == "danger" && "bg-[#FF3B30] hover:bg-red-600 text-white"
  ]}>
    <%= render_slot(@inner_block) %>
  </button>
  """
end
```

### Layout Structure

```heex
<div class="min-h-screen bg-gray-100">
  <!-- AppBar -->
  <header class="bg-white shadow-sm h-16 fixed top-0 left-0 right-0 z-50">
    <!-- Navigation -->
  </header>

  <!-- Sidebar -->
  <aside class="w-64 bg-white h-screen fixed left-0 top-16 shadow-lg">
    <!-- Drawer content -->
  </aside>

  <!-- Main Content -->
  <main class="ml-64 pt-16 p-6">
    <%= @inner_content %>
  </main>
</div>
```

---

## Validation Checklist

Before committing UI code, verify:

- [ ] Using Lottie animated logo (not static image)
- [ ] All create buttons use `#4CD964` green
- [ ] AppBar has Quick Create (+) button on right
- [ ] Notifications show dual badge (count + errors)
- [ ] Warnings placed BELOW problematic items
- [ ] Feedback section (5 emoji) at drawer bottom
- [ ] All buttons are pill-shaped (`rounded-full`)
- [ ] Cards use `rounded-2xl` (16px radius)
- [ ] Using correct shadow levels

---

## Brand Assets Location

Copy from `.claude/assets/i/brand/` to your project:

```
lottie/InteractorLogo_Light.json  → public/brand/
lottie/InteractorLogo_Dark.json   → public/brand/
icons/icon_simple_green_v1.png    → public/brand/
```

---

## References

- Full Material UI Spec: `.claude/rules/i/ui-design/material-ui/index.md`
- GNB Components: `.claude/rules/i/ui-design/gnb-components.md`
- Implementation Checklist: `.claude/rules/i/ui-design/material-ui/checklist.md`
- TailwindCSS Mappings: `.claude/rules/i/ui-design/tailwind/index.md`
- Phoenix Patterns: `.claude/rules/i/ui-design/phoenix/index.md`
