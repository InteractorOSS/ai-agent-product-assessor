---
name: ui-design
description: Enforces consistent UI/UX patterns (stylish, fancy, simple) when creating or modifying UI components. Use this skill when implementing any visual changes to ensure design consistency across all applications.
allowed-tools: [Read, Grep, Glob, Edit, MultiEdit, Write]
---

# UI Design Skill

Universal design system for consistent look and feel across all applications.

## When to Use This Skill

Apply this skill when:
- Creating new pages, views, or components
- Modifying existing UI/UX elements
- Implementing forms, tables, dashboards, or layouts
- Working on any front-end template
- **Making ANY desktop UI changes** (must verify/update mobile responsiveness)
- Fixing or improving mobile/responsive layouts
- Adjusting typography, spacing, or grid layouts

## Core Design Philosophy

**Style Keywords**: **Stylish • Fancy • Simple**

Every design decision should embody these three principles:
- **Stylish** - Modern, polished, and visually appealing with elegant details
- **Fancy** - Premium feel with refined gradients, subtle animations, and sophisticated touches
- **Simple** - Clean layouts, clear hierarchy, uncluttered interfaces - complexity in execution, simplicity in presentation

**AVOID EXCESSIVE CARDS**. The default tendency is to wrap everything in cards. Instead:
- Use **flowing layouts** with clear visual hierarchy
- Reserve cards only for **truly distinct, comparable items** (data records, selectable options)
- Prefer **grid layouts with inline content** over card containers
- Use **background colors and spacing** to create visual separation, not card borders

---

## Required Global Components

### Light/Dark Mode (System-Aware)

**MANDATORY**: All applications must support light and dark mode that automatically adjusts based on system settings.

#### Implementation
```html
<!-- HTML: Add dark class support -->
<html class="..." x-data :class="{ 'dark': $store.darkMode.on }">

<!-- Tailwind Config: Enable dark mode -->
<!-- tailwind.config.js -->
module.exports = {
  darkMode: 'class', // or 'media' for pure system preference
  // ...
}
```

#### CSS Variable Approach (Recommended)
```css
/* Light mode (default) */
:root {
  --bg-primary: theme('colors.white');
  --bg-secondary: theme('colors.gray.50');
  --text-primary: theme('colors.gray.900');
  --text-secondary: theme('colors.gray.600');
  --border-color: theme('colors.gray.200');
}

/* Dark mode */
.dark {
  --bg-primary: theme('colors.gray.900');
  --bg-secondary: theme('colors.gray.800');
  --text-primary: theme('colors.gray.100');
  --text-secondary: theme('colors.gray.400');
  --border-color: theme('colors.gray.700');
}
```

#### Tailwind Dark Mode Classes
```html
<!-- Background -->
bg-white dark:bg-gray-900
bg-gray-50 dark:bg-gray-800

<!-- Text -->
text-gray-900 dark:text-gray-100
text-gray-600 dark:text-gray-400
text-gray-500 dark:text-gray-500

<!-- Borders -->
border-gray-200 dark:border-gray-700
border-gray-300 dark:border-gray-600

<!-- Cards/Panels -->
bg-white dark:bg-gray-800 border-gray-200 dark:border-gray-700

<!-- Inputs -->
bg-white dark:bg-gray-800 border-gray-300 dark:border-gray-600 text-gray-900 dark:text-gray-100

<!-- Buttons (Primary - stays consistent) -->
bg-indigo-600 hover:bg-indigo-700 text-white

<!-- Buttons (Secondary) -->
bg-white dark:bg-gray-800 border-gray-200 dark:border-gray-700 text-gray-800 dark:text-gray-200
```

#### System Preference Detection (JavaScript/Alpine)
```javascript
// Alpine.js store for dark mode
document.addEventListener('alpine:init', () => {
  Alpine.store('darkMode', {
    on: window.matchMedia('(prefers-color-scheme: dark)').matches,

    init() {
      // Listen for system changes
      window.matchMedia('(prefers-color-scheme: dark)')
        .addEventListener('change', e => this.on = e.matches);
    },

    toggle() {
      this.on = !this.on;
    }
  });
});
```

