---
name: ui-design
description: Validates UI compliance with Interactor design system and generates components following design standards. Use before completing UI work or when creating new components.
allowed-tools: [Read, Grep, Glob, Edit, MultiEdit, Write]
author: Peter Jung
---

# UI Design Validation & Generation Skill

**Purpose**: Validate UI code against design system standards and generate compliant components.

**When to use this skill**:
- Before completing any UI work (pre-commit validation)
- When creating new UI components
- When reviewing UI pull requests
- When unsure about design compliance
- When generating component boilerplate

---

## What This Skill Does

### 1. Validation Tasks

This skill validates UI code against:

**Universal Standards** (`.claude/rules/i/ui-design.md`):
- ✅ Color palette compliance (#4CD964 green for primary actions)
- ✅ Border radius standards (pill buttons, rounded cards)
- ✅ Spacing scale consistency
- ✅ Typography correctness
- ✅ Icon style (outlined, stroke-width 1.5)
- ✅ Component dimensions
- ✅ Dark mode implementation
- ✅ Accessibility requirements

**Framework-Specific Requirements** (`docs/i/ui-design/material-ui/enforcement.md`):
- ✅ 9 Mandatory Material UI patterns
- ✅ Layout structure (AppBar, Drawer, Content)
- ✅ Lottie animated logo
- ✅ Green Create button
- ✅ Quick Create (+) button
- ✅ Dual notification badge
- ✅ Warnings below items
- ✅ Feedback section

### 2. Generation Tasks

Generate compliant components:
- Buttons (primary, secondary, danger)
- Forms (inputs, selects, checkboxes)
- Cards and panels
- Modals and dialogs
- Navigation elements
- Layout structures

---

## Validation Workflow

### Step 1: Read Design Standards

```
Read .claude/rules/i/ui-design.md
```

### Step 2: Check Framework Requirements

If application uses Material UI patterns:
```
Read docs/i/ui-design/material-ui/enforcement.md
```

### Step 3: Validate Component

Check the component against:
1. Colors match design system
2. Border radius follows standards
3. Spacing is consistent
4. Typography is correct
5. Icons use outlined style
6. Dimensions are correct
7. Dark mode works
8. Accessibility standards met
9. Framework patterns followed (if applicable)

### Step 4: Report Findings

Provide validation report:
```
✅ PASS: Colors - Using #4CD964 for primary button
✅ PASS: Border radius - Button uses rounded-full
✅ PASS: Spacing - Card padding is p-6 (24px)
❌ FAIL: Icon style - Using filled icons instead of outlined
⚠️  WARN: Accessibility - Missing aria-label on icon button
```

---

## Component Generation

### Generate Primary Button

```elixir
def button(assigns) do
  ~H"""
  <button class="bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium px-6 py-2 rounded-full shadow-md transition-colors">
    <%= render_slot(@inner_block) %>
  </button>
  """
end
```

### Generate Form Input

```elixir
def input(assigns) do
  ~H"""
  <input
    type={@type}
    name={@name}
    class="w-full px-4 py-3 bg-[#F5F5F7] dark:bg-[#2C2C2E] border border-transparent focus:border-[#4CD964] rounded-full outline-none transition-colors"
    placeholder={@placeholder}
  />
  """
end
```

### Generate Card

```elixir
def card(assigns) do
  ~H"""
  <div class="bg-white dark:bg-[#2C2C2E] rounded-2xl shadow-md p-6">
    <%= render_slot(@inner_block) %>
  </div>
  """
end
```

---

## Quick Reference

### Design Standards Location

All design standards are now defined in **rules** (auto-applied):

| Standard | Location |
|----------|----------|
| **Universal Standards** | `.claude/rules/i/ui-design.md` |
| **Material UI Patterns** | `docs/i/ui-design/material-ui/enforcement.md` |

### Detailed Documentation

For deep dives and complete specifications:

| Topic | Location |
|-------|----------|
| **Complete Material UI Spec** | `docs/i/ui-design/material-ui/index.md` |
| **GNB Components** | `docs/i/ui-design/gnb-components.md` |
| **Buttons** | `docs/i/ui-design/buttons.md` |
| **Forms** | `docs/i/ui-design/forms.md` |
| **Colors** | `docs/i/ui-design/colors.md` |
| **Icons & Spacing** | `docs/i/ui-design/icons-spacing.md` |
| **Navigation** | `docs/i/ui-design/navigation.md` |
| **Modals & Dropdowns** | `docs/i/ui-design/modals-dropdowns.md` |
| **Panels & Toolbar** | `docs/i/ui-design/panels-toolbar.md` |
| **Flow Components** | `docs/i/ui-design/flow-components.md` |
| **Auth Pages** | `docs/i/ui-design/auth-pages.md` |
| **Validation Checklist** | `docs/i/ui-design/material-ui/checklist.md` |

### Framework Adapters

| Framework | Translation Guide |
|-----------|-------------------|
| **TailwindCSS** | `docs/i/ui-design/tailwind/index.md` |
| **Phoenix/LiveView** | `docs/i/ui-design/phoenix/index.md` |

---

## Validation Checklist

Before completing UI work, verify:

### Universal Standards (Always)
- [ ] Using Interactor green (`#4CD964`) for primary actions
- [ ] Buttons and inputs are pill-shaped (`rounded-full`)
- [ ] Cards use `rounded-2xl` (16px radius)
- [ ] Spacing follows defined scale (8px, 12px, 16px, 24px)
- [ ] Icons use outlined style with `stroke-width="1.5"`
- [ ] Typography uses correct sizes and weights
- [ ] Dark mode colors implemented correctly
- [ ] Responsive design works on mobile (test all breakpoints)
- [ ] Accessibility standards met (WCAG AA minimum):
  - [ ] Color contrast ≥4.5:1 for normal text
  - [ ] Touch targets ≥44x44px on mobile
  - [ ] Keyboard accessible
  - [ ] ARIA labels for icon buttons
  - [ ] Focus states visible

### Material UI Patterns (If Applicable)
- [ ] **Layout**: AppBar + Left Drawer + Main Content structure
- [ ] **Logo**: Using Lottie animated logo (not static PNG)
- [ ] **Create Button**: Green `#4CD964` in left drawer
- [ ] **Quick Create (+)**: Green FAB in AppBar → opens right panel
- [ ] **Notifications**: Dual badge (count + error count)
- [ ] **Warnings**: Placed BELOW problematic items (not at top)
- [ ] **Feedback**: 5 emoji faces at drawer bottom
- [ ] **Feedback Modal**: Green circular bg on selected emoji
- [ ] **Feedback Modal**: Rating label uses regular text color (not green)

---

## Example Usage

### Validate Existing Component

```
Use ui-design skill to validate the UserProfile component in
lib/my_app_web/live/user_live/profile.ex

Check for:
1. Color compliance
2. Border radius standards
3. Spacing consistency
4. Dark mode support
5. Accessibility
```

### Generate New Component

```
Use ui-design skill to generate a SearchInput component with:
- Pill-shaped input
- Magnifying glass icon (outlined)
- Focus state with green border
- Dark mode support
- Phoenix LiveView compatible
```

### Pre-Commit Validation

```
Use ui-design skill to validate all UI changes in this PR against:
1. Universal design standards
2. Material UI patterns (we use 3-panel layout)
3. Accessibility requirements

Generate a compliance report.
```

---

## Integration with Other Tools

### With Code Review Skill

```
Use code-review skill for code quality
Then use ui-design skill for design compliance
```

### With Test Generator

```
Use ui-design skill to validate component
Then use test-generator to create tests for accessibility
```

### With Validator Skill

```
Use validator skill for general validation
Use ui-design skill for design-specific validation
```

---

## Common Issues & Fixes

### Issue: Wrong Button Color

**Problem**: Button uses blue or orange instead of green

**Fix**:
```elixir
# ❌ Wrong
<button class="bg-blue-500 ...">Create</button>

# ✅ Correct
<button class="bg-[#4CD964] hover:bg-[#3DBF55] ...">Create</button>
```

### Issue: Square Buttons

**Problem**: Button uses rounded corners instead of pill shape

**Fix**:
```elixir
# ❌ Wrong
<button class="... rounded-lg ...">Create</button>

# ✅ Correct
<button class="... rounded-full ...">Create</button>
```

### Issue: Filled Icons

**Problem**: Using filled/solid icons instead of outlined

**Fix**:
```elixir
# ❌ Wrong
<svg fill="currentColor">...</svg>

# ✅ Correct
<svg stroke="currentColor" fill="none" stroke-width="1.5">...</svg>
```

### Issue: Missing Dark Mode

**Problem**: Component doesn't have dark mode styles

**Fix**:
```elixir
# ❌ Wrong
<div class="bg-white text-black">

# ✅ Correct
<div class="bg-white dark:bg-[#2C2C2E] text-[#1C1C1E] dark:text-white">
```

---

## Advanced Features

### Batch Validation

Validate multiple components in one operation:

```
Use ui-design skill to validate all components in:
- lib/my_app_web/components/
- lib/my_app_web/live/

Generate summary report with pass/fail counts.
```

### Framework Detection

Automatically detect which frameworks are in use:

```
1. Check package.json for UI libraries
2. Check mix.exs for Phoenix LiveView
3. Apply appropriate validation rules
```

### Context-Aware Generation

Generate components matching existing project patterns:

```
1. Analyze existing components in codebase
2. Extract common patterns and naming
3. Generate new component following same conventions
4. Apply design system standards
```

---

## Performance Tips

**For large validations**:
1. Use Grep to find UI files quickly
2. Validate critical components first (buttons, forms, navigation)
3. Batch read files to reduce tool calls
4. Cache design standards for session

**For generation**:
1. Read design standards once, reuse throughout session
2. Use templates for common patterns
3. Generate multiple similar components in batch

---

## References

**Primary Sources** (Read these):
- `.claude/rules/i/ui-design.md` - Universal standards (auto-applied)
- `docs/i/ui-design/material-ui/enforcement.md` - Material UI patterns

**Secondary Documentation** (Read on-demand):
- `docs/i/ui-design/` - Complete design system documentation
- `.claude/templates/ui/` - UI component templates

---

**Skill Version**: 2.0 (Validation & Generation Focus)
**Last Updated**: January 19, 2026
