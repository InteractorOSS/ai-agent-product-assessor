# Interactor Design System - GNB Components

Implementation guide for Global Navigation Bar (GNB) components. **This is a mandatory specification** - all Interactor applications MUST follow these guidelines exactly.

---

## CRITICAL REQUIREMENTS CHECKLIST

Before considering GNB implementation complete, verify ALL of the following:

| # | Requirement | Validation |
|---|-------------|------------|
| 1 | Logo uses Lottie animation (NOT static image) | Check for `<lottie-player>` or `phx-hook="InteractorLogo"` |
| 2 | AI input placeholder is "What can I do for you?" | Check input placeholder attribute |
| 3 | AI sparkle icon is CLICKABLE and opens right pane | Check for `phx-click={JS.dispatch("phx:toggle-ai-sidebar")}` |
| 4 | Send button is HIDDEN by default | Check for `hidden opacity-0` classes |
| 5 | Send button APPEARS when text is entered | Verify `AIAssistantInput` hook is attached |
| 6 | NO "Create" button in the GNB header | Create button belongs in SIDEBAR only |
| 7 | Profile icon links to `/settings` page | Check `href="/settings"` on profile |
| 8 | GNB is full-width and full-screen layout | Root uses `flex flex-col h-screen` |

---

## GNB Structure Overview

The Interactor GNB consists of three sections:

| Section | Components |
|---------|------------|
| **Left** | Sidebar Toggle, Tools Button, Icon + Animated Logo |
| **Center** | AI Assistant Input Field (with clickable sparkle + conditional send button) |
| **Right** | Notifications (dual-badge), Help, Profile (NO Create button!) |

**IMPORTANT - Create Button Location**:
- The Create button is in the **LEFT SIDEBAR** only, NOT in the GNB header
- This is a deliberate design decision - do NOT add Create to the header

---

## 1. Complete GNB Header Implementation (Reference)

