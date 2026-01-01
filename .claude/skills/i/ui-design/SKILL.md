---
name: ui-design
description: Enforces consistent UI/UX patterns based on the AutoFlow design system. Use this skill when creating or modifying UI components to ensure visual consistency across all applications.
allowed-tools: [Read, Grep, Glob, Edit, MultiEdit, Write]
---

# UI Design Skill - AutoFlow Design System

**Reference Design**: `/Users/peterjung/Downloads/20220502_autoflow_dashboard_new/`

This design system ensures all applications built with product-dev-template look and feel exactly like the AutoFlow dashboard. Every component, spacing, and interaction must match these specifications.

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

## Color System

### Primary Colors
```css
/* Primary Brand Green */
--color-primary: #4CD964;           /* Main green - buttons, accents, active states */
--color-primary-hover: #3DBF55;     /* Darker green for hover states */
--color-primary-light: #E8F8EB;     /* Light green for backgrounds, badges */

/* Exact hex values from design */
--autoflow-green: #4CD964;          /* Primary action green */
--autoflow-green-dark: #3DBF55;     /* Hover state */
```

### Secondary Colors
```css
/* Secondary Palette */
--color-secondary-gray: #8E8E93;    /* Muted text, icons */
--color-secondary-orange: #FF9500;  /* Warning, highlights */
--color-navy: #2C3E50;              /* Dark accents, method badges */
--color-navy-dark: #1A252F;         /* Darker navy variant */
```

### Light Mode Colors
```css
/* Light Theme */
--bg-primary: #FFFFFF;              /* Main background */
--bg-secondary: #F5F5F7;            /* Secondary background, inputs */
--bg-tertiary: #E5E5EA;             /* Disabled states, dividers */
--text-primary: #1C1C1E;            /* Main text */
--text-secondary: #8E8E93;          /* Muted text, labels */
--text-tertiary: #AEAEB2;           /* Placeholder text */
--border-color: #E5E5EA;            /* Default borders */
--border-focus: #4CD964;            /* Focus state borders */
```

### Dark Mode Colors
```css
/* Dark Theme */
--bg-primary-dark: #1C1C1E;         /* Main background */
--bg-secondary-dark: #2C2C2E;       /* Secondary background, cards */
--bg-tertiary-dark: #3A3A3C;        /* Elevated surfaces */
--text-primary-dark: #FFFFFF;       /* Main text */
--text-secondary-dark: #8E8E93;     /* Muted text */
--text-tertiary-dark: #636366;      /* Placeholder text */
--border-color-dark: #3A3A3C;       /* Default borders */
--border-focus-dark: #4CD964;       /* Focus state borders (same green) */
```

### Tailwind Configuration
```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        'autoflow': {
          'green': '#4CD964',
          'green-hover': '#3DBF55',
          'green-light': '#E8F8EB',
          'navy': '#2C3E50',
          'navy-dark': '#1A252F',
        },
        'surface': {
          'light': '#FFFFFF',
          'light-secondary': '#F5F5F7',
          'dark': '#1C1C1E',
          'dark-secondary': '#2C2C2E',
        }
      }
    }
  }
}
```

### Tailwind Dark Mode Classes
```html
<!-- Backgrounds -->
bg-white dark:bg-[#1C1C1E]
bg-[#F5F5F7] dark:bg-[#2C2C2E]

<!-- Text -->
text-[#1C1C1E] dark:text-white
text-[#8E8E93] dark:text-[#8E8E93]

<!-- Borders -->
border-[#E5E5EA] dark:border-[#3A3A3C]

<!-- Primary Green (same in both modes) -->
bg-[#4CD964] hover:bg-[#3DBF55] text-white
border-[#4CD964] text-[#4CD964]
```

---

## Button Styles

### Primary Button (Filled Green)
```html
<!-- Full-width primary button (login, register, main CTA) -->
<button class="w-full px-6 py-3 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-semibold rounded-full transition-colors duration-200">
  Login
</button>

<!-- Standard primary button -->
<button class="inline-flex items-center gap-2 px-5 py-2.5 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium rounded-full transition-colors duration-200">
  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
  </svg>
  Add
</button>
```

### Primary Button with Dropdown
```html
<button class="inline-flex items-center gap-2 px-5 py-2.5 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium rounded-full transition-colors duration-200">
  Add
  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
  </svg>
</button>
```

### Secondary Button (Outlined)
```html
<!-- Outlined button -->
<button class="inline-flex items-center justify-center px-5 py-2.5 bg-transparent border-2 border-[#4CD964] text-[#4CD964] font-medium rounded-full hover:bg-[#4CD964] hover:text-white transition-colors duration-200">
  Activate
</button>

<!-- Outlined with subtle background -->
<button class="inline-flex items-center justify-center px-4 py-2 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] text-[#1C1C1E] dark:text-white font-medium rounded-full hover:border-[#4CD964] transition-colors duration-200">
  All
</button>
```

### Icon Buttons
```html
<!-- Icon-only button (toolbar) -->
<button class="p-2 text-[#8E8E93] hover:text-[#4CD964] hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] rounded-lg transition-colors duration-200">
  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
  </svg>
</button>

<!-- Circular icon button (floating action) -->
<button class="w-12 h-12 flex items-center justify-center bg-[#4CD964] hover:bg-[#3DBF55] text-white rounded-full shadow-lg transition-colors duration-200">
  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
  </svg>
</button>
```

### Category/Filter Pills
```html
<!-- Category pill group -->
<div class="flex flex-wrap gap-2">
  <!-- Active pill -->
  <button class="px-4 py-1.5 bg-[#4CD964] text-white text-sm font-medium rounded-full">
    All
  </button>
  <!-- Inactive pill -->
  <button class="px-4 py-1.5 bg-transparent border border-[#4CD964] text-[#4CD964] text-sm font-medium rounded-full hover:bg-[#4CD964] hover:text-white transition-colors">
    Array
  </button>
  <button class="px-4 py-1.5 bg-transparent border border-[#4CD964] text-[#4CD964] text-sm font-medium rounded-full hover:bg-[#4CD964] hover:text-white transition-colors">
    Communication
  </button>
</div>
```

### Button Specifications
| Property | Value |
|----------|-------|
| Border Radius | `rounded-full` (9999px - pill shape) |
| Padding (standard) | `px-5 py-2.5` |
| Padding (large) | `px-6 py-3` |
| Font Weight | `font-medium` or `font-semibold` |
| Transition | `transition-colors duration-200` |

---

## Form Elements

