---
name: ui-design
description: Enforces consistent UI/UX patterns based on the Interactor design system. Use this skill when creating or modifying UI components to ensure visual consistency across all applications.
allowed-tools: [Read, Grep, Glob, Edit, MultiEdit, Write]
---

# UI Design Skill - Interactor Design System

**Reference Design**: `/Users/peterjung/Downloads/20220502_Interactor_dashboard_new/`

This design system ensures all applications built with product-dev-template look and feel exactly like the Interactor dashboard. Every component, spacing, and interaction must match these specifications.

---

## When to Use This Skill

Apply this skill when:
- Creating new pages, views, or components
- Modifying existing UI/UX elements
- Implementing forms, tables, dashboards, or layouts
- Working on any front-end template
- **Making ANY desktop UI changes** (must verify/update mobile responsiveness)
- Fixing or improving mobile/responsive layouts
- Building flow diagrams, node editors, or visual builders

---

## Core Design Philosophy

**Style Keywords**: **Clean • Professional • Functional**

Design principles:
- **Green-first accent**: Primary brand color is vibrant green for all interactive elements
- **High contrast**: Clear distinction between light and dark modes
- **Minimal decoration**: Focus on functionality over ornament
- **Consistent rounding**: Pill-shaped buttons and inputs throughout
- **Clear hierarchy**: Section headers, consistent spacing, visual grouping

---

## Design System Rules Reference

The complete design system is split into modular rule files for easy reference:

### Core Styles
- **@colors.md** - Complete color system including primary green (#4CD964), light/dark mode palettes, and Tailwind configuration
- **@buttons.md** - Button styles: primary, secondary, icon buttons, pills, and Cancel/OK patterns
- **@forms.md** - Form elements: floating label inputs, search, checkboxes, toggles, dropdowns
- **@icons-spacing.md** - Icon style guidelines, common icons, spacing system, and border radius scale

### Layout Components
- **@navigation.md** - Left sidebar, header/top bar, breadcrumbs, user dropdown, notifications
- **@panels-toolbar.md** - Right sidebar panels, settings forms, and toolbar components
- **@modals-dropdowns.md** - Modal dialogs, confirmation dialogs, context menus, autocomplete
- **@auth-pages.md** - Sign in, sign up, and forgot password page layouts

### Specialized Components
- **@flow-components.md** - Flow diagram nodes, connection lines, endpoint markers, conditional nodes

### Framework Adapters

**Source of Truth**: All UI patterns are defined in **@material-ui/index.md**. Other adapters provide translation mappings only.

| If your project has... | Use |
|------------------------|-----|
| `@mui/material` in `package.json` | **@material-ui/index.md** (full implementation) |
| `tailwind.config.js` in root | **@material-ui/index.md** + **@tailwind/index.md** (translation) |
| `mix.exs` + Phoenix dependency | **@material-ui/index.md** + **@phoenix/index.md** (translation) |

Available files:
- **@material-ui/index.md** - Source of truth for all UI patterns
- **@tailwind/index.md** - MUI → TailwindCSS class translations
- **@tailwind/colors.md** - TailwindCSS color mappings
- **@phoenix/index.md** - MUI/React → Phoenix/LiveView translations

### Quality Assurance
- **@checklist.md** - Complete design system compliance checklist

---

## Quick Reference

### Primary Colors
| Color | Hex | Usage |
|-------|-----|-------|
| Primary Green | `#4CD964` | Buttons, active states, accents |
| Green Hover | `#3DBF55` | Hover states |
| Green Light | `#E8F8EB` | Light backgrounds, badges |

### Key Tailwind Classes

```html
<!-- Backgrounds -->
bg-white dark:bg-[#1C1C1E]
bg-[#F5F5F7] dark:bg-[#2C2C2E]

<!-- Text -->
text-[#1C1C1E] dark:text-white
text-[#8E8E93]

<!-- Borders -->
border-[#E5E5EA] dark:border-[#3A3A3C]

<!-- Primary Button -->
bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium rounded-full

<!-- Pill Input -->
px-4 py-3 bg-[#F5F5F7] dark:bg-[#2C2C2E] rounded-full focus:border-[#4CD964]
```

### Common Patterns

| Element | Pattern |
|---------|---------|
| Buttons | `rounded-full` (pill shape) |
| Inputs | `rounded-full` (pill shape) |
| Cards/Modals | `rounded-2xl` (16px) |
| Dropdowns | `rounded-xl` (12px) |
| Icon buttons | `rounded-lg` (8px) |
| Icons | Outlined, `stroke-width="1.5"` |
| Active nav | Green left border bar |

---

## Design Tokens Summary

### Spacing Scale
```
gap-2  → 8px   (icon + text)
gap-3  → 12px  (form elements)
gap-4  → 16px  (cards, sections)
gap-6  → 24px  (major sections)
```

### Component Dimensions
| Component | Dimension |
|-----------|-----------|
| Left Sidebar | `w-64` (256px) |
| Right Panel | `w-80` (320px) |
| Icon (nav) | `w-5 h-5` (20px) |
| Icon (header) | `w-6 h-6` (24px) |
| Avatar | `w-10 h-10` (40px) |

---

## ⚠️ CRITICAL - 6 Mandatory UI Patterns

These patterns are **REQUIRED** for ALL Interactor applications. Verify these FIRST:

| # | Pattern | Requirement |
|---|---------|-------------|
| 1 | **Lottie Logo** | AppBar uses `InteractorLogo_Light.json` / `_Dark.json` (NOT static PNG/SVG) |
| 2 | **GREEN Create Button** | Left drawer has `#4CD964` green "+ Create" at top (NOT orange/blue) |
| 3 | **Quick Create (+)** | AppBar right section has green + button → opens Quick Create panel |
| 4 | **Dual Notification Badge** | Notifications has TWO badges: count (primary) + errors (red) |
| 5 | **Warnings BELOW Items** | Warnings appear BELOW the specific problematic item (NOT at top!) |
| 6 | **Feedback Section** | 5 emoji faces (😞😟😐🙂😊) FIXED at bottom of drawer |

**See `@material-ui/index.md` for detailed requirements. For other frameworks, use the translation adapters above.**

---

## Checklist Before Completing UI Work

Before finalizing any UI changes, verify against **@checklist.md**:

1. ✅ **6 Critical Patterns above are correctly implemented**
2. ✅ Uses Interactor green (`#4CD964`) as primary accent
3. ✅ Buttons and inputs are pill-shaped (`rounded-full`)
4. ✅ Dark mode colors are correct
5. ✅ Icons use outlined/stroke style
6. ✅ Left navigation has green indicator bar for active item
7. ✅ Responsive design works on mobile
8. ✅ Flow diagram elements (if applicable) follow node patterns

---

## Reference Images

All design specifications are derived from:
`/Users/peterjung/Downloads/20220502_Interactor_dashboard_new/`

Key reference files:
- `buttons.png` - Button styles and states
- `color.png` - Color palette
- `menus.png` - Menu and icon styles
- `icons.png` - Icon system
- `left_menu_light.png` / `left_menu_dark.png` - Navigation sidebar
- `flows.png` / `flows-1.png` - Flow connector lines
- `End Points.png` / `End Points-1.png` - Endpoint markers
- `dashboard01.png` - `dashboard05.png` - Dashboard layouts
- `Interactor_board.png` - `Interactor_board-37.png` - Application screens
- `Interactor_Sign In_1.png` - Authentication pages
- `my_profile01.png` - Modal dialogs
