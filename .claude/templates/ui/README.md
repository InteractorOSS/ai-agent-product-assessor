# Material UI Component Templates

Pre-built Phoenix/LiveView templates following Material UI design patterns.

## Templates

| Template | Description |
|----------|-------------|
| `app_bar.html.heex` | Material AppBar with logo, search, Quick Create FAB, notifications, profile |
| `drawer.html.heex` | Left sidebar with Create button, navigation, and feedback section |
| `notification_badge.html.heex` | Dual notification badge (primary + error count) |
| `create_button.html.heex` | Green pill-shaped button variants |
| `layout.html.heex` | Full-page Material layout structure |

## Usage

1. **Copy templates** to your project's `lib/my_app_web/components/` or layout directories
2. **Customize** the templates for your specific needs
3. **Integrate** into your `core_components.ex` for reusable components

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