### Text Input (Floating Label Style)
```html
<!-- Input with floating label -->
<div class="relative">
  <input
    type="text"
    id="email"
    class="peer w-full px-4 py-3 bg-[#F5F5F7] dark:bg-[#2C2C2E] border border-transparent focus:border-[#4CD964] rounded-full text-[#1C1C1E] dark:text-white placeholder-transparent focus:outline-none focus:ring-0 transition-colors"
    placeholder="Username or Email"
  />
  <label
    for="email"
    class="absolute left-4 -top-2.5 px-1 text-xs font-medium text-[#4CD964] bg-white dark:bg-[#1C1C1E] transition-all peer-placeholder-shown:text-base peer-placeholder-shown:text-[#8E8E93] peer-placeholder-shown:top-3 peer-placeholder-shown:bg-transparent peer-focus:-top-2.5 peer-focus:text-xs peer-focus:text-[#4CD964] peer-focus:bg-white dark:peer-focus:bg-[#1C1C1E]"
  >
    Username or Email
  </label>
</div>
```

### Standard Input (Simple)
```html
<input
  type="text"
  class="w-full px-4 py-3 bg-[#F5F5F7] dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] focus:border-[#4CD964] rounded-full text-[#1C1C1E] dark:text-white placeholder-[#8E8E93] focus:outline-none focus:ring-0 transition-colors"
  placeholder="Enter your email"
/>
```

### Search Input
```html
<div class="relative">
  <input
    type="text"
    class="w-full pl-10 pr-4 py-2.5 bg-[#F5F5F7] dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] focus:border-[#4CD964] rounded-full text-[#1C1C1E] dark:text-white placeholder-[#8E8E93] focus:outline-none"
    placeholder="Search..."
  />
  <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-[#8E8E93]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
  </svg>
</div>
```

### Checkbox
```html
<label class="inline-flex items-center gap-3 cursor-pointer">
  <input
    type="checkbox"
    class="w-5 h-5 rounded border-[#E5E5EA] dark:border-[#3A3A3C] text-[#4CD964] focus:ring-[#4CD964] focus:ring-offset-0 bg-white dark:bg-[#2C2C2E]"
  />
  <span class="text-sm text-[#8E8E93]">Remember Me</span>
</label>
```

### Toggle Switch
```html
<!-- Toggle switch -->
<label class="relative inline-flex items-center cursor-pointer">
  <input type="checkbox" class="sr-only peer" />
  <div class="w-11 h-6 bg-[#E5E5EA] dark:bg-[#3A3A3C] peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-[#4CD964]"></div>
  <span class="ml-3 text-sm text-[#8E8E93]">Dark theme</span>
</label>
```

### Form Input Specifications
| Property | Value |
|----------|-------|
| Border Radius | `rounded-full` (pill shape) |
| Padding | `px-4 py-3` |
| Background (light) | `#F5F5F7` |
| Background (dark) | `#2C2C2E` |
| Focus Border | `#4CD964` (green) |
| Placeholder Color | `#8E8E93` |

---

## Left Navigation Sidebar

### Structure
```html
<aside class="w-64 h-screen bg-white dark:bg-[#1C1C1E] border-r border-[#E5E5EA] dark:border-[#3A3A3C] flex flex-col">
  <!-- Logo -->
  <div class="px-4 py-5 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
    <a href="/" class="flex items-center gap-2">
      <svg class="w-8 h-8 text-[#4CD964]"><!-- Logo icon --></svg>
      <span class="text-xl font-bold text-[#4CD964]">AutoFlow</span>
    </a>
  </div>

  <!-- Navigation -->
  <nav class="flex-1 overflow-y-auto py-4">
    <!-- Top-level item -->
    <a href="#" class="flex items-center gap-3 px-4 py-3 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] transition-colors">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"/>
      </svg>
      <span class="font-medium">Solution</span>
    </a>

    <!-- Section header -->
    <div class="px-4 py-2 mt-4">
      <span class="text-xs font-semibold uppercase tracking-wider text-[#8E8E93]">Manage Services</span>
    </div>

    <!-- Active nav item with green indicator -->
    <a href="#" class="relative flex items-center gap-3 px-4 py-3 text-[#4CD964] bg-[#E8F8EB] dark:bg-[#4CD964]/10">
      <!-- Green left border indicator -->
      <span class="absolute left-0 top-2 bottom-2 w-1 bg-[#4CD964] rounded-r-full"></span>
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2"/>
      </svg>
      <span class="font-medium">Servers</span>
    </a>

    <!-- Regular nav item -->
    <a href="#" class="flex items-center gap-3 px-4 py-3 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] transition-colors">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
      </svg>
      <span class="font-medium">Timers</span>
    </a>

    <!-- Expandable section with sub-items -->
    <div class="mt-4">
      <button class="w-full flex items-center justify-between px-4 py-2">
        <span class="text-xs font-semibold uppercase tracking-wider text-[#8E8E93]">Custom Actions</span>
        <svg class="w-4 h-4 text-[#8E8E93]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
        </svg>
      </button>

      <!-- Sub-item with count -->
      <a href="#" class="flex items-center justify-between px-4 py-2 pl-12 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white">
        <span>In Progress</span>
        <span class="text-sm">8</span>
      </a>
      <a href="#" class="flex items-center justify-between px-4 py-2 pl-12 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white">
        <span>Pending</span>
        <span class="text-sm">4</span>
      </a>
      <a href="#" class="flex items-center justify-between px-4 py-2 pl-12 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white">
        <span>Completed</span>
        <span class="text-sm">12</span>
      </a>
    </div>
  </nav>

  <!-- Upgrade CTA (bottom of sidebar) -->
  <div class="p-4 m-4 bg-[#F5F5F7] dark:bg-[#2C2C2E] rounded-2xl">
    <div class="w-12 h-12 mb-3 mx-auto flex items-center justify-center bg-[#4CD964] rounded-full">
      <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
      </svg>
    </div>
    <p class="text-center text-sm text-[#8E8E93] mb-3">Upgrade to <strong class="text-[#1C1C1E] dark:text-white">Pro</strong> for more resources</p>
    <button class="w-full px-4 py-2.5 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium rounded-full transition-colors">
      Upgrade
    </button>
  </div>
</aside>
```

### Navigation Specifications
| Element | Specification |
|---------|---------------|
| Sidebar Width | `w-64` (256px) |
| Active Indicator | 4px green bar on left side |
| Icon Size | `w-5 h-5` (20px) |
| Section Headers | Uppercase, `text-xs`, `tracking-wider`, gray |
| Item Padding | `px-4 py-3` |
| Sub-item Indent | `pl-12` |