```heex
<header class="sticky top-0 z-50 border-b border-base-300 bg-base-100 shrink-0">
  <div class="flex h-14 items-center px-4">
    <%!-- LEFT SECTION: Sidebar Toggle, Tools, Logo --%>
    <div class="flex items-center gap-1">
      <%!-- Sidebar Toggle Button --%>
      <button
        phx-click={JS.toggle(to: "#left-sidebar") |> JS.toggle(to: "#sidebar-backdrop")}
        class="p-2 text-base-content/60 hover:text-base-content hover:bg-base-200 rounded-lg transition-colors duration-200"
        aria-label="Toggle sidebar"
      >
        <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>

      <%!-- Tools Selection Button --%>
      <button
        class="p-2 text-base-content/60 hover:text-base-content hover:bg-base-200 rounded-lg transition-colors duration-200"
        aria-label="Tools menu"
      >
        <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
        </svg>
      </button>

      <%!-- Interactor Icon + Logo --%>
      <a href="/" class="flex items-center gap-2 ml-2">
        <%!-- Interactor Icon (always visible) --%>
        <img src="/images/brand/icons/icon_simple_green_v1.png" alt="Interactor" class="w-6 h-6" />
        <%!-- Interactor Logo (Lottie animation with hook) --%>
        <div
          id="interactor-logo-header"
          phx-hook="InteractorLogo"
          data-theme-aware="true"
          class="h-8 w-24 hidden sm:block"
        >
          <%!-- Fallback: Static SVG while Lottie loads --%>
          <img src="/images/brand/logos/20221116_interactor_BI_text_green.svg" alt="Interactor" class="h-full w-auto" />
        </div>
      </a>
    </div>

    <%!-- CENTER SECTION: AI Assistant Input Field --%>
    <div class="flex-1 flex justify-center mx-4">
      <div class="relative w-full max-w-xl">
        <input
          type="text"
          name="ai_query"
          id="ai-assistant-input"
          placeholder="What can I do for you?"
          autocomplete="off"
          class="peer w-full pl-10 pr-12 py-2.5 bg-base-200 border border-base-300 focus:border-primary rounded-full text-base-content placeholder-base-content/50 focus:outline-none focus:ring-2 focus:ring-primary/20 transition-colors duration-200"
          phx-hook="AIAssistantInput"
        />
        <%!-- Sparkle/AutoAwesome icon (left) - MUST BE CLICKABLE to open AI sidebar --%>
        <button
          type="button"
          class="absolute left-2 top-1/2 -translate-y-1/2 p-1 text-primary/70 hover:text-primary hover:bg-primary/10 rounded-full transition-colors duration-200"
          phx-click={JS.dispatch("phx:toggle-ai-sidebar")}
          aria-label="Open AI Assistant"
        >
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
            <path d="M19 9l1.25-2.75L23 5l-2.75-1.25L19 1l-1.25 2.75L15 5l2.75 1.25L19 9zm-7.5.5L9 4 6.5 9.5 1 12l5.5 2.5L9 20l2.5-5.5L17 12l-5.5-2.5zM19 15l-1.25 2.75L15 19l2.75 1.25L19 23l1.25-2.75L23 19l-2.75-1.25L19 15z" />
          </svg>
        </button>
        <%!-- Send button (right) - MUST BE HIDDEN by default, appears when input has text --%>
        <button
          type="button"
          id="ai-send-button"
          class="absolute right-2 top-1/2 -translate-y-1/2 p-1.5 bg-primary text-primary-content rounded-full opacity-0 scale-75 transition-all duration-200 hover:bg-primary/90 hidden"
          phx-click={JS.dispatch("phx:toggle-ai-sidebar")}
          aria-label="Send"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
          </svg>
        </button>
      </div>
    </div>

    <%!-- RIGHT SECTION: Notifications, Help, Profile (NO CREATE BUTTON!) --%>
    <div class="flex items-center gap-1">
      <%!-- Notifications --%>
      <button class="relative p-2 text-base-content/60 hover:text-base-content hover:bg-base-200 rounded-lg transition-colors duration-200" aria-label="Notifications">
        <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
        </svg>
        <span class="absolute top-0.5 right-0.5 w-4 h-4 bg-primary text-primary-content text-xs font-bold rounded-full flex items-center justify-center">1</span>
      </button>

      <%!-- Help --%>
      <button class="p-2 text-base-content/60 hover:text-base-content hover:bg-base-200 rounded-lg transition-colors duration-200" aria-label="Help">
        <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
      </button>

      <%!-- Profile - MUST link to /settings --%>
      <a href="/settings" class="w-10 h-10 rounded-full overflow-hidden border-2 border-base-300 hover:border-primary transition-colors duration-200" title="Profile">
        <div class="w-full h-full bg-primary text-primary-content flex items-center justify-center">
          <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
          </svg>
        </div>
      </a>

      <%!-- DO NOT ADD CREATE BUTTON HERE - it belongs in the sidebar --%>
    </div>
  </div>
</header>
```

---

## 2. AI Assistant Input Field (CRITICAL)

This is the most commonly misimplemented component. Follow these exact specifications:

### Mandatory Requirements

| Requirement | Implementation |
|-------------|----------------|
| Placeholder text | `"What can I do for you?"` (NOT "Ask AI Assistant...", NOT "Search...") |
| Left icon | Sparkle/AutoAwesome SVG (filled, NOT outlined) |
| Left icon behavior | **MUST BE CLICKABLE** - triggers AI sidebar toggle |
| Right send button | **HIDDEN BY DEFAULT** with `hidden opacity-0 scale-75` |
| Send button visibility | Shown via JavaScript hook when input has text |
| Input styling | `rounded-full`, `bg-base-200`, `border border-base-300` |

### JavaScript Hook (REQUIRED)

```javascript
// In assets/js/hooks/ai_assistant_input.js
export const AIAssistantInput = {
  mounted() {
    const input = this.el;
    const sendButton = document.getElementById('ai-send-button');

    if (!sendButton) return;

    input.addEventListener('input', () => {
      if (input.value.trim()) {
        sendButton.classList.remove('hidden', 'opacity-0', 'scale-75');
        sendButton.classList.add('opacity-100', 'scale-100');
      } else {
        sendButton.classList.add('hidden', 'opacity-0', 'scale-75');
        sendButton.classList.remove('opacity-100', 'scale-100');
      }
    });
  }
};
```

### Register Hook in app.js

```javascript
import { AIAssistantInput } from "./hooks/ai_assistant_input"

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: {
    AIAssistantInput,
    // ... other hooks
  }
})
```