#### LiveView/Phoenix Implementation
```elixir
# In app.js
const darkModeMediaQuery = window.matchMedia('(prefers-color-scheme: dark)');

function updateDarkMode(e) {
  document.documentElement.classList.toggle('dark', e.matches);
}

darkModeMediaQuery.addEventListener('change', updateDarkMode);
updateDarkMode(darkModeMediaQuery);
```

---

### AI Assistant Chat Widget

**MANDATORY**: All applications must include an AI assistant chat widget positioned in the bottom-right corner.

#### Position & Layout
```html
<!-- Fixed position, bottom-right -->
<div class="fixed bottom-6 right-6 z-50">
  <!-- Chat toggle button -->
  <button
    class="w-14 h-14 bg-indigo-600 hover:bg-indigo-700 dark:bg-indigo-500 dark:hover:bg-indigo-600 rounded-full shadow-lg hover:shadow-xl transition-all duration-200 flex items-center justify-center text-white"
    @click="chatOpen = !chatOpen"
  >
    <!-- Chat icon when closed -->
    <svg x-show="!chatOpen" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
    </svg>
    <!-- Close icon when open -->
    <svg x-show="chatOpen" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
    </svg>
  </button>

  <!-- Chat panel -->
  <div
    x-show="chatOpen"
    x-transition:enter="transition ease-out duration-200"
    x-transition:enter-start="opacity-0 translate-y-4"
    x-transition:enter-end="opacity-100 translate-y-0"
    x-transition:leave="transition ease-in duration-150"
    x-transition:leave-start="opacity-100 translate-y-0"
    x-transition:leave-end="opacity-0 translate-y-4"
    class="absolute bottom-20 right-0 w-80 sm:w-96 h-[500px] bg-white dark:bg-gray-800 rounded-2xl shadow-2xl border border-gray-200 dark:border-gray-700 flex flex-col overflow-hidden"
  >
    <!-- Header -->
    <div class="px-4 py-3 bg-indigo-600 dark:bg-indigo-700 text-white flex items-center gap-3">
      <div class="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center">
        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
          <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"/>
        </svg>
      </div>
      <div>
        <h3 class="font-semibold text-sm">AI Assistant</h3>
        <p class="text-xs text-white/70">Ask me anything</p>
      </div>
    </div>

    <!-- Messages area -->
    <div class="flex-1 overflow-y-auto p-4 space-y-4">
      <!-- Message bubbles go here -->
    </div>

    <!-- Input area -->
    <div class="p-4 border-t border-gray-200 dark:border-gray-700">
      <div class="flex gap-2">
        <input
          type="text"
          placeholder="Type a message..."
          class="flex-1 px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-xl bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
        />
        <button class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl transition-colors">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
          </svg>
        </button>
      </div>
    </div>
  </div>
</div>
```

#### Mobile Responsiveness
```html
<!-- Mobile: Full width panel -->
<div class="
  absolute bottom-20 right-0
  w-80 sm:w-96
  h-[500px]
  max-h-[calc(100vh-120px)]
  ...
">
```

#### Message Bubble Styles
```html
<!-- User message (right-aligned) -->
<div class="flex justify-end">
  <div class="max-w-[80%] px-4 py-2 bg-indigo-600 text-white rounded-2xl rounded-br-md">
    User message here
  </div>
</div>

<!-- AI message (left-aligned) -->
<div class="flex justify-start">
  <div class="max-w-[80%] px-4 py-2 bg-gray-100 dark:bg-gray-700 text-gray-900 dark:text-gray-100 rounded-2xl rounded-bl-md">
    AI response here
  </div>
</div>

<!-- Typing indicator -->
<div class="flex justify-start">
  <div class="px-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-2xl rounded-bl-md">
    <div class="flex gap-1">
      <span class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0ms"></span>
      <span class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 150ms"></span>
      <span class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 300ms"></span>
    </div>
  </div>
</div>
```

---

## Color System

### Primary Brand Colors
- **Primary/Indigo**: `indigo-600`, `indigo-700`, `indigo-800`
- **Success/Green**: `green-600`, `green-700`, `green-800`
- **Info/Blue**: `blue-600`, `blue-700`
- **Warning/Amber**: `amber-500`, `amber-600`
- **Danger/Red**: `red-600`, `red-700`
- **Accent/Purple**: `purple-600`, `purple-700`