---

## Flow Diagram Components

### Server Node
```html
<!-- Server/Entry node with method badge -->
<div class="relative inline-flex">
  <!-- Main node -->
  <div class="flex items-center gap-3 px-4 py-3 bg-white dark:bg-[#2C2C2E] border-2 border-[#4CD964] rounded-lg min-w-[180px]">
    <svg class="w-6 h-6 text-[#4CD964]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2"/>
    </svg>
    <div>
      <div class="font-semibold text-[#1C1C1E] dark:text-white">Server</div>
      <div class="text-sm text-[#8E8E93]">port: 1111</div>
    </div>
  </div>

  <!-- Method badge (attached to right) -->
  <div class="absolute -right-8 top-1/2 -translate-y-1/2 px-2 py-6 bg-[#2C3E50] text-white text-xs font-bold uppercase tracking-wide rounded-r-lg" style="writing-mode: vertical-lr; text-orientation: mixed;">
    ANY
  </div>

  <!-- Connection point (right side) -->
  <div class="absolute -right-12 top-1/2 -translate-y-1/2 w-3 h-3 bg-white border-2 border-[#4CD964] rounded-full"></div>
</div>
```

### Action Node
```html
<!-- Standard action node -->
<div class="relative inline-flex items-center">
  <!-- Connection point (left) -->
  <div class="absolute -left-1.5 top-1/2 -translate-y-1/2 w-3 h-3 bg-white border-2 border-[#4CD964] rounded-full"></div>

  <!-- Node body -->
  <div class="px-6 py-3 bg-white dark:bg-[#2C2C2E] border-2 border-[#4CD964] rounded-lg min-w-[120px] text-center">
    <span class="font-medium text-[#1C1C1E] dark:text-white">Get Data</span>
  </div>

  <!-- Connection point (right) -->
  <div class="absolute -right-1.5 top-1/2 -translate-y-1/2 w-3 h-3 bg-white border-2 border-[#4CD964] rounded-full"></div>
</div>
```

### Path Node (with Path Badge)
```html
<!-- Node with attached path badge -->
<div class="relative inline-flex">
  <!-- Method badge (left side) -->
  <div class="px-2 py-6 bg-[#4CD964] text-white text-xs font-bold uppercase tracking-wide rounded-l-lg" style="writing-mode: vertical-lr; text-orientation: mixed;">
    ANY
  </div>

  <!-- Main node -->
  <div class="flex flex-col justify-center px-4 py-3 bg-white dark:bg-[#2C2C2E] border-2 border-l-0 border-[#4CD964] rounded-r-lg min-w-[140px]">
    <div class="font-semibold text-[#1C1C1E] dark:text-white">Example</div>
    <div class="text-sm text-[#8E8E93]">path/</div>
  </div>

  <!-- Connection point -->
  <div class="absolute -right-1.5 top-1/2 -translate-y-1/2 w-3 h-3 bg-white border-2 border-[#4CD964] rounded-full"></div>
</div>
```

### Connection Lines
```html
<!-- Connector line (horizontal) -->
<div class="h-0.5 bg-[#8E8E93] dark:bg-[#636366]"></div>

<!-- Connector with arrow -->
<div class="flex items-center">
  <div class="flex-1 h-0.5 bg-[#8E8E93] dark:bg-[#636366]"></div>
  <svg class="w-3 h-3 text-[#8E8E93] dark:text-[#636366] -ml-1" fill="currentColor" viewBox="0 0 24 24">
    <path d="M10 17l5-5-5-5v10z"/>
  </svg>
</div>

<!-- Curved connector (use SVG path) -->
<svg class="absolute" width="100" height="100">
  <path
    d="M 0,50 Q 50,50 50,100"
    fill="none"
    stroke="#8E8E93"
    stroke-width="2"
    stroke-linecap="round"
  />
  <!-- Green endpoint circle -->
  <circle cx="50" cy="100" r="6" fill="#4CD964"/>
  <circle cx="50" cy="100" r="3" fill="white"/>
</svg>
```

### Flow Endpoint Markers
```html
<!-- Arrow/Chevron -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <path d="M9 18l6-6-6-6"/>
</svg>

<!-- Triangle (outline) -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <path d="M12 5l7 14H5z"/>
</svg>

<!-- Triangle (filled) -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="currentColor">
  <path d="M12 5l7 14H5z"/>
</svg>

<!-- Circle (outline) -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <circle cx="12" cy="12" r="6"/>
</svg>

<!-- Circle (filled) -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="currentColor">
  <circle cx="12" cy="12" r="6"/>
</svg>

<!-- Diamond (outline) -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <path d="M12 2l8 10-8 10-8-10z"/>
</svg>

<!-- Diamond (filled) -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="currentColor">
  <path d="M12 2l8 10-8 10-8-10z"/>
</svg>

<!-- Dash/Line -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <path d="M5 12h14"/>
</svg>
```

### Connection Point (Port)
```html
<!-- Connection port circle -->
<div class="w-3 h-3 bg-white border-2 border-[#4CD964] rounded-full"></div>

<!-- Active/highlighted connection port -->
<div class="w-4 h-4 bg-[#4CD964] rounded-full flex items-center justify-center">
  <div class="w-2 h-2 bg-white rounded-full"></div>
</div>
```

---

## Modal/Dialog Styles

### Standard Modal
```html
<!-- Modal backdrop -->
<div class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
  <!-- Modal container -->
  <div class="relative w-full max-w-md mx-4 bg-white dark:bg-[#2C2C2E] rounded-2xl shadow-2xl">
    <!-- Close button -->
    <button class="absolute top-4 right-4 p-1 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white rounded-full hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
      </svg>
    </button>

    <!-- Modal content -->
    <div class="p-6 pt-12 text-center">
      <!-- Avatar/Icon -->
      <div class="w-20 h-20 mx-auto mb-4 rounded-full overflow-hidden border-4 border-white dark:border-[#3A3A3C] shadow-lg">
        <img src="avatar.jpg" alt="User" class="w-full h-full object-cover"/>
      </div>

      <!-- Title -->
      <h3 class="text-xl font-bold text-[#1C1C1E] dark:text-white mb-1">Linh Nguyen (Deer)</h3>
      <p class="text-sm text-[#8E8E93] mb-6">linhnguyen@gmail.com</p>

      <!-- Actions list -->
      <div class="space-y-2 mb-6">
        <button class="w-full flex items-center justify-between px-4 py-3 text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] rounded-xl transition-colors">
          <div class="flex items-center gap-3">
            <svg class="w-5 h-5 text-[#8E8E93]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
            </svg>
            <span>Edit Profile</span>
          </div>
          <svg class="w-5 h-5 text-[#8E8E93]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
          </svg>
        </button>

        <button class="w-full flex items-center justify-between px-4 py-3 text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] rounded-xl transition-colors">
          <div class="flex items-center gap-3">
            <svg class="w-5 h-5 text-[#8E8E93]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
            </svg>
            <span>Change Password</span>
          </div>
          <svg class="w-5 h-5 text-[#8E8E93]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
          </svg>
        </button>
      </div>

      <!-- Primary action button -->
      <button class="w-full px-6 py-3 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-semibold rounded-full transition-colors">
        Update Profile
      </button>
    </div>
  </div>
</div>
```

