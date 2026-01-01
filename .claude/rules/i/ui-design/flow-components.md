# Interactor Design System - Flow Diagram Components

Flow diagram components for visual builders including nodes, connectors, and endpoints.

---

## Server Node
```html
<!-- Server/Entry node with method badge -->
<div class="relative inline-flex">
  <!-- Main node -->
  <div class="flex items-center gap-3 px-4 py-3 bg-white dark:bg-[#2C2C2E] border-2 border-[#4CD964] rounded-lg min-w-[180px]">
    <svg class="w-6 h-6 text-[#4CD964]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2"/>
    </svg>
    <div>
      <div class="font-semibold text-[#1C1C1E] dark:text-white">Server</div>
      <div class="text-sm text-[#8E8E93]">port: 1111</div>
    </div>
  </div>

  <!-- Method badge (attached to right) -->
  <div class="absolute -right-8 top-1/2 -translate-y-1/2 px-2 py-6 bg-[#2C3E50] text-white text-xs font-bold uppercase tracking-wide rounded-r-lg" style="writing-mode: vertical-lr; text-orientation: mixed;">
    ANY
  </div>

  <!-- Connection point (right side) -->
  <div class="absolute -right-12 top-1/2 -translate-y-1/2 w-3 h-3 bg-white border-2 border-[#4CD964] rounded-full"></div>
</div>
```

---

## Action Node
```html
<!-- Standard action node -->
<div class="relative inline-flex items-center">
  <!-- Connection point (left) -->
  <div class="absolute -left-1.5 top-1/2 -translate-y-1/2 w-3 h-3 bg-white border-2 border-[#4CD964] rounded-full"></div>

  <!-- Node body -->
  <div class="px-6 py-3 bg-white dark:bg-[#2C2C2E] border-2 border-[#4CD964] rounded-lg min-w-[120px] text-center">
    <span class="font-medium text-[#1C1C1E] dark:text-white">Get Data</span>
  </div>

  <!-- Connection point (right) -->
  <div class="absolute -right-1.5 top-1/2 -translate-y-1/2 w-3 h-3 bg-white border-2 border-[#4CD964] rounded-full"></div>
</div>
```

---

## Path Node (with Path Badge)
```html
<!-- Node with attached path badge -->
<div class="relative inline-flex">
  <!-- Method badge (left side) -->
  <div class="px-2 py-6 bg-[#4CD964] text-white text-xs font-bold uppercase tracking-wide rounded-l-lg" style="writing-mode: vertical-lr; text-orientation: mixed;">
    ANY
  </div>

  <!-- Main node -->
  <div class="flex flex-col justify-center px-4 py-3 bg-white dark:bg-[#2C2C2E] border-2 border-l-0 border-[#4CD964] rounded-r-lg min-w-[140px]">
    <div class="font-semibold text-[#1C1C1E] dark:text-white">Example</div>
    <div class="text-sm text-[#8E8E93]">path/</div>
  </div>

  <!-- Connection point -->
  <div class="absolute -right-1.5 top-1/2 -translate-y-1/2 w-3 h-3 bg-white border-2 border-[#4CD964] rounded-full"></div>
</div>
```

---

## Connection Lines
```html
<!-- Connector line (horizontal) -->
<div class="h-0.5 bg-[#8E8E93] dark:bg-[#636366]"></div>

<!-- Connector with arrow -->
<div class="flex items-center">
  <div class="flex-1 h-0.5 bg-[#8E8E93] dark:bg-[#636366]"></div>
  <svg class="w-3 h-3 text-[#8E8E93] dark:text-[#636366] -ml-1" fill="currentColor" viewBox="0 0 24 24">
    <path d="M10 17l5-5-5-5v10z"/>
  </svg>
</div>

<!-- Curved connector (use SVG path) -->
<svg class="absolute" width="100" height="100">
  <path
    d="M 0,50 Q 50,50 50,100"
    fill="none"
    stroke="#8E8E93"
    stroke-width="2"
    stroke-linecap="round"
  />
  <!-- Green endpoint circle -->
  <circle cx="50" cy="100" r="6" fill="#4CD964"/>
  <circle cx="50" cy="100" r="3" fill="white"/>
</svg>
```

---

## Flow Endpoint Markers
```html
<!-- Arrow/Chevron -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <path d="M9 18l6-6-6-6"/>
</svg>

<!-- Triangle (outline) -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <path d="M12 5l7 14H5z"/>
</svg>

<!-- Triangle (filled) -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="currentColor">
  <path d="M12 5l7 14H5z"/>
</svg>

<!-- Circle (outline) -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <circle cx="12" cy="12" r="6"/>
</svg>

<!-- Circle (filled) -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="currentColor">
  <circle cx="12" cy="12" r="6"/>
</svg>

<!-- Diamond (outline) -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <path d="M12 2l8 10-8 10-8-10z"/>
</svg>

<!-- Diamond (filled) -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="currentColor">
  <path d="M12 2l8 10-8 10-8-10z"/>
</svg>

<!-- Dash/Line -->
<svg class="w-4 h-4 text-[#4CD964]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <path d="M5 12h14"/>
</svg>
```

---

## Connection Point (Port)
```html
<!-- Connection port circle -->
<div class="w-3 h-3 bg-white border-2 border-[#4CD964] rounded-full"></div>

<!-- Active/highlighted connection port -->
<div class="w-4 h-4 bg-[#4CD964] rounded-full flex items-center justify-center">
  <div class="w-2 h-2 bg-white rounded-full"></div>
</div>
```

