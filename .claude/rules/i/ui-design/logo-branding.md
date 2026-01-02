# Interactor Design System - Logo & Branding

Implementation guide for the Interactor animated logo using lottie-player.

---

## Animated Logo Implementation

### Required Files

The Interactor logo uses Lottie animations. Two variants are provided:

| File | Content Color | Use Case |
|------|---------------|----------|
| `InteractorLogo_DarkMode.json` | Dark colors | Light backgrounds (light mode) |
| `InteractorLogo_LightMode.json` | Light colors | Dark backgrounds (dark mode) |

**Location**: `.claude/assets/i/brand/lottie/`

**Important**: Use the JSON files, NOT the `.lottie` files. The `lottie-player` web component does not support the compressed `.lottie` format.

---

## Setup Instructions

### 1. Install lottie-player

Copy the lottie-player library to your vendor directory:

```bash
# Download from: https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js
# Save to: assets/vendor/lottie-player.js
```

### 2. Import in JavaScript

```javascript
// In assets/js/app.js
import "../vendor/lottie-player"
```

### 3. Copy Logo Files

Copy the JSON files to your static assets:

```bash
cp .claude/assets/i/brand/lottie/InteractorLogo_DarkMode.json priv/static/images/logo/
cp .claude/assets/i/brand/lottie/InteractorLogo_LightMode.json priv/static/images/logo/
```

---

## Component Implementation

### Phoenix LiveView / HEEx Template

```heex
<%!-- Interactor Logo (Lottie animation) --%>
<a href="/" class="flex items-center ml-2">
  <lottie-player
    src="/images/logo/InteractorLogo_DarkMode.json"
    background="transparent"
    speed="1"
    style="width: 120px; height: 30px;"
    autoplay
  >
  </lottie-player>
</a>
```

### React / Next.js

```jsx
// Install: npm install @lottiefiles/react-lottie-player
import { Player } from '@lottiefiles/react-lottie-player';

function Logo() {
  return (
    <a href="/" className="flex items-center ml-2">
      <Player
        src="/images/logo/InteractorLogo_DarkMode.json"
        background="transparent"
        speed={1}
        style={{ width: 120, height: 30 }}
        autoplay
      />
    </a>
  );
}
```

### Vanilla HTML

```html
<script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>

<a href="/" class="flex items-center ml-2">
  <lottie-player
    src="/images/logo/InteractorLogo_DarkMode.json"
    background="transparent"
    speed="1"
    style="width: 120px; height: 30px"
    autoplay
  >
  </lottie-player>
</a>
```

---

## Theme Support

For applications with dark/light mode switching:

### Option 1: CSS Display Toggle

```heex
<%!-- Light mode logo (dark content) --%>
<lottie-player
  src="/images/logo/InteractorLogo_DarkMode.json"
  background="transparent"
  speed="1"
  style="width: 120px; height: 30px;"
  class="block dark:hidden"
  autoplay
>
</lottie-player>

<%!-- Dark mode logo (light content) --%>
<lottie-player
  src="/images/logo/InteractorLogo_LightMode.json"
  background="transparent"
  speed="1"
  style="width: 120px; height: 30px;"
  class="hidden dark:block"
  autoplay
>
</lottie-player>
```

### Option 2: JavaScript Dynamic Switching

```javascript
// In a Phoenix Hook or React useEffect
const isDarkMode = document.documentElement.classList.contains('dark');
const logoSrc = isDarkMode
  ? '/images/logo/InteractorLogo_LightMode.json'
  : '/images/logo/InteractorLogo_DarkMode.json';

document.querySelector('lottie-player').setAttribute('src', logoSrc);
```

---

## Specifications

| Property | Value |
|----------|-------|
| Width | `120px` (header), adjustable for other contexts |
| Height | `30px` (maintains aspect ratio) |
| Background | `transparent` |
| Speed | `1` (normal playback) |
| Autoplay | `true` (plays once on load) |

---

## Do NOT Use

- **DotLottie format** (`.lottie` files) - Not supported by lottie-player web component
- **DotLottie player** - More complex setup, WASM dependencies, less reliable
- **Background colors on the lottie-player** - Keep transparent, let page background show through

---

## Fallback (Static Logo)

If Lottie animation is not suitable, use static PNG/SVG:

```html
<a href="/" class="flex items-center gap-2">
  <img src="/images/logo/interactor_with_icon_green.png" alt="Interactor" class="h-8" />
</a>
```

Static assets available in `.claude/assets/i/brand/logos/`
