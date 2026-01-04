# Feedback Modal - Quick Reference

**Complete specification**: See `modals-dropdowns.md` → Feedback Modal section

---

## Overview

The Feedback Modal collects user sentiment through a 5-emoji rating system with optional comments.

**Trigger**: Click any emoji in the sidebar Feedback section

---

## Visual Structure

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
│   └─────────────────────────────────┘   │
│                                         │
│   Feedback for: /current/path           │
│                                         │
│   [  Cancel  ]   [ Submit Feedback ]    │
│                        🟢               │
└─────────────────────────────────────────┘
```

---

## Critical Styling Requirements

### Selected Emoji State

| Property | Value |
|----------|-------|
| Background | `bg-[#4CD964]/20` (green at 20% opacity) |
| Outline | `ring-2 ring-[#4CD964]` |
| Shape | `rounded-full` (circular) |
| Size | `w-12 h-12` (48px × 48px) |

```html
<!-- Selected emoji button -->
<button class="w-12 h-12 text-2xl rounded-full flex items-center justify-center
               bg-[#4CD964]/20 ring-2 ring-[#4CD964]">
  😐
</button>
```

### Rating Label

| Property | Value |
|----------|-------|
| Color | `text-[#1C1C1E]` (regular text, NOT green) |
| Position | Centered below emoji row |
| Font | Medium weight, small size |

```html
<p class="text-sm text-center text-[#1C1C1E] font-medium">Neutral</p>
```

### Action Buttons

| Button | Styling |
|--------|---------|
| **Cancel** | White bg, gray border, rounded-full |
| **Submit Feedback** | Green `#4CD964` bg, white text, rounded-full |

```html
<!-- Cancel -->
<button class="flex-1 px-6 py-3 bg-white text-[#1C1C1E] font-medium rounded-full
               border border-[#E5E5EA] hover:bg-[#F5F5F7]">
  Cancel
</button>

<!-- Submit -->
<button class="flex-1 px-6 py-3 bg-[#4CD964] hover:bg-[#3DBF55] text-white
               font-semibold rounded-full">
  Submit Feedback
</button>
```

---

## Rating Values

| Rating | Emoji | Label |
|--------|-------|-------|
| 1 | 😞 | Very Dissatisfied |
| 2 | 😟 | Dissatisfied |
| 3 | 😐 | Neutral |
| 4 | 🙂 | Satisfied |
| 5 | 😊 | Very Satisfied |

---

## Data Schema

```typescript
interface FeedbackData {
  rating: 1 | 2 | 3 | 4 | 5;      // Required
  comment?: string;                // Optional
  page_url: string;                // Current page path
  user_id: string | null;          // Auth user ID if available
  user_agent: string;              // Browser info
  viewport: string;                // e.g., "1920x1080"
  timestamp: string;               // ISO 8601
}
```

---

## Common Mistakes to Avoid

| ❌ Wrong | ✅ Correct |
|----------|-----------|
| Green text for rating label | Regular text color |
| Square/rectangular emoji buttons | Circular emoji buttons |
| No visual feedback on selection | Green background + ring |
| Both buttons same color | Cancel gray, Submit green |
| Missing context (page URL) | Show "Feedback for: /path" |

---

## Related Documentation

- **Full Specification**: `docs/i/ui-design/modals-dropdowns.md` (Feedback Modal section)
- **MUI Implementation**: `docs/i/ui-design/material-ui/drawer.md` (Feedback Section)
- **Enforcement Rules**: `.claude/rules/i/material-ui-enforcement.md`