### Dropdown/Autocomplete Modal
```html
<!-- Input with dropdown -->
<div class="relative">
  <div class="bg-white dark:bg-[#2C2C2E] rounded-2xl shadow-xl border border-[#E5E5EA] dark:border-[#3A3A3C] overflow-hidden">
    <!-- Header -->
    <div class="px-4 py-3 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
      <h4 class="font-semibold text-[#1C1C1E] dark:text-white">Name</h4>
    </div>

    <!-- Search input -->
    <div class="px-4 py-3 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
      <div class="relative">
        <input
          type="text"
          class="w-full px-3 py-2 bg-[#F5F5F7] dark:bg-[#3A3A3C] border-0 rounded-lg text-[#1C1C1E] dark:text-white focus:outline-none focus:ring-2 focus:ring-[#4CD964]"
          placeholder="Search..."
        />
        <button class="absolute right-2 top-1/2 -translate-y-1/2 text-[#8E8E93]">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
          </svg>
        </button>
      </div>
    </div>

    <!-- Options list -->
    <div class="max-h-48 overflow-y-auto">
      <button class="w-full px-4 py-3 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
        I love you 3000
      </button>
      <button class="w-full px-4 py-3 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
        Test1
      </button>
      <button class="w-full px-4 py-3 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
        Check Connector Update
      </button>
    </div>
  </div>
</div>
```

### Modal Specifications
| Property | Value |
|----------|-------|
| Border Radius | `rounded-2xl` (16px) |
| Shadow | `shadow-2xl` |
| Max Width | `max-w-md` (28rem) |
| Padding | `p-6` |
| Backdrop | `bg-black/50` |

---

## Dropdown Menus

### Context Menu
```html
<!-- Dropdown menu -->
<div class="absolute right-0 mt-2 w-48 bg-white dark:bg-[#2C2C2E] rounded-xl shadow-xl border border-[#E5E5EA] dark:border-[#3A3A3C] overflow-hidden z-50">
  <button class="w-full px-4 py-2.5 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
    Show version history
  </button>
  <button class="w-full px-4 py-2.5 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
    Export
  </button>
  <button class="w-full px-4 py-2.5 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
    Duplicate
  </button>
  <button class="w-full px-4 py-2.5 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
    Rename
  </button>
  <div class="border-t border-[#E5E5EA] dark:border-[#3A3A3C]"></div>
  <button class="w-full px-4 py-2.5 text-left text-red-500 hover:bg-red-50 dark:hover:bg-red-500/10 transition-colors">
    Delete
  </button>
</div>
```

### Add Button Dropdown
```html
<!-- Dropdown from Add button -->
<div class="relative">
  <button class="inline-flex items-center gap-2 px-5 py-2.5 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium rounded-full transition-colors">
    Add
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
    </svg>
  </button>

  <!-- Dropdown -->
  <div class="absolute top-full left-0 mt-2 w-56 bg-white dark:bg-[#2C2C2E] rounded-xl shadow-xl border border-[#E5E5EA] dark:border-[#3A3A3C] overflow-hidden">
    <button class="w-full px-4 py-3 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
      HTTP Server
    </button>
    <button class="w-full px-4 py-3 text-left text-[#4CD964] hover:bg-[#E8F8EB] dark:hover:bg-[#4CD964]/10 transition-colors font-medium">
      HTTP Server Endpoint
    </button>
    <button class="w-full px-4 py-3 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
      Timer
    </button>
  </div>
</div>
```

---

## Settings Panel / Properties Panel

### Right Sidebar Panel
```html
<aside class="w-80 h-full bg-white dark:bg-[#1C1C1E] border-l border-[#E5E5EA] dark:border-[#3A3A3C] flex flex-col">
  <!-- Header with hamburger -->
  <div class="px-4 py-3 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
    <button class="p-2 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white">
      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
      </svg>
    </button>
  </div>

  <!-- Tab navigation -->
  <div class="px-4 py-3 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
    <div class="flex gap-6">
      <button class="text-[#4CD964] font-medium border-b-2 border-[#4CD964] pb-2">
        Actions
      </button>
      <button class="text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white pb-2">
        Settings
      </button>
    </div>
  </div>

  <!-- Search -->
  <div class="px-4 py-3">
    <div class="relative">
      <input
        type="text"
        class="w-full pl-4 pr-10 py-2.5 bg-[#F5F5F7] dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] rounded-full text-[#1C1C1E] dark:text-white placeholder-[#8E8E93] focus:outline-none focus:border-[#4CD964]"
        placeholder="Server"
      />
      <button class="absolute right-3 top-1/2 -translate-y-1/2 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
        </svg>
      </button>
    </div>
  </div>

  <!-- Results list -->
  <div class="flex-1 overflow-y-auto px-4">
    <div class="py-3 border-b border-[#E5E5EA] dark:border-[#3A3A3C] flex items-center justify-between">
      <span class="text-[#1C1C1E] dark:text-white">I love you 3000</span>
      <svg class="w-5 h-5 text-[#4CD964]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
      </svg>
    </div>
    <div class="py-3 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
      <span class="text-[#1C1C1E] dark:text-white">I love you 3000</span>
    </div>
  </div>

  <!-- Bottom tabs -->
  <div class="px-4 py-3 border-t border-[#E5E5EA] dark:border-[#3A3A3C]">
    <div class="flex gap-6">
      <button class="text-[#4CD964] font-medium border-b-2 border-[#4CD964] pb-2">
        Env
      </button>
      <button class="text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white pb-2">
        Logs
      </button>
    </div>
  </div>

  <!-- Environment variables -->
  <div class="px-4 py-3">
    <label class="block text-sm text-[#8E8E93] mb-2">Name:</label>
    <span class="text-[#1C1C1E] dark:text-white">New Environment variable name</span>
  </div>
</aside>
```

