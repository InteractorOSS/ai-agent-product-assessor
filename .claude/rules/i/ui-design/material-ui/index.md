# Material UI Design Rules

These rules apply **ONLY** when the project uses Material UI (MUI) as the design system.

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
┌──────────────────────────────────────────────────────────────────────────┐
│ [≡] [⊞] [🟢][Interactor]    [What can I do for you?...]     [🔔] [?] [👤]│
│  ↑    ↑   ↑       ↑                     ↑                    ↑   ↑   ↑   │
│ Toggle Tools Icon AnimatedLogo      AI Input             Notif Help Prof │
└──────────────────────────────────────────────────────────────────────────┘
```

- **Left**: Sidebar toggle → Tools → Interactor Icon → Animated Logo
  - **Icon**: `icon_simple_green_v1.png` (light) / `icon_simple_white_v1.png` (dark)
  - **Logo**: `InteractorLogo_Light.json` (light) / `InteractorLogo_Dark.json` (dark)
- **Center**: AI Assistant input (flex-grow, max-width constrained)
  - Empty: Shows sparkle icon only
  - Has input: Send button appears on right
  - Submit: `Enter` or click Send → Opens AI Copilot right pane
- **Right**: Notifications → Help → Profile (navigates to full page, NOT dropdown)

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
│  [+ Create]         │  ← Create button (top, fixed)
├─────────────────────┤
│  🏠 For you         │  ← Section 1: Selection items
│  🕐 Recent        > │    (dropdowns open RIGHT)
│  ⭐ Starred       > │
├─────────────────────┤
│  📁 WORKSPACES  + … │  ← Section 2: Expandable
│  > DASHBOARDS   + … │    (expand DOWN, hover shows +/…)
│  ⊞ APPS         + … │
│  🔽 FILTERS     + … │
│                     │
│    (flex spacer)    │  ← Pushes feedback to bottom
│                     │
├─────────────────────┤
│  Feedback           │  ← Fixed at bottom
│  😞 😟 😐 🙂 😊     │    Click opens comment drawer
└─────────────────────┘
```

- **Four zones**: Create button (top), Selection items, Expandable sections, Feedback (bottom)
- **Feedback**: 5 emoji faces (1-5 rating), clicking opens bottom drawer for comments
- **Best practice**: Always visible, low-friction, contextual feedback collection
- Drawer width: 240px (open), 56px (collapsed icons only)
