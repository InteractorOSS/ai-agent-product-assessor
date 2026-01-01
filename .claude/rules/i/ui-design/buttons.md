# Interactor Design System - Button Styles

All buttons in Interactor use pill-shaped (fully rounded) design with green accent colors.

---

## Primary Button (Filled Green)
```html
<!-- Full-width primary button (login, register, main CTA) -->
<button class="w-full px-6 py-3 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-semibold rounded-full transition-colors duration-200">
  Login
</button>

<!-- Standard primary button -->
<button class="inline-flex items-center gap-2 px-5 py-2.5 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium rounded-full transition-colors duration-200">
  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
  </svg>
  Add
</button>
```

## Primary Button with Dropdown
```html
<button class="inline-flex items-center gap-2 px-5 py-2.5 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium rounded-full transition-colors duration-200">
  Add
  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
  </svg>
</button>
```

## Secondary Button (Outlined)
```html
<!-- Outlined button -->
<button class="inline-flex items-center justify-center px-5 py-2.5 bg-transparent border-2 border-[#4CD964] text-[#4CD964] font-medium rounded-full hover:bg-[#4CD964] hover:text-white transition-colors duration-200">
  Activate
</button>

<!-- Outlined with subtle background -->
<button class="inline-flex items-center justify-center px-4 py-2 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] text-[#1C1C1E] dark:text-white font-medium rounded-full hover:border-[#4CD964] transition-colors duration-200">
  All
</button>
```

## Icon Buttons
```html
<!-- Icon-only button (toolbar) -->
<button class="p-2 text-[#8E8E93] hover:text-[#4CD964] hover:bg-[#F5F5F7] dark:hover:bg-[#2C2C2E] rounded-lg transition-colors duration-200">
  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
  </svg>
</button>

<!-- Circular icon button (floating action) -->
<button class="w-12 h-12 flex items-center justify-center bg-[#4CD964] hover:bg-[#3DBF55] text-white rounded-full shadow-lg transition-colors duration-200">
  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
  </svg>
</button>
```

## Category/Filter Pills
```html
<!-- Category pill group -->
<div class="flex flex-wrap gap-2">
  <!-- Active pill -->
  <button class="px-4 py-1.5 bg-[#4CD964] text-white text-sm font-medium rounded-full">
    All
  </button>
  <!-- Inactive pill -->
  <button class="px-4 py-1.5 bg-transparent border border-[#4CD964] text-[#4CD964] text-sm font-medium rounded-full hover:bg-[#4CD964] hover:text-white transition-colors">
    Array
  </button>
  <button class="px-4 py-1.5 bg-transparent border border-[#4CD964] text-[#4CD964] text-sm font-medium rounded-full hover:bg-[#4CD964] hover:text-white transition-colors">
    Communication
  </button>
</div>
```

## Cancel/OK Button Pair
```html
<!-- Dialog action buttons -->
<div class="flex gap-3">
  <button class="flex-1 px-6 py-3 bg-[#F5F5F7] dark:bg-[#3A3A3C] text-[#1C1C1E] dark:text-white font-medium rounded-full hover:bg-[#E5E5EA] dark:hover:bg-[#4A4A4C] transition-colors">
    Cancel
  </button>
  <button class="flex-1 px-6 py-3 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-semibold rounded-full transition-colors">
    OK
  </button>
</div>
```

## Button Specifications

| Property | Value |
|----------|-------|
| Border Radius | `rounded-full` (9999px - pill shape) |
| Padding (standard) | `px-5 py-2.5` |
| Padding (large) | `px-6 py-3` |
| Padding (small) | `px-4 py-2` |
| Padding (pill) | `px-4 py-1.5` |
| Font Weight | `font-medium` or `font-semibold` |
| Transition | `transition-colors duration-200` |
| Icon Size | `w-4 h-4` or `w-5 h-5` |
| Icon Button Padding | `p-2` |
| Circular Button Size | `w-12 h-12` |

## Button States

| State | Primary | Secondary |
|-------|---------|-----------|
| Default | `bg-[#4CD964] text-white` | `border-[#4CD964] text-[#4CD964]` |
| Hover | `bg-[#3DBF55]` | `bg-[#4CD964] text-white` |
| Disabled | `opacity-50 cursor-not-allowed` | `opacity-50 cursor-not-allowed` |
| Active | `bg-[#3DBF55]` | `bg-[#4CD964] text-white` |
