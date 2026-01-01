# Interactor Design System - Panels & Toolbar

Settings panels, properties forms, and toolbar components.

---

## Right Sidebar Panel
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

## Main Toolbar
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

## Panel Tab Navigation
```html
<!-- Tab navigation pattern -->
<div class="flex gap-6 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
  <!-- Active tab -->
  <button class="text-[#4CD964] font-medium border-b-2 border-[#4CD964] pb-2">
    Actions
  </button>
  <!-- Inactive tab -->
  <button class="text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white pb-2 border-b-2 border-transparent">
    Settings
  </button>
  <button class="text-[#8E8E93] hover:text-[#1C1C1E] dark:hover:text-white pb-2 border-b-2 border-transparent">
    Logs
  </button>
</div>
```

---

## Panel Specifications

| Element | Specification |
|---------|---------------|
| Right Sidebar Width | `w-80` (320px) |
| Panel Border Radius | `rounded-t-2xl` (top only for docked panels) |
| Tab Active State | Green text + green bottom border |
| Form Label Width | `w-24` |
| Form Input Border Radius | `rounded-lg` (8px) |
| Toolbar Gap | `gap-2` |
| Divider Style | `w-px h-6 bg-[#E5E5EA]` |
| Toolbar Padding | `px-4 py-2` |
