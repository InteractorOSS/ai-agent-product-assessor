# Interactor Design System - Modals & Dropdowns

Modal dialogs, dropdown menus, and overlay components.

---

## Standard Modal
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

---

## Confirmation Dialog with Cancel/OK Buttons
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

---

## Dropdown/Autocomplete Modal
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

---

## Context Menu
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

---

## Add Button Dropdown
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

## Autocomplete/Combobox Input
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

## Feedback Modal

A 5-emoji feedback collection pattern that integrates with the sidebar and opens a modal for detailed feedback.

**Reference Screenshot**: The production design shows a clean modal with green-highlighted selected emoji states.

---

### Sidebar Integration

The feedback trigger is fixed at the bottom of the left drawer:

```
┌─────────────────────────────────┐
│  [+ Create]  🟢                 │
│  ... navigation items ...       │
│                                 │
│         (flex spacer)           │
│                                 │
├─────────────────────────────────┤
│  Feedback                       │
│  😞 😟 😐 🙂 😊                 │
└─────────────────────────────────┘
```

### Sidebar Trigger HTML

```html
<!-- Feedback section - fixed at bottom of sidebar -->
<div class="mt-auto border-t border-[#E5E5EA] dark:border-[#3A3A3C]">
  <div class="px-4 py-3">
    <span class="text-xs font-medium text-[#8E8E93] uppercase tracking-wider">
      Feedback
    </span>
    <div class="flex justify-around mt-2">
      <button
        data-rating="1"
        class="text-2xl opacity-60 hover:opacity-100 hover:scale-110 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-[#4CD964] rounded-lg p-1"
        aria-label="Very Dissatisfied"
      >😞</button>
      <button
        data-rating="2"
        class="text-2xl opacity-60 hover:opacity-100 hover:scale-110 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-[#4CD964] rounded-lg p-1"
        aria-label="Dissatisfied"
      >😟</button>
      <button
        data-rating="3"
        class="text-2xl opacity-60 hover:opacity-100 hover:scale-110 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-[#4CD964] rounded-lg p-1"
        aria-label="Neutral"
      >😐</button>
      <button
        data-rating="4"
        class="text-2xl opacity-60 hover:opacity-100 hover:scale-110 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-[#4CD964] rounded-lg p-1"
        aria-label="Satisfied"
      >🙂</button>
      <button
        data-rating="5"
        class="text-2xl opacity-60 hover:opacity-100 hover:scale-110 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-[#4CD964] rounded-lg p-1"
        aria-label="Very Satisfied"
      >😊</button>
    </div>
  </div>
</div>
```

### Modal Structure (Production Design)

```
┌─────────────────────────────────────────┐
│                                     [✕] │
│                                         │
│         Share Your Feedback             │
│   How are you feeling about your        │
│              experience?                │
│                                         │
│     😞   😟   [😐]   🙂   😊           │
│              Neutral                    │
│                                         │
│   What can we improve? (optional)       │
│   ┌─────────────────────────────────┐   │
│   │ Tell us more about your         │   │
│   │ experience...                   │   │
│   │                                 │   │
│   └─────────────────────────────────┘   │
│                                         │
│   Feedback for: /                       │
│                                         │
│   [  Cancel  ]   [ Submit Feedback ]    │
│                        🟢               │
└─────────────────────────────────────────┘
```

**Key Design Elements:**
- Modal is centered with semi-transparent backdrop (`bg-black/50`)
- Selected emoji has **green circular background** (`#4CD964` at 20% opacity)
- Rating label appears below emoji row in regular text color (not green)
- Textarea has light gray background with placeholder text
- Context shows current page path
- Cancel button is gray/secondary, Submit is green primary button

### Feedback Modal HTML (Production-Accurate)

