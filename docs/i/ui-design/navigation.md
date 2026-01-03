# Interactor Design System - Navigation Components

Navigation elements including sidebar, header, and breadcrumbs.

---

## Left Navigation Sidebar

### Structure
```html
<aside class="w-64 h-screen bg-white dark:bg-[#1C1C1E] border-r border-[#E5E5EA] dark:border-[#3A3A3C] flex flex-col">
  <!-- Logo (Lottie animation - see logo-branding.md for setup) -->
  <div class="px-4 py-5 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
    <a href="/" class="flex items-center">
      <lottie-player
        src="/images/logo/InteractorLogo_DarkMode.json"
        background="transparent"
        speed="1"
        style="width: 120px; height: 30px;"
        autoplay
      >
      </lottie-player>
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
    <a href="/" class="flex items-center">
      <lottie-player
        src="/images/logo/InteractorLogo_DarkMode.json"
        background="transparent"
        speed="1"
        style="width: 120px; height: 30px;"
        autoplay
      >
      </lottie-player>
    </a>
  </div>

  <!-- Center: Project selector -->
  <button class="flex items-center gap-2 px-4 py-2 text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] rounded-lg transition-colors">
    <span class="font-medium">Interactor_project01</span>
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

## Breadcrumb Navigation
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

---

## User Dropdown Menu
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

---

## Notification Panel
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

---

## Sidebar Feedback Section

Include a "How are you feeling today?" feedback section at the bottom of the sidebar with 5 emoji satisfaction options.

```html
<!-- Feedback section (bottom of sidebar) -->
<div class="px-4 py-4 border-t border-[#E5E5EA] dark:border-[#3A3A3C]">
  <p class="text-sm text-[#8E8E93] mb-3 text-center">How are you feeling today?</p>
  <div class="flex justify-center gap-2">
    <!-- Very Unsatisfied -->
    <button class="p-2 hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] rounded-lg transition-colors" title="Very Unsatisfied">
      <span class="text-xl">😠</span>
    </button>
    <!-- Unsatisfied -->
    <button class="p-2 hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] rounded-lg transition-colors" title="Unsatisfied">
      <span class="text-xl">😕</span>
    </button>
    <!-- Neutral -->
    <button class="p-2 hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] rounded-lg transition-colors" title="Neutral">
      <span class="text-xl">😐</span>
    </button>
    <!-- Satisfied -->
    <button class="p-2 hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] rounded-lg transition-colors" title="Satisfied">
      <span class="text-xl">🙂</span>
    </button>
    <!-- Very Satisfied -->
    <button class="p-2 hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] rounded-lg transition-colors" title="Very Satisfied">
      <span class="text-xl">😄</span>
    </button>
  </div>
</div>
```

### Feedback Specifications

| Element | Specification |
|---------|---------------|
| Position | Bottom of sidebar, above any fixed footer |
| Emoji Count | 5 options (Very Unsatisfied → Very Satisfied) |
| Emoji Size | `text-xl` |
| Button Padding | `p-2` |
| Gap | `gap-2` |

---

## Error/Warning Banners

Display warnings and error messages in the sidebar. Show once per issue type (no duplicates).

```html
<!-- Warning banner in sidebar -->
<div class="mx-4 mb-4 p-3 bg-[#FFF3CD] dark:bg-[#FFF3CD]/10 border border-[#FFCA2C] rounded-xl" role="alert">
  <div class="flex items-start gap-2">
    <svg class="w-5 h-5 text-[#FFCA2C] shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
    </svg>
    <div class="flex-1">
      <p class="text-sm text-[#856404] dark:text-[#FFCA2C]">Your subscription expires in 3 days</p>
    </div>
    <button class="text-[#856404] dark:text-[#FFCA2C] hover:opacity-70" aria-label="Dismiss">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
      </svg>
    </button>
  </div>
</div>

<!-- Error banner in sidebar -->
<div class="mx-4 mb-4 p-3 bg-[#F8D7DA] dark:bg-[#F8D7DA]/10 border border-[#F5C2C7] rounded-xl" role="alert">
  <div class="flex items-start gap-2">
    <svg class="w-5 h-5 text-[#DC3545] shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
    </svg>
    <div class="flex-1">
      <p class="text-sm text-[#842029] dark:text-[#F5C2C7]">Connection to server failed</p>
    </div>
    <button class="text-[#842029] dark:text-[#F5C2C7] hover:opacity-70" aria-label="Dismiss">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
      </svg>
    </button>
  </div>
</div>
```

### Banner Guidelines

| Rule | Description |
|------|-------------|
| Display Location | Inside sidebar, typically near top or before navigation |
| Duplicates | Show each warning type only ONCE |
| Accessibility | Use `role="alert"` for screen readers |
| Dismissal | Include close button with `aria-label="Dismiss"` |
| Persistence | Store dismissed state in localStorage or user preferences |
