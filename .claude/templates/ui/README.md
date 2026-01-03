# Material UI Component Templates

Pre-built Phoenix/LiveView templates following Material UI design patterns.

## ⛔ MANDATORY - Start Here

**Every application MUST use the app_layout template as the default layout:**

```bash
cp .claude/templates/ui/phoenix/app_layout.html.heex lib/my_app_web/components/layouts/app.html.heex
```

## Templates

### Phoenix/LiveView (`phoenix/` directory)

| Template | Description | MANDATORY |
|----------|-------------|-----------|
| `app_layout.html.heex` | **Full 3-panel layout**: AppBar + Left Drawer + Main Content + Right Pane | ✅ YES |
| `nav_item.html.heex` | Navigation item component with active state, count badge, and warning support | Recommended |

## Default Layout Structure

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│ APPBAR (GNB) - Logo, AI Input, Notifications, Profile, Quick Create (+)          │
├─────────────────┬────────────────────────────────────────────┬───────────────────┤
│ LEFT DRAWER     │           MAIN CONTENT                     │ RIGHT PANE        │
│ [+ Create] 🟢   │           (page content)                   │ (AI Copilot or    │
│ Navigation      │                                            │  Quick Create)    │
│ Feedback 😞-😊  │                                            │                   │
└─────────────────┴────────────────────────────────────────────┴───────────────────┘
```

## Usage

1. **Copy the app layout** to your project's layouts directory
2. **Customize navigation items** for your app's routes
3. **Add LiveView hooks** for Lottie animations and feedback modal
4. **Wire up events** for drawer toggle, AI input, feedback, etc.

## 6 Mandatory Patterns

All templates implement these required patterns:

| # | Pattern | Implementation |
|---|---------|----------------|
| 1 | Lottie Animated Logo | `<lottie-player>` in app_bar.html.heex |
| 2 | GREEN Create Button | `#4CD964` in create_button.html.heex |
| 3 | Quick Create (+) | FAB in app_bar.html.heex |
| 4 | Dual Notification Badge | notification_badge.html.heex |
| 5 | Warnings BELOW Items | Example in drawer.html.heex |
| 6 | Feedback Section | 5 emoji at drawer bottom |

## Design Tokens

All templates use these standard values:

```
Colors:
  Primary Green:    #4CD964  (hover: #3DBF55)
  Error Red:        #FF3B30
  Warning Yellow:   #FFCC00
  Background:       #F5F5F5 / #1E1E1E
  Surface:          #FFFFFF / #2D2D2D

Border Radius:
  Buttons:          rounded-full (9999px)
  Cards/Modals:     rounded-2xl (16px)
  Inputs:           rounded-lg (8px)

Sizing:
  AppBar:           h-16 (64px)
  Sidebar:          w-64 (240px)
  Right Panel:      w-80 (320px)
```

## Required Setup

### 1. Lottie Player

Add to your layout's `<head>`:
```html
<script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>
```

### 2. Brand Assets

Copy from `.claude/assets/i/brand/` to `priv/static/brand/`:
- `lottie/InteractorLogo_Light.json`
- `lottie/InteractorLogo_Dark.json`

### 3. TailwindCSS

Ensure these colors are available (already supported via arbitrary values):
- `bg-[#4CD964]` - Primary green
- `bg-[#3DBF55]` - Primary green hover
- `bg-[#FF3B30]` - Error red
- `text-[#FFCC00]` - Warning yellow

## Reference

See `.claude/rules/material-ui-enforcement.md` for complete specifications.
