# Material UI Design Rules

These rules apply **ONLY** when the project uses Material UI (MUI) as the design system.

---

## ⚠️ CRITICAL REQUIREMENTS - MUST IMPLEMENT

The following 6 patterns are **MANDATORY** for all Interactor applications. Failure to implement these correctly will result in inconsistent UX.

| # | Requirement | ❌ Common Mistake | ✅ Correct Implementation |
|---|-------------|-------------------|---------------------------|
| 1 | **Lottie Animated Logo** | Using static PNG/SVG | Use `InteractorLogo_Light.json` or `_Dark.json` with lottie-react |
| 2 | **GREEN Create Button** | Using orange/blue/primary color | Use `#4CD964` (Interactor green) for the + Create button in drawer |
| 3 | **Quick Create (+)** | Missing or wrong action | Green + button in AppBar right section opens Quick Create panel |
| 4 | **Dual Notification Badge** | Single badge only | Primary badge (notifications) + secondary red badge (errors) |
| 5 | **Warnings BELOW Items** | Warning at TOP of drawer | Warning placed immediately BELOW the specific problematic item |
| 6 | **Feedback Section** | Missing or at wrong position | 5 emoji faces (😞😟😐🙂😊) FIXED at BOTTOM of drawer |

### Warning Placement - Visual Guide

```
❌ WRONG - Warning at top of drawer:        ✅ CORRECT - Warning below item:
┌───────────────────────────────┐          ┌───────────────────────────────┐
│  [+ Create]                   │          │  [+ Create]  🟢               │
├───────────────────────────────┤          ├───────────────────────────────┤
│  ┌───────────────────────────┐│          │  CHANNELS                     │
│  │ ⚠️ 2 channels need...     ││ ← WRONG  │  📧 All Channels           0  │
│  └───────────────────────────┘│          │  👤 peter@interactor...    0  │ ← Has issue
│  CHANNELS                     │          │  ┌───────────────────────────┐│
│  📧 All Channels           0  │          │  │ ⚠️ 2 channels need...     ││ ← CORRECT
│  👤 peter@interactor...    0  │          │  │   Click to reconnect   >  ││
│  👤 Peter Jung/Pulzze      0  │          │  └───────────────────────────┘│
└───────────────────────────────┘          │  👤 Peter Jung/Pulzze      0  │ ← No issue
                                           └───────────────────────────────┘
```

**Why this matters**: Warnings placed BELOW items create clear visual association. Users immediately understand which specific item has the problem.

---

## Applicability

Apply these rules when:
- `@mui/material` is in `package.json`
- Components import from `@mui/material` or `@mui/icons-material`
- The project explicitly states it uses Material UI/MUI

---

## Module Reference

This design system is split into focused modules for better performance:

| Module | Description | When to Load |
|--------|-------------|--------------|
| [navigation.md](./navigation.md) | Global Navigation Bar (AppBar) | Building top navigation |
| [settings.md](./settings.md) | Settings pages (Profile, Preferences, Notifications) | Building settings/profile pages |
| [drawer.md](./drawer.md) | Left Navigation Drawer/Sidebar | Building side navigation |
| [checklist.md](./checklist.md) | Implementation checklist & validation | Reviewing implementations |

**Load only the module(s) relevant to your current task.**

---

## Interactor Brand Assets

**IMPORTANT**: Always use the centralized brand assets located in `.claude/assets/i/brand/`:

```
.claude/assets/i/brand/
├── brand-config.json          # Configuration and asset mappings
├── icons/                     # Interactor icons (PNG)
│   ├── icon_simple_green_v1.png   # Primary icon (recommended for nav)
│   ├── icon_simple_grey_v1.png
│   ├── icon_simple_white_v1.png
│   └── interactor_symbol_*.png    # Various sizes (5, 25, 50, 100)
├── logos/                     # Interactor logos (PNG, SVG)
│   ├── logo_green.png
│   ├── logo_blue.png
│   ├── logo_white_with_icon.png
│   └── 20221116_interactor_BI*.svg
├── lottie/                    # Animated logos (JSON + .lottie formats)
│   ├── InteractorLogo_Light.json   # For light backgrounds (use with lottie-react)
│   ├── InteractorLogo_Light.lottie # For light backgrounds (dotLottie format)
│   ├── InteractorLogo_Dark.json    # For dark backgrounds (use with lottie-react)
│   ├── InteractorLogo_Dark.lottie  # For dark backgrounds (dotLottie format)
│   ├── Interactor_FullLogo_Animation.json
│   └── Interactor_FullLogo_Animation.lottie
├── favicons/                  # Website favicons (full set)
└── powered-by/                # "Powered by Interactor" badges
```

**Note**: Copy required assets from `.claude/assets/i/brand/` to your app's public/assets directory.

### Usage Examples

**Step 1: Copy assets to your application**
```bash
cp -r .claude/assets/i/brand public/brand
# Or for bundler imports:
cp -r .claude/assets/i/brand src/assets/brand
```