```html
<!-- Feedback Modal backdrop -->
<div class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
  <!-- Modal container -->
  <div class="relative w-full max-w-md mx-4 bg-white dark:bg-[#2C2C2E] rounded-2xl shadow-2xl">
    <!-- Close button (top-right) -->
    <button class="absolute top-4 right-4 p-1 text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white rounded-full hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
      </svg>
    </button>

    <!-- Modal content -->
    <div class="p-6 pt-8">
      <!-- Title -->
      <h3 class="text-xl font-bold text-[#1C1C1E] dark:text-white mb-1 text-center">
        Share Your Feedback
      </h3>
      <p class="text-sm text-[#8E8E93] mb-6 text-center">
        How are you feeling about your experience?
      </p>

      <!-- Emoji rating selector -->
      <div class="flex justify-center gap-3 mb-2">
        <!--
          SELECTED STATE: Green circular background
          - Add bg-[#4CD964]/20 and ring-2 ring-[#4CD964] when selected
          - Use data-selected="true" attribute for JS toggling
        -->
        <button
          data-rating="1"
          class="w-12 h-12 text-2xl rounded-full flex items-center justify-center transition-all duration-200
                 hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C]
                 data-[selected=true]:bg-[#4CD964]/20 data-[selected=true]:ring-2 data-[selected=true]:ring-[#4CD964]"
          aria-label="Very Dissatisfied - 1 star"
        >😞</button>
        <button
          data-rating="2"
          class="w-12 h-12 text-2xl rounded-full flex items-center justify-center transition-all duration-200
                 hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C]
                 data-[selected=true]:bg-[#4CD964]/20 data-[selected=true]:ring-2 data-[selected=true]:ring-[#4CD964]"
          aria-label="Dissatisfied - 2 stars"
        >😟</button>
        <button
          data-rating="3"
          data-selected="true"
          class="w-12 h-12 text-2xl rounded-full flex items-center justify-center transition-all duration-200
                 hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C]
                 data-[selected=true]:bg-[#4CD964]/20 data-[selected=true]:ring-2 data-[selected=true]:ring-[#4CD964]"
          aria-label="Neutral - 3 stars"
        >😐</button>
        <button
          data-rating="4"
          class="w-12 h-12 text-2xl rounded-full flex items-center justify-center transition-all duration-200
                 hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C]
                 data-[selected=true]:bg-[#4CD964]/20 data-[selected=true]:ring-2 data-[selected=true]:ring-[#4CD964]"
          aria-label="Satisfied - 4 stars"
        >🙂</button>
        <button
          data-rating="5"
          class="w-12 h-12 text-2xl rounded-full flex items-center justify-center transition-all duration-200
                 hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C]
                 data-[selected=true]:bg-[#4CD964]/20 data-[selected=true]:ring-2 data-[selected=true]:ring-[#4CD964]"
          aria-label="Very Satisfied - 5 stars"
        >😊</button>
      </div>

      <!-- Rating label (dynamically updates based on selection) -->
      <p class="text-sm text-center text-[#1C1C1E] dark:text-white font-medium mb-6 h-5">
        Neutral
        <!-- Shows: Very Dissatisfied | Dissatisfied | Neutral | Satisfied | Very Satisfied -->
      </p>

      <!-- Comment textarea -->
      <div class="mb-4">
        <label class="block text-sm font-medium text-[#1C1C1E] dark:text-white mb-2">
          What can we improve? <span class="text-[#8E8E93] font-normal">(optional)</span>
        </label>
        <textarea
          rows="3"
          class="w-full px-4 py-3 bg-[#F5F5F7] dark:bg-[#3A3A3C] border border-[#E5E5EA] dark:border-[#4A4A4C] rounded-xl text-[#1C1C1E] dark:text-white placeholder-[#8E8E93] focus:outline-none focus:ring-2 focus:ring-[#4CD964] focus:border-transparent resize-none"
          placeholder="Tell us more about your experience..."
        ></textarea>
      </div>

      <!-- Context display -->
      <div class="text-sm text-[#8E8E93] mb-6">
        Feedback for: <span class="text-[#1C1C1E] dark:text-white">/</span>
      </div>

      <!-- Hidden fields for context data -->
      <input type="hidden" name="user_agent" id="feedback-user-agent" />
      <input type="hidden" name="viewport" id="feedback-viewport" />

      <!-- Action buttons -->
      <div class="flex gap-3">
        <button class="flex-1 px-6 py-3 bg-white dark:bg-[#3A3A3C] text-[#1C1C1E] dark:text-white font-medium rounded-full border border-[#E5E5EA] dark:border-[#4A4A4C] hover:bg-[#F5F5F7] dark:hover:bg-[#4A4A4C] transition-colors">
          Cancel
        </button>
        <button
          class="flex-1 px-6 py-3 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-semibold rounded-full transition-colors disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:bg-[#4CD964]"
        >
          Submit Feedback
        </button>
      </div>
    </div>
  </div>
</div>
```

