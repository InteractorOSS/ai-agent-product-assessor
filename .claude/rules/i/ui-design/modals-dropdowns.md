# AutoFlow Design System - Modals & Dropdowns

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