**Step 2: Use in components**
```jsx
// Lottie animation (using lottie-react)
import Lottie from 'lottie-react';
import logoAnimation from '@/assets/brand/lottie/InteractorLogo_Light.json';

<Lottie animationData={logoAnimation} style={{ width: 120, height: 40 }} />

// Static icon
<img src="/brand/icons/icon_simple_green_v1.png" alt="Interactor" />

// Theme-aware icon and logo
const iconFile = theme.palette.mode === 'dark'
  ? 'icon_simple_white_v1.png'   // White icon for dark mode
  : 'icon_simple_green_v1.png';  // Green icon for light mode
const logoFile = theme.palette.mode === 'dark'
  ? 'InteractorLogo_Dark.json'
  : 'InteractorLogo_Light.json';
```

---

## Quick Reference

### Navigation Layout (see [navigation.md](./navigation.md))

```
┌────────────────────────────────────────────────────────────────────────────────┐
│ [≡] [⊞] [Interactor🎬]    [✨ What can I do for you?... ➤]   [🔔¹²] [?] [👤] [+]│
│  ↑    ↑        ↑                      ↑                        ↑    ↑   ↑    ↑ │
│ Toggle Tools  LottieLogo           AI Input                Notif Help Prof Quick│
│                                                            +Err              Create│
└────────────────────────────────────────────────────────────────────────────────┘
```

- **Left**: Sidebar toggle → Tools → **Lottie Animated Logo** (NOT static icon!)
  - **Logo**: `InteractorLogo_Light.json` (light) / `InteractorLogo_Dark.json` (dark)
  - Plays once on load, links to home
- **Center**: AI Assistant input (flex-grow, max-width constrained)
  - Empty: Shows sparkle icon only
  - Has input: Send button appears on right
  - Submit: `Enter` or click Send → Opens AI Copilot right pane
- **Right**: Notifications → Help → Profile → **Quick Create (+)**
  - **Notifications**: Dual badge - normal count + **red error count**
  - **Profile**: Navigates to `/settings` (full page, NOT dropdown)
  - **Quick Create (+)**: Green button, opens Quick Create right panel

### AI Copilot Right Pane (see [navigation.md](./navigation.md))

```
┌─────────────────────┬─────────────────────┬──────────────────┐
│                     │                     │ AI Copilot   [✕] │
│   Left Drawer       │   Main Content      ├──────────────────┤
│   (240px)           │   (shrinks)         │  User message    │
│                     │                     │  AI response...  │
│                     │                     │  [Suggestions]   │
│   Feedback          │                     ├──────────────────┤
│   😞 😟 😐 🙂 😊    │                     │ [Follow-up...  ➤]│
└─────────────────────┴─────────────────────┴──────────────────┘
```

- **Width**: 400-480px (fixed), slides in from right
- **Content shrinks**: Main content area shrinks horizontally when pane opens
- **Keyboard**: `Enter` submit, `Shift+Enter` newline, `Escape` close, `Cmd/Ctrl+K` focus

### Settings Layout (see [settings.md](./settings.md))

```
┌────────────────────┬─────────────────────────────────────────────────────┐
│ Settings      ✕    │  Profile / Preferences / Notifications             │
│                    │                                                     │
│ ACCOUNT            │  Content area with forms, toggles, selectors       │
│   Profile     ←    │                                                     │
│   Preferences      │                                                     │
│   Notifications    │                                                     │
│                    │                                                     │
│ ORGANIZATION       │                                                     │
│   General          │                                                     │
│   ...              │                                                     │
└────────────────────┴─────────────────────────────────────────────────────┘
```

- Split layout: 240px sidebar + main content
- Active item: Green left border (`4px solid #4CD964`)
- Profile icon navigates to `/settings` or `/profile` (full page)

### Drawer Layout (see [drawer.md](./drawer.md))

```
┌─────────────────────┐
│  [+ Create]  🟢     │  ← GREEN Create button (top, fixed)
├─────────────────────┤
│  CHANNELS        ✏️ │  ← Section header
│  📧 All Channels  0 │
│  👤 peter@inter.. 0 │  ← Item with issue
│  ┌─────────────────┐│
│  │ ⚠️ 2 channels.. ││  ← Warning BELOW item (not above!)
│  │ Click to fix  > ││
│  └─────────────────┘│
│  👤 Peter Jung    0 │  ← Next item
├─────────────────────┤
│  📁 WORKSPACES  + … │  ← Section 2: Expandable
│  > DASHBOARDS   + … │    (expand DOWN, hover shows +/…)
│                     │
│    (flex spacer)    │  ← Pushes feedback to bottom
│                     │
├─────────────────────┤
│  Feedback           │  ← Fixed at bottom
│  😞 😟 😐 🙂 😊     │    Click opens comment drawer
└─────────────────────┘
```

- **Five zones**: Create button, Selection items, Expandable sections, Warnings, Feedback
- **Create button**: Must be **GREEN** (`#4CD964`), not orange/blue
- **Warnings**: Always placed **BELOW** the problematic item, not above
- **Feedback**: 5 emoji faces (1-5 rating), fixed at bottom, opens comment drawer
- Drawer width: 240px (open), 56px (collapsed icons only)