---

## Settings Form Panel

### Properties Form
```html
<div class="bg-white dark:bg-[#1C1C1E] rounded-t-2xl border border-[#E5E5EA] dark:border-[#3A3A3C]">
  <!-- Header -->
  <div class="px-4 py-3 flex items-center justify-between border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
    <h3 class="text-[#4CD964] font-semibold">Settings</h3>
    <button class="p-1 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"/>
      </svg>
    </button>
  </div>

  <!-- Section title -->
  <div class="px-4 py-3">
    <h4 class="text-sm font-medium text-[#1C1C1E] dark:text-white">HTTP Server</h4>
  </div>

  <!-- Form fields -->
  <div class="px-4 space-y-4 pb-4">
    <!-- Text field -->
    <div class="flex items-center">
      <label class="w-24 text-sm text-[#8E8E93]">Name</label>
      <input
        type="text"
        class="flex-1 px-3 py-2 bg-[#F5F5F7] dark:bg-[#2C2C2E] border-0 rounded-lg text-[#1C1C1E] dark:text-white focus:outline-none focus:ring-2 focus:ring-[#4CD964]"
        value="HTTP Server for ORDS"
      />
    </div>

    <div class="flex items-center">
      <label class="w-24 text-sm text-[#8E8E93]">Port</label>
      <input
        type="text"
        class="flex-1 px-3 py-2 bg-[#F5F5F7] dark:bg-[#2C2C2E] border-0 rounded-lg text-[#1C1C1E] dark:text-white focus:outline-none focus:ring-2 focus:ring-[#4CD964]"
      />
    </div>

    <!-- Section header -->
    <div class="pt-4">
      <h4 class="text-sm font-medium text-[#1C1C1E] dark:text-white">Properties</h4>
    </div>

    <!-- Property with type badge -->
    <div class="flex items-center">
      <label class="w-24 text-sm text-[#8E8E93]">host:</label>
      <span class="px-2 py-0.5 bg-[#4CD964] text-white text-xs font-medium rounded mr-2">S</span>
      <input
        type="text"
        class="flex-1 px-3 py-2 bg-[#F5F5F7] dark:bg-[#2C2C2E] border-0 rounded-lg text-[#1C1C1E] dark:text-white text-sm focus:outline-none focus:ring-2 focus:ring-[#4CD964]"
        value="https://example.com"
      />
    </div>

    <!-- Checkbox field -->
    <div class="flex items-center">
      <label class="w-24 text-sm text-[#8E8E93]">use-mock:</label>
      <input
        type="checkbox"
        checked
        class="w-5 h-5 rounded border-[#E5E5EA] text-[#4CD964] focus:ring-[#4CD964]"
      />
    </div>
  </div>
</div>
```

---

## Toolbar

### Main Toolbar
```html
<div class="flex items-center gap-2 px-4 py-2 bg-white dark:bg-[#1C1C1E] border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
  <!-- Add button with dropdown -->
  <button class="inline-flex items-center gap-2 px-5 py-2.5 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium rounded-full transition-colors">
    Add
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
    </svg>
  </button>

  <!-- Icon buttons -->
  <button class="p-2 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] rounded-lg transition-colors">
    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
    </svg>
  </button>

  <button class="p-2 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] rounded-lg transition-colors">
    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 7v8a2 2 0 002 2h6M8 7V5a2 2 0 012-2h4.586a1 1 0 01.707.293l4.414 4.414a1 1 0 01.293.707V15a2 2 0 01-2 2h-2M8 7H6a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2v-2"/>
    </svg>
  </button>

  <!-- Divider -->
  <div class="w-px h-6 bg-[#E5E5EA] dark:bg-[#3A3A3C] mx-2"></div>

  <!-- Dev mode toggle -->
  <span class="text-sm text-[#8E8E93]">Dev mode</span>
  <label class="relative inline-flex items-center cursor-pointer">
    <input type="checkbox" class="sr-only peer" checked />
    <div class="w-11 h-6 bg-[#E5E5EA] dark:bg-[#3A3A3C] rounded-full peer peer-checked:bg-[#4CD964] after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:after:translate-x-full"></div>
  </label>

  <!-- Divider -->
  <div class="w-px h-6 bg-[#E5E5EA] dark:bg-[#3A3A3C] mx-2"></div>

  <!-- Zoom controls -->
  <button class="p-2 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white">
    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"/>
    </svg>
  </button>
  <span class="text-sm text-[#8E8E93] min-w-[50px] text-center">100%</span>
  <button class="p-2 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white">
    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
    </svg>
  </button>

  <!-- Fullscreen -->
  <button class="p-2 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white">
    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"/>
    </svg>
  </button>
</div>
```

---

## Header/Top Bar

### Main Header
```html
<header class="flex items-center justify-between px-4 py-3 bg-white dark:bg-[#1C1C1E] border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
  <!-- Left: Hamburger + Logo -->
  <div class="flex items-center gap-4">
    <button class="p-2 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white lg:hidden">
      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
      </svg>
    </button>
    <a href="/" class="flex items-center gap-2">
      <svg class="w-8 h-8 text-[#4CD964]"><!-- Logo SVG --></svg>
      <span class="text-xl font-bold text-[#4CD964]">AutoFlow</span>
    </a>
  </div>

  <!-- Center: Project selector -->
  <button class="flex items-center gap-2 px-4 py-2 text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] rounded-lg transition-colors">
    <span class="font-medium">Autoflow_project01</span>
    <svg class="w-4 h-4 text-[#8E8E93]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
    </svg>
  </button>

  <!-- Right: Settings + User -->
  <div class="flex items-center gap-3">
    <button class="p-2 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] rounded-lg transition-colors">
      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
      </svg>
    </button>

    <!-- Notification badge -->
    <button class="relative p-2 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white">
      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
      </svg>
      <span class="absolute top-1 right-1 w-4 h-4 bg-[#4CD964] text-white text-xs font-bold rounded-full flex items-center justify-center">1</span>
    </button>

    <!-- User avatar -->
    <button class="w-10 h-10 rounded-full overflow-hidden border-2 border-[#E5E5EA] dark:border-[#3A3A3C]">
      <img src="avatar.jpg" alt="User" class="w-full h-full object-cover"/>
    </button>
  </div>
</header>
```

---

## Authentication Pages