### Neutral Colors
- **Text Primary**: `gray-900`
- **Text Secondary**: `gray-600`
- **Text Muted**: `gray-500`
- **Borders**: `gray-200`, `gray-300`
- **Background Light**: `gray-50`, `slate-50`
- **Background White**: `white`

### Background Patterns
```html
<!-- Primary backgrounds -->
bg-white
bg-gray-50
bg-slate-50

<!-- Subtle gradients (use sparingly) -->
bg-gradient-to-br from-white via-slate-50 to-indigo-50
bg-gradient-to-br from-slate-50 via-gray-50 to-indigo-50

<!-- Accent/emphasis backgrounds -->
bg-gradient-to-r from-indigo-600 via-indigo-700 to-indigo-800
bg-gradient-to-br from-gray-800 to-gray-900
```

---

## Typography Scale

### Headings
```html
<!-- Page title (H1) -->
text-2xl sm:text-3xl lg:text-4xl font-bold text-gray-900

<!-- Section title (H2) -->
text-xl sm:text-2xl lg:text-3xl font-bold text-gray-900

<!-- Subsection title (H3) -->
text-lg sm:text-xl font-semibold text-gray-900

<!-- Card/item title (H4) -->
text-base sm:text-lg font-semibold text-gray-900
```

### Body Text
```html
<!-- Large body -->
text-lg text-gray-600

<!-- Standard body -->
text-base text-gray-600

<!-- Small body -->
text-sm text-gray-600

<!-- Caption/helper text -->
text-xs text-gray-500
```

### Labels & Badges
```html
<!-- Form labels -->
text-sm font-medium text-gray-700

<!-- Uppercase labels -->
text-xs sm:text-sm font-semibold uppercase tracking-wide text-gray-500

<!-- Status badge -->
text-xs font-semibold uppercase tracking-wide
```

---

## Button Styles

### Primary Button
```html
<button class="inline-flex items-center justify-center px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-xl transition-all duration-200 shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
  Primary Action
</button>
```

### Secondary Button
```html
<button class="inline-flex items-center justify-center px-6 py-3 bg-white hover:bg-gray-50 text-gray-800 font-semibold rounded-xl border-2 border-gray-200 hover:border-gray-300 transition-all duration-200 shadow-sm hover:shadow-md">
  Secondary Action
</button>
```

### Danger Button
```html
<button class="inline-flex items-center justify-center px-6 py-3 bg-red-600 hover:bg-red-700 text-white font-semibold rounded-xl transition-all duration-200 shadow-md hover:shadow-lg">
  Delete
</button>
```

### Ghost/Text Button
```html
<button class="inline-flex items-center justify-center px-4 py-2 text-indigo-600 hover:text-indigo-700 hover:bg-indigo-50 font-medium rounded-lg transition-colors duration-200">
  Text Action
</button>
```

### Button Sizes
```html
<!-- Small -->
px-4 py-2 text-sm rounded-lg

<!-- Medium (default) -->
px-6 py-3 text-base rounded-xl

<!-- Large -->
px-8 py-4 text-lg rounded-xl
```

### Icon Buttons
```html
<!-- Icon only -->
<button class="p-2 sm:p-3 rounded-lg hover:bg-gray-100 transition-colors">
  <svg class="w-5 h-5 text-gray-600">...</svg>
</button>

<!-- Icon + text -->
<button class="inline-flex items-center gap-2 px-4 py-2 ...">
  <svg class="w-5 h-5">...</svg>
  <span>Label</span>
</button>
```

---

## Form Elements

### Text Input
```html
<input type="text" class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors text-gray-900 placeholder-gray-400" placeholder="Enter value..." />
```

### Select
```html
<select class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors text-gray-900 bg-white">
  <option>Option 1</option>
</select>
```

### Textarea
```html
<textarea class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors text-gray-900 placeholder-gray-400 resize-none" rows="4"></textarea>
```

### Checkbox
```html
<label class="inline-flex items-center gap-3 cursor-pointer">
  <input type="checkbox" class="w-5 h-5 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500" />
  <span class="text-sm text-gray-700">Label text</span>
</label>
```

