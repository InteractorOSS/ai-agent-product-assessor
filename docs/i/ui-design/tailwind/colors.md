# TailwindCSS Color Mappings - Interactor Design System

This file provides exact color mappings for implementing Interactor UI patterns in TailwindCSS.

---

## Primary Colors

### Interactor Green (Primary Brand Color)

```
┌─────────────────────────────────────────────────────────────┐
│  Interactor Green                                           │
│  #4CD964                                                    │
├─────────────────────────────────────────────────────────────┤
│  RGB: 76, 217, 100                                          │
│  HSL: 131°, 66%, 57%                                        │
│  Used for: Create buttons, active states, primary actions   │
└─────────────────────────────────────────────────────────────┘
```

| State | Hex | TailwindCSS Class |
|-------|-----|-------------------|
| Default | `#4CD964` | `bg-[#4CD964]` |
| Hover | `#3DBF55` | `hover:bg-[#3DBF55]` |
| Light (backgrounds) | `#E8F8EB` | `bg-[#E8F8EB]` |
| Light (10% opacity) | `rgba(76, 217, 100, 0.1)` | `bg-[#4CD964]/10` |

### Error Red

```
┌─────────────────────────────────────────────────────────────┐
│  Error Red                                                  │
│  #FF3B30                                                    │
├─────────────────────────────────────────────────────────────┤
│  RGB: 255, 59, 48                                           │
│  HSL: 3°, 100%, 59%                                         │
│  Used for: Error badges, delete buttons, warnings           │
└─────────────────────────────────────────────────────────────┘
```

| State | Hex | TailwindCSS Class |
|-------|-----|-------------------|
| Default | `#FF3B30` | `bg-[#FF3B30]` |
| Hover | `#E6352B` | `hover:bg-[#E6352B]` |

---

## tailwind.config.js Setup

### Option A: Extend colors (Recommended)

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        // Interactor brand colors
        'interactor': {
          'green': '#4CD964',
          'green-hover': '#3DBF55',
          'green-light': '#E8F8EB',
        },
        // UI feedback colors
        'ui': {
          'error': '#FF3B30',
          'warning': '#FF9500',
          'success': '#4CD964',
          'info': '#007AFF',
        }
      }
    }
  }
}
```

**Usage:**
```html
<button class="bg-interactor-green hover:bg-interactor-green-hover">Create</button>
<span class="bg-ui-error">Error badge</span>
```

### Option B: Replace primary color

If your project uses DaisyUI or a similar theme system:

```javascript
// tailwind.config.js
module.exports = {
  daisyui: {
    themes: [
      {
        interactor: {
          "primary": "#4CD964",
          "primary-focus": "#3DBF55",
          "primary-content": "#FFFFFF",
          "error": "#FF3B30",
          // ... other colors
        }
      }
    ]
  }
}
```

---

## Color Usage by Pattern

### Pattern 2: GREEN Create Button

```html
<!-- ❌ WRONG - Using theme primary (might be blue) -->
<button class="bg-primary">Create</button>

<!-- ✅ CORRECT - Explicit Interactor green -->
<button class="bg-[#4CD964] hover:bg-[#3DBF55]">Create</button>

<!-- ✅ CORRECT - Using tailwind.config.js -->
<button class="bg-interactor-green hover:bg-interactor-green-hover">Create</button>
```

### Pattern 3: Quick Create (+) Button

```html
<!-- ❌ WRONG -->
<button class="bg-blue-500">+</button>

<!-- ✅ CORRECT -->
<button class="bg-[#4CD964] hover:bg-[#3DBF55] rounded-full w-10 h-10">+</button>
```

### Pattern 4: Error Badge

```html
<!-- ❌ WRONG -->
<span class="bg-red-500">2</span>

<!-- ✅ CORRECT -->
<span class="bg-[#FF3B30]">2</span>
```

---

## Dark Mode Colors

### Background Colors

| Element | Light Mode | Dark Mode | Classes |
|---------|------------|-----------|---------|
| Page background | `#FFFFFF` | `#1C1C1E` | `bg-white dark:bg-[#1C1C1E]` |
| Secondary background | `#F5F5F7` | `#2C2C2E` | `bg-[#F5F5F7] dark:bg-[#2C2C2E]` |
| Card/Panel | `#FFFFFF` | `#2C2C2E` | `bg-white dark:bg-[#2C2C2E]` |

### Text Colors

| Element | Light Mode | Dark Mode | Classes |
|---------|------------|-----------|---------|
| Primary text | `#1C1C1E` | `#FFFFFF` | `text-[#1C1C1E] dark:text-white` |
| Secondary text | `#8E8E93` | `#8E8E93` | `text-[#8E8E93]` |
| Muted text | `#AEAEB2` | `#636366` | `text-[#AEAEB2] dark:text-[#636366]` |

### Border Colors

| Element | Light Mode | Dark Mode | Classes |
|---------|------------|-----------|---------|
| Default border | `#E5E5EA` | `#3A3A3C` | `border-[#E5E5EA] dark:border-[#3A3A3C]` |
| Active border | `#4CD964` | `#4CD964` | `border-[#4CD964]` |

---

## Active State Styling

For navigation items with active states:

```html
<!-- Inactive item -->
<div class="flex items-center gap-3 px-4 py-2 text-[#8E8E93] border-l-4 border-transparent">
  <span>📄</span>
  <span>Inactive Item</span>
</div>

<!-- Active item (with green left border) -->
<div class="flex items-center gap-3 px-4 py-2 text-[#4CD964] bg-[#4CD964]/10 border-l-4 border-[#4CD964]">
  <span>📄</span>
  <span class="font-medium">Active Item</span>
</div>
```

---

## Warning/Alert Colors

For Pattern 5 (Warnings BELOW Items):

| Element | Light Mode | Dark Mode | Classes |
|---------|------------|-----------|---------|
| Warning background | `#FFFBEB` | `rgba(245, 158, 11, 0.1)` | `bg-amber-50 dark:bg-amber-900/20` |
| Warning border | `#FDE68A` | `#78350F` | `border-amber-200 dark:border-amber-800` |
| Warning text | `#92400E` | `#FDE68A` | `text-amber-800 dark:text-amber-200` |
| Warning icon | `#F59E0B` | `#F59E0B` | `text-amber-500` |

---

## Quick Reference Table

| Purpose | Hex | TailwindCSS |
|---------|-----|-------------|
| Create button background | `#4CD964` | `bg-[#4CD964]` |
| Create button hover | `#3DBF55` | `hover:bg-[#3DBF55]` |
| Error badge | `#FF3B30` | `bg-[#FF3B30]` |
| Active indicator | `#4CD964` | `border-[#4CD964]` |
| Active background | `#E8F8EB` | `bg-[#4CD964]/10` |
| Inactive text | `#8E8E93` | `text-[#8E8E93]` |
| Warning background | - | `bg-amber-50 dark:bg-amber-900/20` |
