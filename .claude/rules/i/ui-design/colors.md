# AutoFlow Design System - Color System

This file defines the complete color palette for the AutoFlow design system.

---

## Primary Colors
```css
/* Primary Brand Green */
--color-primary: #4CD964;           /* Main green - buttons, accents, active states */
--color-primary-hover: #3DBF55;     /* Darker green for hover states */
--color-primary-light: #E8F8EB;     /* Light green for backgrounds, badges */

/* Exact hex values from design */
--autoflow-green: #4CD964;          /* Primary action green */
--autoflow-green-dark: #3DBF55;     /* Hover state */
```

## Secondary Colors
```css
/* Secondary Palette */
--color-secondary-gray: #8E8E93;    /* Muted text, icons */
--color-secondary-orange: #FF9500;  /* Warning, highlights */
--color-navy: #2C3E50;              /* Dark accents, method badges */
--color-navy-dark: #1A252F;         /* Darker navy variant */
```

## Light Mode Colors
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

## Dark Mode Colors
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

## Tailwind Configuration
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

## Tailwind Dark Mode Classes
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

## Quick Reference

| Color | Hex | Usage |
|-------|-----|-------|
| Primary Green | `#4CD964` | Buttons, active states, accents |
| Green Hover | `#3DBF55` | Hover states |
| Green Light | `#E8F8EB` | Light backgrounds, badges |
| Navy | `#2C3E50` | Method badges, dark accents |
| Gray | `#8E8E93` | Muted text, icons |
| Light BG | `#FFFFFF` | Main background (light) |
| Light Secondary | `#F5F5F7` | Input backgrounds (light) |
| Dark BG | `#1C1C1E` | Main background (dark) |
| Dark Secondary | `#2C2C2E` | Card backgrounds (dark) |
| Border Light | `#E5E5EA` | Borders (light mode) |
| Border Dark | `#3A3A3C` | Borders (dark mode) |