### Form Group
```html
<div class="space-y-2">
  <label class="block text-sm font-medium text-gray-700">Label</label>
  <input type="text" class="w-full px-4 py-3 border border-gray-300 rounded-xl ..." />
  <p class="text-xs text-gray-500">Helper text</p>
</div>
```

---

## Spacing System

### Standard Spacing Scale
```
gap-1   → 4px
gap-2   → 8px
gap-3   → 12px
gap-4   → 16px
gap-6   → 24px
gap-8   → 32px
gap-10  → 40px
gap-12  → 48px
gap-16  → 64px
```

### Container Pattern
```html
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
  <!-- content -->
</div>
```

### Section Spacing
```html
<!-- Standard section padding -->
py-8 sm:py-12 lg:py-16

<!-- Compact section -->
py-6 sm:py-8

<!-- Spacious section -->
py-12 sm:py-16 lg:py-24
```

### Content Spacing
```html
<!-- Between major elements -->
space-y-8 sm:space-y-12

<!-- Between related items -->
space-y-4 sm:space-y-6

<!-- Between tight items -->
space-y-2 sm:space-y-3
```

---

## Layout Patterns

### Card (Use Sparingly)
```html
<div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">
  <!-- content -->
</div>
```

### Panel/Container
```html
<div class="bg-gray-50 rounded-xl p-6 sm:p-8">
  <!-- content -->
</div>
```

### Grid Layouts
```html
<!-- 2 columns -->
grid grid-cols-1 md:grid-cols-2 gap-6

<!-- 3 columns -->
grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6

<!-- 4 columns -->
grid grid-cols-2 md:grid-cols-4 gap-4

<!-- Auto-fit responsive -->
grid grid-cols-[repeat(auto-fit,minmax(280px,1fr))] gap-6
```

### Flex Patterns
```html
<!-- Horizontal with gap -->
flex items-center gap-4

<!-- Space between -->
flex items-center justify-between

<!-- Stack on mobile, row on larger -->
flex flex-col sm:flex-row gap-4
```

---

## Responsive Design System

### Breakpoint Reference
```
sm: 640px   - Small tablets, large phones (landscape)
md: 768px   - Tablets
lg: 1024px  - Small laptops, large tablets
xl: 1280px  - Desktops
2xl: 1536px - Large desktops
```

### Mobile-First Approach
Always start with mobile styles, then add larger breakpoint overrides:
```html
<!-- CORRECT: Mobile-first -->
<div class="text-base sm:text-lg md:text-xl lg:text-2xl">

<!-- WRONG: Desktop-first (avoid) -->
<div class="text-2xl lg:text-2xl md:text-xl sm:text-lg">
```

### Responsive Typography
```html
<!-- Page title -->
text-2xl sm:text-3xl lg:text-4xl

<!-- Section title -->
text-xl sm:text-2xl lg:text-3xl

<!-- Body text -->
text-sm sm:text-base

<!-- Labels -->
text-xs sm:text-sm
```

### Responsive Spacing
```html
<!-- Section padding -->
py-8 sm:py-12 lg:py-16

<!-- Container padding -->
px-4 sm:px-6 lg:px-8

<!-- Gap between items -->
gap-4 sm:gap-6 lg:gap-8
```

### Responsive Visibility
```html
<!-- Hide on mobile, show on larger screens -->
hidden sm:block
hidden md:flex
hidden lg:inline-flex

<!-- Show on mobile only -->
block sm:hidden
flex md:hidden
```

### Touch-Friendly Targets
```html
<!-- Minimum 44px touch target for mobile -->
<button class="min-h-[44px] min-w-[44px] px-4 py-3 sm:py-2">
  Button
</button>
```

---

## Status & Feedback

### Badges
```html
<!-- Success -->
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
  Active
</span>

<!-- Warning -->
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-amber-100 text-amber-800">
  Pending
</span>

<!-- Error -->
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
  Failed
</span>

<!-- Info -->
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
  New
</span>

<!-- Neutral -->
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
  Draft
</span>
```