---

## 3. Logo Implementation (Lottie Animation)

### Mandatory Requirements

| Requirement | Implementation |
|-------------|----------------|
| Animation type | Lottie JSON files (NOT static images, NOT .lottie format) |
| Icon | Always show static icon `icon_simple_green_v1.png` |
| Text logo | Lottie animation with fallback SVG |
| Theme support | Hook-based switching OR CSS visibility classes |

### Option A: Hook-Based (Recommended)

```heex
<a href="/" class="flex items-center gap-2 ml-2">
  <%!-- Static icon (always visible) --%>
  <img src="/images/brand/icons/icon_simple_green_v1.png" alt="Interactor" class="w-6 h-6" />

  <%!-- Lottie logo with hook --%>
  <div
    id="interactor-logo-header"
    phx-hook="InteractorLogo"
    data-theme-aware="true"
    class="h-8 w-24 hidden sm:block"
  >
    <img src="/images/brand/logos/20221116_interactor_BI_text_green.svg" alt="Interactor" class="h-full w-auto" />
  </div>
</a>
```

### Option B: CSS Theme Toggle

```heex
<a href="/" class="flex items-center gap-2 ml-2">
  <img src="/images/brand/icons/icon_simple_green_v1.png" alt="Interactor" class="w-6 h-6" />

  <%!-- Light mode logo --%>
  <lottie-player
    src="/images/brand/lottie/InteractorLogo_Light.json"
    background="transparent"
    speed="1"
    style="width: 100px; height: 32px;"
    class="hidden sm:block dark:hidden"
    autoplay
  ></lottie-player>

  <%!-- Dark mode logo --%>
  <lottie-player
    src="/images/brand/lottie/InteractorLogo_Dark.json"
    background="transparent"
    speed="1"
    style="width: 100px; height: 32px;"
    class="hidden dark:sm:block"
    autoplay
  ></lottie-player>
</a>
```

### InteractorLogo Hook

```javascript
// In assets/js/hooks/interactor_logo.js
export const InteractorLogo = {
  mounted() {
    this.loadLottie();
    this.observeTheme();
  },

  loadLottie() {
    const container = this.el;
    const isThemeAware = container.dataset.themeAware === 'true';
    const isDark = document.documentElement.classList.contains('dark') ||
                   document.documentElement.dataset.theme === 'dark';

    const src = isDark
      ? '/images/brand/lottie/InteractorLogo_Dark.json'
      : '/images/brand/lottie/InteractorLogo_Light.json';

    // Clear existing content
    container.innerHTML = '';

    // Create lottie-player
    const player = document.createElement('lottie-player');
    player.setAttribute('src', src);
    player.setAttribute('background', 'transparent');
    player.setAttribute('speed', '1');
    player.style.width = '100%';
    player.style.height = '100%';
    player.setAttribute('autoplay', '');

    container.appendChild(player);
  },

  observeTheme() {
    const observer = new MutationObserver(() => this.loadLottie());
    observer.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ['class', 'data-theme']
    });
  }
};
```

---

## 4. Profile Button (MUST Link to Settings)

The profile button MUST navigate to the `/settings` page. Do NOT create a dropdown menu.

```heex
<%!-- Profile - ALWAYS links to /settings --%>
<a
  href="/settings"
  class="w-10 h-10 rounded-full overflow-hidden border-2 border-base-300 hover:border-primary transition-colors duration-200"
  title="Profile"
>
  <%!-- With user avatar --%>
  <img :if={@current_user && @current_user.avatar_url}
       src={@current_user.avatar_url}
       alt={@current_user.name}
       class="w-full h-full object-cover" />

  <%!-- Fallback: user icon --%>
  <div :if={!@current_user || !@current_user.avatar_url}
       class="w-full h-full bg-primary text-primary-content flex items-center justify-center">
    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
    </svg>
  </div>
</a>
```

---

## 5. Create Button (SIDEBAR ONLY)

The Create button belongs in the **left sidebar**, NOT in the GNB header.

