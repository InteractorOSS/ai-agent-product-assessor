# AutoFlow Design System - Compliance Checklist

Use this checklist before completing any UI work to ensure design system compliance.

---

## Design System Compliance

- [ ] Uses AutoFlow green (`#4CD964`) as primary accent color
- [ ] Buttons are pill-shaped (`rounded-full`)
- [ ] Inputs are pill-shaped (`rounded-full`)
- [ ] Dark mode uses correct background colors (`#1C1C1E`, `#2C2C2E`)
- [ ] Icons use outlined/stroke style with `stroke-width="1.5"`
- [ ] Hover states use correct green (`#3DBF55`)

---

## Component Verification

- [ ] Left navigation has green indicator bar for active item
- [ ] Forms use floating labels where appropriate
- [ ] Toggle switches use green when active
- [ ] Modals have `rounded-2xl` corners and shadow
- [ ] Dropdowns have `rounded-xl` corners
- [ ] Cancel/OK button pairs follow correct styling

---

## Flow Diagram Elements (if applicable)

- [ ] Nodes have green borders (`border-[#4CD964]`)
- [ ] Method badges use navy/green background
- [ ] Connection points are green circles with white center
- [ ] Lines use gray color (`#8E8E93`) with rounded corners
- [ ] Conditional nodes (If/Else) follow branch layout pattern

---

## Dark Mode Verification

- [ ] Toggle system theme and verify all components update
- [ ] Text remains readable in both modes
- [ ] Borders use correct dark colors (`#3A3A3C`)
- [ ] Green accent color stays consistent in both modes
- [ ] Background colors transition correctly:
  - Primary: `#FFFFFF` → `#1C1C1E`
  - Secondary: `#F5F5F7` → `#2C2C2E`
  - Tertiary: `#E5E5EA` → `#3A3A3C`

---

## Responsive Design

- [ ] Sidebar collapses on mobile
- [ ] Touch targets are minimum 44px
- [ ] No horizontal overflow at any viewport
- [ ] Auth pages show form only on mobile (hide illustration)
- [ ] Header hamburger menu visible on mobile (`lg:hidden`)

---

## Color Usage Verification

| Element | Light Mode | Dark Mode |
|---------|------------|-----------|
| Primary Background | `#FFFFFF` | `#1C1C1E` |
| Secondary Background | `#F5F5F7` | `#2C2C2E` |
| Primary Text | `#1C1C1E` | `#FFFFFF` |
| Secondary Text | `#8E8E93` | `#8E8E93` |
| Borders | `#E5E5EA` | `#3A3A3C` |
| Primary Accent | `#4CD964` | `#4CD964` |
| Hover Accent | `#3DBF55` | `#3DBF55` |

---

## Button States Verification

| State | Primary Button | Secondary Button |
|-------|---------------|-----------------|
| Default | `bg-[#4CD964] text-white` | `border-[#4CD964] text-[#4CD964]` |
| Hover | `bg-[#3DBF55]` | `bg-[#4CD964] text-white` |
| Disabled | `opacity-50 cursor-not-allowed` | `opacity-50 cursor-not-allowed` |

---

## Icon Standards

- [ ] All icons use stroke style (not filled)
- [ ] Stroke width is `1.5` (or `2` for emphasis only)
- [ ] Icon color follows state: gray → green (active) → dark (hover)
- [ ] Icon sizes are consistent: `w-5 h-5` nav, `w-6 h-6` header

---

## Spacing Consistency

- [ ] Button padding follows scale: small `px-4 py-2`, standard `px-5 py-2.5`, large `px-6 py-3`
- [ ] Input padding: `px-4 py-3` or `px-4 py-3.5`
- [ ] Card/modal padding: `p-4` or `p-6`
- [ ] Navigation item padding: `px-4 py-3`
- [ ] Form labels use `w-24` width in settings panels

---

## Typography

- [ ] Headings use `font-bold`
- [ ] Navigation items use `font-medium`
- [ ] Labels use `text-sm text-[#8E8E93]`
- [ ] Section headers use uppercase, `text-xs`, `tracking-wider`

---

## Accessibility

- [ ] Color contrast meets WCAG AA standards
- [ ] Interactive elements have visible focus states
- [ ] Form inputs have associated labels
- [ ] Touch targets are at least 44x44px
- [ ] Icons have proper aria-labels or are hidden from screen readers

---

## Animation & Transitions

- [ ] Buttons use `transition-colors duration-200`
- [ ] Hover effects are smooth and consistent
- [ ] Modal backdrops use appropriate transitions
- [ ] Toggle switches animate smoothly