### Sign In Page
```html
<div class="min-h-screen flex">
  <!-- Left: Form -->
  <div class="flex-1 flex flex-col justify-center px-8 lg:px-16 bg-white dark:bg-[#1C1C1E]">
    <!-- Logo -->
    <div class="mb-12">
      <a href="/" class="flex items-center gap-2">
        <svg class="w-8 h-8 text-[#4CD964]"><!-- Logo --></svg>
        <span class="text-xl font-bold text-[#4CD964]">AutoFlow</span>
      </a>
    </div>

    <!-- Form -->
    <div class="max-w-md">
      <h1 class="text-3xl font-bold text-[#1C1C1E] dark:text-white mb-2">Let's Sign You In</h1>
      <p class="text-[#8E8E93] mb-8">
        Don't have an account?
        <a href="/signup" class="text-[#4CD964] hover:underline font-medium">Sign up</a>
      </p>

      <form class="space-y-5">
        <!-- Email input with floating label -->
        <div class="relative">
          <input
            type="email"
            id="email"
            class="peer w-full px-4 py-3.5 bg-[#F5F5F7] dark:bg-[#2C2C2E] border border-transparent focus:border-[#4CD964] rounded-full text-[#1C1C1E] dark:text-white placeholder-transparent focus:outline-none"
            placeholder="Email"
          />
          <label
            for="email"
            class="absolute left-4 -top-2.5 px-1 text-xs font-medium text-[#4CD964] bg-white dark:bg-[#1C1C1E] transition-all peer-placeholder-shown:text-base peer-placeholder-shown:text-[#8E8E93] peer-placeholder-shown:top-3.5 peer-placeholder-shown:bg-transparent peer-focus:-top-2.5 peer-focus:text-xs peer-focus:text-[#4CD964] peer-focus:bg-white dark:peer-focus:bg-[#1C1C1E]"
          >
            Username or Email
          </label>
        </div>

        <!-- Password input -->
        <div class="relative">
          <input
            type="password"
            id="password"
            class="w-full px-4 py-3.5 bg-[#F5F5F7] dark:bg-[#2C2C2E] border border-transparent focus:border-[#4CD964] rounded-full text-[#1C1C1E] dark:text-white placeholder-[#8E8E93] focus:outline-none"
            placeholder="Password"
          />
        </div>

        <!-- Remember me & Forgot password -->
        <div class="flex items-center justify-between">
          <label class="inline-flex items-center gap-2 cursor-pointer">
            <input type="checkbox" class="w-4 h-4 rounded border-[#E5E5EA] text-[#4CD964] focus:ring-[#4CD964]"/>
            <span class="text-sm text-[#8E8E93]">Remember Me</span>
          </label>
          <a href="/forgot-password" class="text-sm text-[#4CD964] hover:underline font-medium">Forgot Password</a>
        </div>

        <!-- Submit button -->
        <button type="submit" class="w-full px-6 py-3.5 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-semibold rounded-full transition-colors">
          Login
        </button>

        <!-- Divider -->
        <div class="flex items-center gap-4">
          <div class="flex-1 h-px bg-[#E5E5EA] dark:bg-[#3A3A3C]"></div>
          <span class="text-sm text-[#8E8E93]">OR</span>
          <div class="flex-1 h-px bg-[#E5E5EA] dark:bg-[#3A3A3C]"></div>
        </div>

        <!-- Social login -->
        <div class="flex gap-3">
          <button type="button" class="flex-1 flex items-center justify-center gap-2 px-4 py-3 bg-[#F5F5F7] dark:bg-[#2C2C2E] rounded-full hover:bg-[#E5E5EA] dark:hover:bg-[#3A3A3C] transition-colors">
            <svg class="w-5 h-5" viewBox="0 0 24 24"><!-- Google icon --></svg>
            <span class="text-[#1C1C1E] dark:text-white font-medium">Continue with Google</span>
          </button>
          <button type="button" class="p-3 bg-[#F5F5F7] dark:bg-[#2C2C2E] rounded-full hover:bg-[#E5E5EA] dark:hover:bg-[#3A3A3C] transition-colors">
            <svg class="w-5 h-5 text-[#1877F2]" viewBox="0 0 24 24"><!-- Facebook icon --></svg>
          </button>
        </div>
      </form>

      <!-- Dark mode toggle -->
      <div class="mt-8 flex items-center gap-3">
        <svg class="w-5 h-5 text-[#8E8E93]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"/>
        </svg>
        <span class="text-sm text-[#8E8E93]">Dark theme</span>
        <label class="relative inline-flex items-center cursor-pointer">
          <input type="checkbox" class="sr-only peer"/>
          <div class="w-11 h-6 bg-[#E5E5EA] rounded-full peer peer-checked:bg-[#4CD964] after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:after:translate-x-full"></div>
        </label>
      </div>
    </div>
  </div>

  <!-- Right: Illustration -->
  <div class="hidden lg:flex flex-1 bg-gradient-to-br from-[#E8F8EB] to-[#C8E6C9] dark:from-[#2C2C2E] dark:to-[#1C1C1E] items-center justify-center p-8">
    <img src="illustration.png" alt="Illustration" class="max-w-full max-h-full object-contain"/>
  </div>
</div>
```

---

## Icon System

### Icon Style Guidelines
- **Style**: Outlined/stroke icons (not filled)
- **Stroke Width**: `1.5` for normal, `2` for emphasis
- **Size**: `w-5 h-5` (20px) for navigation, `w-6 h-6` (24px) for headers
- **Color**: `text-[#8E8E93]` default, `text-[#4CD964]` active, `text-[#1C1C1E]` dark:text-white hover

### Common Icons Reference
```html
<!-- Solution/Grid -->
<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"/>
</svg>

<!-- Server -->
<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2m-2-4h.01M17 16h.01"/>
</svg>

<!-- Timer/Clock -->
<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
</svg>

<!-- Connections -->
<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1"/>
</svg>

<!-- Files/Folder -->
<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"/>
</svg>

<!-- Schema/Table -->
<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 10h18M3 14h18m-9-4v8m-7 0h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"/>
</svg>

<!-- Flows -->
<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01"/>
</svg>

<!-- Delete/Trash -->
<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
</svg>

<!-- Copy/Duplicate -->
<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 7v8a2 2 0 002 2h6M8 7V5a2 2 0 012-2h4.586a1 1 0 01.707.293l4.414 4.414a1 1 0 01.293.707V15a2 2 0 01-2 2h-2M8 7H6a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2v-2"/>
</svg>

<!-- Settings/Gear -->
<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
</svg>
```

---

## Spacing System