### Alerts
```html
<!-- Success -->
<div class="p-4 bg-green-50 border border-green-200 rounded-xl text-green-800">
  <p class="text-sm font-medium">Success message</p>
</div>

<!-- Error -->
<div class="p-4 bg-red-50 border border-red-200 rounded-xl text-red-800">
  <p class="text-sm font-medium">Error message</p>
</div>

<!-- Warning -->
<div class="p-4 bg-amber-50 border border-amber-200 rounded-xl text-amber-800">
  <p class="text-sm font-medium">Warning message</p>
</div>

<!-- Info -->
<div class="p-4 bg-blue-50 border border-blue-200 rounded-xl text-blue-800">
  <p class="text-sm font-medium">Info message</p>
</div>
```

---

## Anti-Patterns (AVOID)

### Excessive Cards
```html
<!-- BAD: Card soup -->
<div class="grid grid-cols-3 gap-6">
  <div class="bg-white p-6 rounded-xl shadow border">Item 1</div>
  <div class="bg-white p-6 rounded-xl shadow border">Item 2</div>
  <div class="bg-white p-6 rounded-xl shadow border">Item 3</div>
</div>

<!-- GOOD: Clean grid without card wrappers -->
<div class="grid lg:grid-cols-3 gap-8">
  <div class="text-center">
    <div class="w-12 h-12 bg-indigo-100 rounded-xl flex items-center justify-center mx-auto mb-4">
      <svg>...</svg>
    </div>
    <h3 class="text-lg font-semibold text-gray-900 mb-2">Title</h3>
    <p class="text-gray-600">Description</p>
  </div>
</div>
```

### Common Mobile Issues to Avoid
```html
<!-- AVOID: Fixed widths that break on mobile -->
<div class="w-[500px]">  <!-- BAD -->
<div class="w-full max-w-[500px]">  <!-- GOOD -->

<!-- AVOID: Horizontal overflow -->
<div class="flex gap-8">  <!-- May overflow on mobile -->
<div class="flex flex-wrap gap-4 sm:gap-8">  <!-- GOOD -->

<!-- AVOID: Too-small touch targets -->
<button class="p-1 text-xs">  <!-- BAD: Hard to tap -->
<button class="p-3 sm:p-2 text-sm">  <!-- GOOD -->
```

---

## When Cards ARE Appropriate

Use cards ONLY for:
1. **Data records** - Table alternatives, selectable items
2. **Distinct options** - Pricing, plans, selectable choices
3. **Media content** - Images with captions/metadata
4. **Comparable items** - Where users need to scan and compare

Even then, limit card density and ensure adequate spacing.

---

## Checklist Before Completing UI Work

### Required Global Components
- [ ] **Light/Dark mode implemented** - System preference detection working
- [ ] **AI Assistant chat widget present** - Bottom-right corner, functional
- [ ] Dark mode classes applied to all components (`dark:` variants)

### Visual Design
- [ ] Consistent color usage from the design system
- [ ] Typography follows the scale (no arbitrary sizes)
- [ ] Buttons use standard styles and sizes
- [ ] Forms use standard input styles
- [ ] No excessive card usage

### Responsive/Mobile Design
- [ ] Mobile-first responsive breakpoints applied (sm → md → lg → xl)
- [ ] Typography scales properly across all breakpoints
- [ ] Grid layouts stack appropriately on mobile (grid-cols-1 base)
- [ ] Buttons stack vertically on mobile when needed
- [ ] Touch targets are minimum 44px on mobile
- [ ] No horizontal overflow at any viewport width
- [ ] Spacing reduces proportionally on smaller screens

### Testing Viewports
Verify at these widths:
1. **375px** - Standard mobile
2. **768px** - Tablet
3. **1024px** - Small laptop
4. **1440px** - Desktop

### Quick Mobile Verification
- [ ] Text is readable (not too small or too large)
- [ ] Buttons are tappable (adequate size and spacing)
- [ ] Content doesn't overflow horizontally
- [ ] Layout stacks sensibly on mobile

### Dark Mode Verification
- [ ] Toggle system theme and verify UI updates
- [ ] All text remains readable in both modes
- [ ] Borders and dividers visible in both modes
- [ ] AI chat widget adapts to dark mode