```heex
<%!-- Inside left sidebar, after sidebar header --%>
<div class="p-4 shrink-0">
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

---

## 6. Full-Screen Layout Structure

The application MUST use a full-screen flex layout:

```heex
<div class="flex flex-col h-screen">
  <%!-- Header (GNB) --%>
  <header class="sticky top-0 z-50 border-b border-base-300 bg-base-100 shrink-0">
    <!-- GNB content -->
  </header>

  <%!-- Main content area --%>
  <div class="flex flex-1 overflow-hidden">
    <main class="flex-1 overflow-y-auto bg-base-200">
      <!-- Page content -->
    </main>

    <%!-- AI Sidebar (right side) --%>
    <.live_component module={AISidebar} id="ai-sidebar" />
  </div>
</div>
```

---

## Common Mistakes to AVOID

### 1. Using static logo image instead of Lottie

```heex
<%!-- WRONG --%>
<img src="/images/logo.png" alt="Logo" />

<%!-- CORRECT --%>
<div phx-hook="InteractorLogo" data-theme-aware="true">
  <img src="/images/brand/logos/fallback.svg" alt="Interactor" />
</div>
```

### 2. Non-clickable AI sparkle icon

```heex
<%!-- WRONG - sparkle is just a visual decoration --%>
<span class="absolute left-2 top-1/2 -translate-y-1/2 text-primary/70">
  <svg>...</svg>
</span>

<%!-- CORRECT - sparkle is a clickable button --%>
<button
  type="button"
  class="absolute left-2 top-1/2 -translate-y-1/2 p-1 text-primary/70 hover:text-primary"
  phx-click={JS.dispatch("phx:toggle-ai-sidebar")}
>
  <svg>...</svg>
</button>
```

### 3. Always-visible send button

```heex
<%!-- WRONG - send button always visible --%>
<button class="absolute right-2 ...">Send</button>

<%!-- CORRECT - send button hidden by default --%>
<button
  id="ai-send-button"
  class="absolute right-2 ... hidden opacity-0 scale-75"
>
  <svg>...</svg>
</button>
```

### 4. Create button in header

```heex
<%!-- WRONG - Create button in GNB --%>
<div class="flex items-center gap-1">
  <button>Notifications</button>
  <button>Help</button>
  <a href="/create" class="btn btn-primary">Create</a>  <%!-- NO! --%>
  <a href="/profile">Profile</a>
</div>

<%!-- CORRECT - Create button in sidebar only --%>
```

### 5. Profile dropdown instead of link

```heex
<%!-- WRONG - dropdown menu --%>
<div class="dropdown">
  <button>Profile</button>
  <ul class="dropdown-content">
    <li><a href="/settings">Settings</a></li>
    <li><a href="/logout">Logout</a></li>
  </ul>
</div>

<%!-- CORRECT - direct link to settings --%>
<a href="/settings">Profile</a>
```

### 6. Wrong AI input placeholder

```heex
<%!-- WRONG --%>
<input placeholder="Ask AI Assistant..." />
<input placeholder="Search anything..." />
<input placeholder="Type a message..." />

<%!-- CORRECT --%>
<input placeholder="What can I do for you?" />
```

---

## Required Assets

Ensure these files are present in your project:

```
priv/static/images/brand/
├── icons/
│   ├── icon_simple_green_v1.png
│   └── icon_simple_white_v1.png
├── logos/
│   └── 20221116_interactor_BI_text_green.svg
└── lottie/
    ├── InteractorLogo_Light.json
    └── InteractorLogo_Dark.json
```

---

## Required JavaScript Files

```
assets/js/
├── hooks/
│   ├── ai_assistant_input.js
│   └── interactor_logo.js
└── vendor/
    └── lottie-player.js
```

---

## Validation Script

Run this mental checklist after implementing GNB:

1. **Logo**: Does clicking the logo navigate to `/`? Is it animated (Lottie)?
2. **AI Input**: Is the placeholder "What can I do for you?"?
3. **Sparkle Icon**: Does clicking it open the AI sidebar?
4. **Send Button**: Is it hidden when input is empty? Does it appear when typing?
5. **Create Button**: Is it ONLY in the sidebar, NOT in the header?
6. **Profile**: Does clicking it navigate to `/settings`?
7. **Layout**: Does the app fill the screen (`h-screen`)? Is the header sticky?
8. **Sign In**: If unauthenticated, does the profile area show a sign-in option (NOT "Sign In" text, but a proper icon/button)?
