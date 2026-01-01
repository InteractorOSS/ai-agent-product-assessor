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

**IMPORTANT**: Always use the centralized brand assets located in `.claude/assets/brand/`:

```
.claude/assets/brand/
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
├── lottie/                    # Animated logos (JSON, .lottie)
│   ├── InteractorLogo_Light.json  # For light backgrounds
│   ├── InteractorLogo_Dark.json   # For dark backgrounds
│   └── Interactor_FullLogo_Animation.json
├── favicons/                  # Website favicons (full set)
└── powered-by/                # "Powered by Interactor" badges
```

**Note**: Copy required assets from `.claude/assets/brand/` to your app's public/assets directory.

### Usage Examples

**Step 1: Copy assets to your application**
```bash
cp -r .claude/assets/brand public/brand
# Or for bundler imports:
cp -r .claude/assets/brand src/assets/brand
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
│ [≡] [⊞] [🟢][Lottie Logo]    [   Ask AI Assistant...   ]   [🔔] [?] [👤]│
│  ↑    ↑   ↑       ↑                     ↑                    ↑   ↑   ↑   │
│ Toggle Tools Icon Logo              AI Input             Notif Help Prof │
└──────────────────────────────────────────────────────────────────────────┘
```

- **Left**: Sidebar toggle → Tools → Interactor Icon → Lottie Logo
- **Center**: AI Assistant input (flex-grow, max-width constrained)
- **Right**: Notifications → Help → Profile (navigates to full page, NOT dropdown)

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
│  [+ Create]         │  ← Create button (top)
├─────────────────────┤
│  Dashboard          │
│  Analytics          │  ← Primary nav (scrollable)
│  Content            │
│  ...                │
├─────────────────────┤
│  Organization ▾     │  ← Organization selector (bottom)
│  [Avatar] Org Name  │
└─────────────────────┘
```

- Four zones: Create button, Primary nav, Organization selector, User section
- Drawer width: 240px (open), 56px (collapsed icons only)