### Standard Spacing Scale
```
gap-1   → 4px    (tight inline elements)
gap-2   → 8px    (icon + text, compact lists)
gap-3   → 12px   (form elements, buttons)
gap-4   → 16px   (section content, cards)
gap-5   → 20px   (panel padding)
gap-6   → 24px   (section separations)
gap-8   → 32px   (major sections)
```

### Component Padding
| Component | Padding |
|-----------|---------|
| Buttons (small) | `px-4 py-2` |
| Buttons (standard) | `px-5 py-2.5` |
| Buttons (large) | `px-6 py-3` or `px-6 py-3.5` |
| Input fields | `px-4 py-3` or `px-4 py-3.5` |
| Cards | `p-4` or `p-6` |
| Modal | `p-6` |
| Sidebar items | `px-4 py-3` |
| List items | `px-4 py-2.5` or `px-4 py-3` |

### Border Radius Scale
| Element | Radius |
|---------|--------|
| Buttons | `rounded-full` (pill) |
| Inputs | `rounded-full` (pill) |
| Cards | `rounded-2xl` (16px) |
| Modals | `rounded-2xl` (16px) |
| Dropdown menus | `rounded-xl` (12px) |
| Small badges | `rounded-full` |
| Icon buttons | `rounded-lg` (8px) |

---

## Checklist Before Completing UI Work

### Design System Compliance
- [ ] Uses AutoFlow green (`#4CD964`) as primary accent color
- [ ] Buttons are pill-shaped (`rounded-full`)
- [ ] Inputs are pill-shaped (`rounded-full`)
- [ ] Dark mode uses correct background colors (`#1C1C1E`, `#2C2C2E`)
- [ ] Icons use outlined/stroke style with `stroke-width="1.5"`

### Component Verification
- [ ] Left navigation has green indicator bar for active item
- [ ] Forms use floating labels where appropriate
- [ ] Toggle switches use green when active
- [ ] Modals have `rounded-2xl` corners and shadow
- [ ] Dropdowns have `rounded-xl` corners

### Flow Diagram Elements (if applicable)
- [ ] Nodes have green borders
- [ ] Method badges use navy/green background
- [ ] Connection points are green circles with white center
- [ ] Lines use gray color with rounded corners

### Dark Mode Verification
- [ ] Toggle system theme and verify all components update
- [ ] Text remains readable in both modes
- [ ] Borders use correct dark colors (`#3A3A3C`)
- [ ] Green accent color stays consistent in both modes

### Responsive Design
- [ ] Sidebar collapses on mobile
- [ ] Touch targets are minimum 44px
- [ ] No horizontal overflow at any viewport

---

## Additional Components

### Confirmation Dialog with Cancel/OK Buttons
```html
<!-- Confirmation dialog -->
<div class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
  <div class="w-full max-w-md mx-4 bg-white dark:bg-[#2C2C2E] rounded-2xl shadow-2xl p-6">
    <h3 class="text-xl font-bold text-[#1C1C1E] dark:text-white mb-4">Select Server</h3>

    <!-- Dropdown selector -->
    <div class="relative mb-6">
      <button class="w-full flex items-center justify-between px-4 py-3 bg-[#F5F5F7] dark:bg-[#3A3A3C] rounded-lg text-left">
        <div class="flex items-center gap-3">
          <svg class="w-5 h-5 text-[#4CD964]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2"/>
          </svg>
          <span class="text-[#4CD964] font-medium">Server</span>
        </div>
        <svg class="w-5 h-5 text-[#8E8E93]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
        </svg>
      </button>
    </div>

    <!-- Action buttons -->
    <div class="flex gap-3">
      <button class="flex-1 px-6 py-3 bg-[#F5F5F7] dark:bg-[#3A3A3C] text-[#1C1C1E] dark:text-white font-medium rounded-full hover:bg-[#E5E5EA] dark:hover:bg-[#4A4A4C] transition-colors">
        Cancel
      </button>
      <button class="flex-1 px-6 py-3 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-semibold rounded-full transition-colors">
        OK
      </button>
    </div>
  </div>
</div>
```

### User Dropdown Menu
```html
<!-- User avatar with dropdown -->
<div class="relative">
  <button class="w-10 h-10 rounded-full overflow-hidden border-2 border-[#E5E5EA] dark:border-[#3A3A3C]">
    <img src="avatar.jpg" alt="User" class="w-full h-full object-cover"/>
  </button>

  <!-- Dropdown menu -->
  <div class="absolute right-0 top-full mt-2 w-56 bg-white dark:bg-[#2C2C2E] rounded-xl shadow-xl border border-[#E5E5EA] dark:border-[#3A3A3C] overflow-hidden z-50">
    <!-- User email -->
    <div class="px-4 py-3 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
      <span class="text-sm text-[#1C1C1E] dark:text-white">peter@interactor.com</span>
    </div>

    <!-- Menu items -->
    <button class="w-full px-4 py-2.5 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
      Plugins
    </button>
    <button class="w-full px-4 py-2.5 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
      Settings
    </button>
    <div class="border-t border-[#E5E5EA] dark:border-[#3A3A3C]"></div>
    <button class="w-full px-4 py-2.5 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
      Logout
    </button>
  </div>
</div>
```

### Notification Panel
```html
<!-- Notification bell with badge -->
<div class="relative">
  <button class="relative p-2 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white">
    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
    </svg>
    <span class="absolute top-1 right-1 w-4 h-4 bg-[#4CD964] text-white text-xs font-bold rounded-full flex items-center justify-center">1</span>
  </button>

  <!-- Notification dropdown -->
  <div class="absolute right-0 top-full mt-2 w-72 bg-white dark:bg-[#2C2C2E] rounded-xl shadow-xl border border-[#E5E5EA] dark:border-[#3A3A3C] overflow-hidden z-50">
    <div class="px-4 py-3 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
      <span class="font-semibold text-[#1C1C1E] dark:text-white">Notifications</span>
    </div>
    <div class="px-4 py-8 text-center text-[#8E8E93]">
      You don't have any notifications
    </div>
  </div>
</div>
```

### Breadcrumb Navigation
```html
<!-- Breadcrumb -->
<nav class="flex items-center gap-2 text-sm">
  <a href="#" class="text-[#8E8E93] hover:text-[#4CD964] transition-colors">flows</a>
  <svg class="w-4 h-4 text-[#8E8E93]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
  </svg>
  <span class="text-[#1C1C1E] dark:text-white font-medium">API File List</span>
</nav>
```