---

## Conditional Flow Node (If/Else)
```html
<!-- Conditional node with branches -->
<div class="relative inline-block">
  <!-- Main conditional container -->
  <div class="bg-white dark:bg-[#2C2C2E] border-2 border-[#4CD964] rounded-lg p-4 min-w-[280px]">
    <!-- Header with icon -->
    <div class="flex items-center gap-3 mb-4">
      <svg class="w-6 h-6 text-[#4CD964]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 9l4-4 4 4m0 6l-4 4-4-4"/>
      </svg>
      <span class="font-semibold text-[#1C1C1E] dark:text-white">If user exists</span>
    </div>

    <!-- True branch -->
    <div class="flex items-center gap-3 mb-3">
      <span class="text-sm text-[#8E8E93] w-10">True</span>
      <div class="flex-1 flex items-center">
        <div class="px-4 py-2 bg-[#E8F8EB] dark:bg-[#4CD964]/10 border border-[#4CD964] rounded-lg text-sm text-[#4CD964]">
          get user data
        </div>
        <div class="w-8 h-0.5 bg-[#8E8E93]"></div>
        <div class="w-3 h-3 bg-[#4CD964] rounded-full flex items-center justify-center">
          <div class="w-1.5 h-1.5 bg-white rounded-full"></div>
        </div>
      </div>
    </div>

    <!-- Else branch -->
    <div class="flex items-center gap-3">
      <span class="text-sm text-[#8E8E93] w-10">Else</span>
      <div class="flex-1 flex items-center">
        <div class="px-4 py-2 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] rounded-lg text-sm text-[#1C1C1E] dark:text-white">
          error data/log
        </div>
        <div class="w-8 h-0.5 bg-[#8E8E93]"></div>
        <div class="w-3 h-3 bg-[#4CD964] rounded-full flex items-center justify-center">
          <div class="w-1.5 h-1.5 bg-white rounded-full"></div>
        </div>
      </div>
    </div>
  </div>
</div>
```

---

## Grouped Flow Container (Switch/Router)
```html
<!-- Switch/Router container with multiple branches -->
<div class="bg-white dark:bg-[#2C2C2E] border-2 border-[#4CD964] rounded-lg p-4">
  <!-- Header with dropdown -->
  <div class="flex items-center justify-between mb-4 pb-3 border-b border-[#E5E5EA] dark:border-[#3A3A3C]">
    <div class="flex items-center gap-2">
      <span class="font-semibold text-[#1C1C1E] dark:text-white">APP ID</span>
      <svg class="w-4 h-4 text-[#8E8E93]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
      </svg>
    </div>
    <button class="w-6 h-6 flex items-center justify-center text-[#4CD964] border border-[#4CD964] rounded-full hover:bg-[#4CD964] hover:text-white transition-colors">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
      </svg>
    </button>
  </div>

  <!-- Branch rows -->
  <div class="space-y-3">
    <!-- Row with label and action chain -->
    <div class="flex items-center gap-4">
      <span class="text-sm text-[#1C1C1E] dark:text-white w-24">Google Drive</span>
      <div class="flex items-center gap-2">
        <div class="px-3 py-1.5 bg-[#E8F8EB] border border-[#4CD964] rounded text-xs text-[#4CD964]">DRIVEID EXISTS?</div>
        <div class="w-4 h-0.5 bg-[#8E8E93]"></div>
        <div class="px-3 py-1.5 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] rounded text-xs">FIELDS EXISTS?</div>
        <div class="w-4 h-0.5 bg-[#8E8E93]"></div>
        <div class="px-3 py-1.5 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] rounded text-xs">SORT EXISTS?</div>
        <div class="w-4 h-0.5 bg-[#8E8E93]"></div>
        <div class="px-3 py-1.5 bg-[#4CD964] text-white rounded text-xs">drive.files.list</div>
      </div>
    </div>

    <div class="flex items-center gap-4">
      <span class="text-sm text-[#1C1C1E] dark:text-white w-24">OneDrive</span>
      <div class="flex items-center gap-2">
        <div class="px-3 py-1.5 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] rounded text-xs">data/set</div>
        <div class="w-4 h-0.5 bg-[#8E8E93]"></div>
        <div class="px-3 py-1.5 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] rounded text-xs">FIELD EXISTS?</div>
      </div>
    </div>

    <div class="flex items-center gap-4">
      <span class="text-sm text-[#1C1C1E] dark:text-white w-24">Default</span>
      <div class="flex items-center gap-2">
        <div class="px-3 py-1.5 bg-white dark:bg-[#2C2C2E] border border-[#E5E5EA] dark:border-[#3A3A3C] rounded text-xs">JUST SOME LOGIC</div>
      </div>
    </div>
  </div>
</div>
```

---

## Flow Diagram Specifications

| Element | Specification |
|---------|---------------|
| Node Border | `border-2 border-[#4CD964]` |
| Node Border Radius | `rounded-lg` (8px) |
| Node Min Width | `min-w-[120px]` to `min-w-[180px]` |
| Node Padding | `px-4 py-3` or `px-6 py-3` |
| Connection Point Size | `w-3 h-3` (12px) |
| Connection Line Color | `#8E8E93` (gray) |
| Method Badge Background | `#2C3E50` (navy) or `#4CD964` (green) |
| Method Badge Text | Uppercase, vertical orientation |
