# Interactor Design System - Form Elements

Form inputs in Interactor use pill-shaped design with floating labels and green focus states.

---

## Text Input (Floating Label Style)
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

## Standard Input (Simple)
```html
<input
  type="text"
  class="w-full px-4 py-3 bg-[#F5F5F7] dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] focus:border-[#4CD964] rounded-full text-[#1C1C1E] dark:text-white placeholder-[#8E8E93] focus:outline-none focus:ring-0 transition-colors"
  placeholder="Enter your email"
/>
```

## Search Input
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

## Input with Clear Button
```html
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
```

## Checkbox
```html
<label class="inline-flex items-center gap-3 cursor-pointer">
  <input
    type="checkbox"
    class="w-5 h-5 rounded border-[#E5E5EA] dark:border-[#3A3A3C] text-[#4CD964] focus:ring-[#4CD964] focus:ring-offset-0 bg-white dark:bg-[#2C2C2E]"
  />
  <span class="text-sm text-[#8E8E93]">Remember Me</span>
</label>
```

## Toggle Switch
```html
<!-- Toggle switch -->
<label class="relative inline-flex items-center cursor-pointer">
  <input type="checkbox" class="sr-only peer" />
  <div class="w-11 h-6 bg-[#E5E5EA] dark:bg-[#3A3A3C] peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-[#4CD964]"></div>
  <span class="ml-3 text-sm text-[#8E8E93]">Dark theme</span>
</label>
```

## Dropdown/Select
```html
<div class="relative">
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
```

## Properties Form Field
```html
<!-- Form field with label -->
<div class="flex items-center">
  <label class="w-24 text-sm text-[#8E8E93]">Name</label>
  <input
    type="text"
    class="flex-1 px-3 py-2 bg-[#F5F5F7] dark:bg-[#2C2C2E] border-0 rounded-lg text-[#1C1C1E] dark:text-white focus:outline-none focus:ring-2 focus:ring-[#4CD964]"
    value="HTTP Server for ORDS"
  />
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
```

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
        Option 1
      </button>
      <button class="w-full px-4 py-3 text-left text-[#1C1C1E] dark:text-white hover:bg-[#F5F5F7] dark:hover:bg-[#3A3A3C] transition-colors">
        Option 2
      </button>
    </div>
  </div>
</div>
```

## Form Input Specifications

| Property | Value |
|----------|-------|
| Border Radius | `rounded-full` (pill shape) for standard inputs |
| Border Radius (form fields) | `rounded-lg` (8px) |
| Padding | `px-4 py-3` |
| Background (light) | `#F5F5F7` |
| Background (dark) | `#2C2C2E` |
| Focus Border | `#4CD964` (green) |
| Placeholder Color | `#8E8E93` |
| Label Width (forms) | `w-24` |
| Toggle Width | `w-11` |
| Toggle Height | `h-6` |
| Checkbox Size | `w-5 h-5` |