### Conditional Flow Node (If/Else)
```html
<!-- Conditional node with branches -->
<div class="relative inline-block">
  <!-- Main conditional container -->
  <div class="bg-white dark:bg-[#2C2C2E] border-2 border-[#4CD964] rounded-lg p-4 min-w-[280px]">
    <!-- Header with icon -->
    <div class="flex items-center gap-3 mb-4">
      <svg class="w-6 h-6 text-[#4CD964]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 9l4-4 4 4m0 6l-4 4-4-4"/>
      </svg>
      <span class="font-semibold text-[#1C1C1E] dark:text-white">If user exists</span>
    </div>

    <!-- True branch -->
    <div class="flex items-center gap-3 mb-3">
      <span class="text-sm text-[#8E8E93] w-10">True</span>
      <div class="flex-1 flex items-center">
        <div class="px-4 py-2 bg-[#E8F8EB] dark:bg-[#4CD964]/10 border border-[#4CD964] rounded-lg text-sm text-[#4CD964]">
          get user data
        </div>
        <div class="w-8 h-0.5 bg-[#8E8E93]"></div>
        <div class="w-3 h-3 bg-[#4CD964] rounded-full flex items-center justify-center">
          <div class="w-1.5 h-1.5 bg-white rounded-full"></div>
        </div>
      </div>
    </div>

    <!-- Else branch -->
    <div class="flex items-center gap-3">
      <span class="text-sm text-[#8E8E93] w-10">Else</span>
      <div class="flex-1 flex items-center">
        <div class="px-4 py-2 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] rounded-lg text-sm text-[#1C1C1E] dark:text-white">
          error data/log
        </div>
        <div class="w-8 h-0.5 bg-[#8E8E93]"></div>
        <div class="w-3 h-3 bg-[#4CD964] rounded-full flex items-center justify-center">
          <div class="w-1.5 h-1.5 bg-white rounded-full"></div>
        </div>
      </div>
    </div>
  </div>
</div>
```

### Grouped Flow Container (Switch/Router)
```html
<!-- Switch/Router container with multiple branches -->
<div class="bg-white dark:bg-[#2C2C2E] border-2 border-[#4CD964] rounded-lg p-4">
  <!-- Header with dropdown -->
  <div class="flex items-center justify-between mb-4 pb-3 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
    <div class="flex items-center gap-2">
      <span class="font-semibold text-[#1C1C1E] dark:text-white">APP ID</span>
      <svg class="w-4 h-4 text-[#8E8E93]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
      </svg>
    </div>
    <button class="w-6 h-6 flex items-center justify-center text-[#4CD964] border border-[#4CD964] rounded-full hover:bg-[#4CD964] hover:text-white transition-colors">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
      </svg>
    </button>
  </div>

  <!-- Branch rows -->
  <div class="space-y-3">
    <!-- Row with label and action chain -->
    <div class="flex items-center gap-4">
      <span class="text-sm text-[#1C1C1E] dark:text-white w-24">Google Drive</span>
      <div class="flex items-center gap-2">
        <div class="px-3 py-1.5 bg-[#E8F8EB] border border-[#4CD964] rounded text-xs text-[#4CD964]">DRIVEID EXISTS?</div>
        <div class="w-4 h-0.5 bg-[#8E8E93]"></div>
        <div class="px-3 py-1.5 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] rounded text-xs">FIELDS EXISTS?</div>
        <div class="w-4 h-0.5 bg-[#8E8E93]"></div>
        <div class="px-3 py-1.5 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] rounded text-xs">SORT EXISTS?</div>
        <div class="w-4 h-0.5 bg-[#8E8E93]"></div>
        <div class="px-3 py-1.5 bg-[#4CD964] text-white rounded text-xs">drive.files.list</div>
      </div>
    </div>

    <div class="flex items-center gap-4">
      <span class="text-sm text-[#1C1C1E] dark:text-white w-24">OneDrive</span>
      <div class="flex items-center gap-2">
        <div class="px-3 py-1.5 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] rounded text-xs">data/set</div>
        <div class="w-4 h-0.5 bg-[#8E8E93]"></div>
        <div class="px-3 py-1.5 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] rounded text-xs">FIELD EXISTS?</div>
      </div>
    </div>

    <div class="flex items-center gap-4">
      <span class="text-sm text-[#1C1C1E] dark:text-white w-24">Default</span>
      <div class="flex items-center gap-2">
        <div class="px-3 py-1.5 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] rounded text-xs">JUST SOME LOGIC</div>
      </div>
    </div>
  </div>
</div>
```

### Autocomplete/Combobox Input
```html
<!-- Autocomplete input with suggestions -->
<div class="relative">
  <div class="bg-white dark:bg-[#2C2C2E] rounded-2xl shadow-xl border border-[#E5E5EA] dark:border-[#3A3A3C] overflow-hidden">
    <!-- Header -->
    <div class="px-4 py-3 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
      <h4 class="font-semibold text-[#1C1C1E] dark:text-white">Name</h4>
    </div>

    <!-- Input field -->
    <div class="px-4 py-3 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
      <div class="relative">
        <input
          type="text"
          value="Letters"
          class="w-full px-3 py-2 bg-[#F5F5F7] dark:bg-[#3A3A3C] border border-[#4CD964] rounded-lg text-[#1C1C1E] dark:text-white focus:outline-none"
        />
        <button class="absolute right-2 top-1/2 -translate-y-1/2 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
          </svg>
        </button>
      </div>
    </div>

    <!-- Suggestions list -->
    <div class="max-h-48 overflow-y-auto">
      <button class="w-full px-4 py-3 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
        I love you 3000
      </button>
      <button class="w-full px-4 py-3 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
        Test1
      </button>
      <button class="w-full px-4 py-3 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
        a
      </button>
      <button class="w-full px-4 py-3 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
        Test
      </button>
      <button class="w-full px-4 py-3 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
        Check Connector Update
      </button>
    </div>
  </div>
</div>
```

---

## Reference Images

All design specifications are derived from:
`/Users/peterjung/Downloads/20220502_autoflow_dashboard_new/`

Key reference files:
- `buttons.png` - Button styles and states
- `color.png` - Color palette
- `menus.png` - Menu and icon styles
- `icons.png` - Icon system
- `left_menu_light.png` / `left_menu_dark.png` - Navigation sidebar
- `flows.png` / `flows-1.png` - Flow connector lines
- `End Points.png` / `End Points-1.png` - Endpoint markers
- `dashboard01.png` - `dashboard05.png` - Dashboard layouts
- `autoflow_board.png` - `autoflow_board-37.png` - Application screens
- `autoflow_Sign In_1.png` - Authentication pages
- `my_profile01.png` - Modal dialogs
