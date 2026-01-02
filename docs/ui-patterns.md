# UI Patterns Guide

This document describes the UI patterns and components used in Interactor-powered applications.

## Navigation Patterns

### Global Navigation Bar (GNB)

The GNB/header should contain:
- **Left section**: Sidebar toggle, tools menu, Interactor logo
- **Center section**: AI search bar (optional)
- **Right section**: Notifications, Help, Profile

**Important**: Do NOT place Create/action buttons in the GNB. These belong in the sidebar.

### Left Sidebar Navigation

The left sidebar (hamburger menu) should contain:
- **Top**: `+ Create` button (primary action)
- **Quick Access**: Links to main features (Publish, Composer, Calendar, etc.)
- **Channels**: Social account management
- **Settings**: Application settings
- **Bottom**: Feedback section with 5 emoji buttons

Example "+ Create" button structure:
```heex
<div class="p-4">
  <a
    href="/composer"
    class="flex items-center justify-center gap-2 w-full px-4 py-3 bg-primary hover:bg-primary/90 text-primary-content font-semibold rounded-full transition-colors duration-200 shadow-sm"
  >
    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
    </svg>
    + Create
  </a>
</div>
```

### Feedback Section

Include a "How are you feeling today?" section at the bottom of the sidebar with 5 emoji options:
- Very Unsatisfied, Unsatisfied, Neutral, Satisfied, Very Satisfied

## Interactor Logo Animation

### Using DotLottie

The Interactor logo uses `.lottie` files (ZIP-compressed Lottie animations) for dark/light theme support.

**Required package**: `@lottiefiles/dotlottie-web`

```bash
cd assets && npm install @lottiefiles/dotlottie-web
```

**InteractorLogo Hook implementation**:

```javascript
import { DotLottie } from "@lottiefiles/dotlottie-web"

InteractorLogo: {
  mounted() {
    this.dotLottie = null
    this.canvas = null
    this.loadAnimation()

    // Watch for theme changes
    this.observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        if (mutation.attributeName === 'data-theme') {
          this.loadAnimation()
        }
      })
    })
    this.observer.observe(document.documentElement, { attributes: true })
  },

  loadAnimation() {
    if (this.dotLottie) {
      this.dotLottie.destroy()
      this.dotLottie = null
    }

    this.el.innerHTML = ''
    this.canvas = document.createElement('canvas')
    this.canvas.style.width = '100%'
    this.canvas.style.height = '100%'
    this.el.appendChild(this.canvas)

    const theme = document.documentElement.getAttribute('data-theme') || 'light'
    const isThemeAware = this.el.dataset.themeAware === 'true'

    let animationPath = '/images/brand/lottie/InteractorLogo_Light.lottie'
    if (isThemeAware && theme === 'dark') {
      animationPath = '/images/brand/lottie/InteractorLogo_Dark.lottie'
    }

    this.dotLottie = new DotLottie({
      canvas: this.canvas,
      src: animationPath,
      loop: false,
      autoplay: true
    })
  },

  destroyed() {
    if (this.observer) this.observer.disconnect()
    if (this.dotLottie) this.dotLottie.destroy()
  }
}
```

**HTML usage**:
```heex
<div
  id="interactor-logo-nav"
  phx-hook="InteractorLogo"
  data-theme-aware="true"
  class="w-[100px] h-[28px]"
  phx-update="ignore"
>
  <!-- Fallback content if JS doesn't load -->
  <img src="/images/brand/interactor-logo.svg" alt="Interactor" />
</div>
```

### Asset Locations

Place lottie files in: `priv/static/images/brand/lottie/`
- `InteractorLogo_Light.lottie` - For light theme
- `InteractorLogo_Dark.lottie` - For dark theme
- `Interactor_FullLogo_Animation.lottie` - Full logo animation

Source files are available in: `.claude/assets/i/brand/lottie/`

## Page-Level Actions vs Global Actions

- **Global actions** (sidebar): "Create", "Settings", navigation
- **Page actions** (content area): View toggles (List/Calendar), page-specific buttons like "New Post"

Keep contextual actions in the content area, not in global navigation.

## Error/Warning Banners

- Display warnings once in the sidebar (no duplicates)
- Use role="alert" for accessibility
- Include dismissal functionality