---

### Emoji Selection States

| State | Styling |
|-------|---------|
| **Default** | No background, full opacity |
| **Hover** | Light gray background (`bg-[#F5F5F7]`) |
| **Selected** | Green circular background (`bg-[#4CD964]/20`) with green ring (`ring-2 ring-[#4CD964]`) |
| **Focus** | Green focus ring for accessibility |

### Selected Emoji CSS Pattern

```css
/* TailwindCSS classes for selected state */
.emoji-button-selected {
  @apply bg-[#4CD964]/20 ring-2 ring-[#4CD964];
}

/* Plain CSS equivalent */
.emoji-selected {
  background-color: rgba(76, 217, 100, 0.2);  /* #4CD964 at 20% opacity */
  border-radius: 9999px;                       /* Full circle */
  outline: 2px solid #4CD964;
  outline-offset: 0;
}
```

### Feedback Data Collected

| Field | Type | Description |
|-------|------|-------------|
| `rating` | integer (1-5) | Required. The selected emoji rating |
| `comment` | string | Optional. Additional feedback text |
| `page_url` | string | Current page URL/path |
| `user_id` | string/null | Authenticated user ID (if available) |
| `user_agent` | string | Browser user agent string |
| `viewport` | string | Window dimensions (e.g., "1920x1080") |
| `timestamp` | string | ISO 8601 timestamp |

### Rating Labels

| Rating | Emoji | Label |
|--------|-------|-------|
| 1 | 😞 | Very Dissatisfied |
| 2 | 😟 | Dissatisfied |
| 3 | 😐 | Neutral |
| 4 | 🙂 | Satisfied |
| 5 | 😊 | Very Satisfied |

### Interaction States

| State | Behavior |
|-------|----------|
| Sidebar emoji click | Opens modal with that rating pre-selected |
| Modal emoji click | Selects rating, shows label, enables Submit button |
| No rating selected | Submit button enabled (rating defaults to selection from sidebar) |
| Submit with rating | Closes modal, shows success toast notification |
| Cancel button | Closes modal, clears state |
| Close (X) button | Closes modal, clears state |
| Escape key | Closes modal |
| Click outside modal | Closes modal |

### Accessibility Requirements

| Feature | Implementation |
|---------|----------------|
| Keyboard navigation | Tab between emoji buttons, Enter to select |
| Focus indicators | Green focus ring on focused elements |
| ARIA labels | Each emoji has descriptive aria-label |
| Screen reader | Rating label announced on selection |
| Escape to close | Modal closes on Escape key press |

---

## Modal Specifications

| Property | Value |
|----------|-------|
| Border Radius (modals) | `rounded-2xl` (16px) |
| Border Radius (dropdowns) | `rounded-xl` (12px) |
| Shadow | `shadow-xl` or `shadow-2xl` |
| Max Width | `max-w-md` (28rem) |
| Padding | `p-6` |
| Backdrop | `bg-black/50` |
| Z-Index | `z-50` |
| List Item Padding | `px-4 py-2.5` or `px-4 py-3` |
| Dropdown Min Width | `w-48` to `w-56` |
