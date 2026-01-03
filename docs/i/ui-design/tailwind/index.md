# TailwindCSS Adapter - Interactor Design System

**For all pattern requirements and visual specifications, see [@material-ui/index.md](../material-ui/index.md).**

This adapter provides only the translation mappings from MUI to TailwindCSS classes.

---

## When to Use

Apply this adapter when the project has `tailwind.config.js` or uses TailwindCSS classes.

---

## Color Mappings

See [colors.md](./colors.md) for complete color translation table.

**Quick Reference**:
| Purpose | MUI | TailwindCSS |
|---------|-----|-------------|
| Interactor Green | `#4CD964` | `bg-[#4CD964]` or `bg-interactor-green` |
| Green Hover | `#3DBF55` | `hover:bg-[#3DBF55]` |
| Error Red | `#FF3B30` | `bg-[#FF3B30]` |

---

## Class Translation Table

### Buttons

| MUI Pattern | TailwindCSS Equivalent |
|-------------|------------------------|
| `sx={{ bgcolor: '#4CD964' }}` | `class="bg-[#4CD964]"` |
| `variant="contained"` (green) | `bg-[#4CD964] hover:bg-[#3DBF55] text-white font-medium` |
| `variant="outlined"` | `border border-gray-300 bg-transparent hover:bg-gray-100` |
| `startIcon={<AddIcon />}` | `flex items-center gap-2` + inline SVG |
| `fullWidth` | `w-full` |
| `size="small/medium/large"` | `py-1 px-2` / `py-2 px-4` / `py-3 px-6` |

### Layout & Containers

| MUI Pattern | TailwindCSS Equivalent |
|-------------|------------------------|
| `<Box sx={{ display: 'flex' }}>` | `class="flex"` |
| `<Stack spacing={2}>` | `class="flex flex-col gap-2"` |
| `<Paper elevation={2}>` | `class="bg-white dark:bg-gray-800 rounded-lg shadow"` |
| `<Drawer variant="permanent">` | `class="fixed left-0 top-0 h-screen w-64"` |
| `<AppBar position="fixed">` | `class="fixed top-0 left-0 right-0 h-16"` |

### Icons & Badges

| MUI Pattern | TailwindCSS Equivalent |
|-------------|------------------------|
| `<Badge badgeContent={3}>` | Position with `relative` + `absolute` badge span |
| `<IconButton>` | `class="p-2 rounded-full hover:bg-gray-100"` |
| `<Avatar>` | `class="w-10 h-10 rounded-full"` |

### Form Elements

| MUI Pattern | TailwindCSS Equivalent |
|-------------|------------------------|
| `<TextField variant="outlined">` | `class="border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-[#4CD964]"` |
| `<Select>` | Native select + `class="border rounded-lg px-3 py-2"` |
| `<Switch>` | Custom toggle with `peer` checkbox pattern |

### Dark Mode

| MUI Pattern | TailwindCSS Equivalent |
|-------------|------------------------|
| `theme.palette.mode === 'dark'` | `dark:` prefix classes |
| `sx={{ bgcolor: 'background.paper' }}` | `class="bg-white dark:bg-gray-800"` |
| `sx={{ color: 'text.primary' }}` | `class="text-gray-900 dark:text-white"` |

---

## Setup

### Option A: Arbitrary Values (No Config Change)

Use TailwindCSS arbitrary values directly:
```html
<button class="bg-[#4CD964] hover:bg-[#3DBF55] text-white">Create</button>
```

### Option B: Extend tailwind.config.js

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        'interactor-green': '#4CD964',
        'interactor-green-hover': '#3DBF55',
        'interactor-error': '#FF3B30',
      }
    }
  }
}
```

Then use:
```html
<button class="bg-interactor-green hover:bg-interactor-green-hover text-white">Create</button>
```

---

## Lottie Animation

For Pattern 1 (Lottie Logo), use `lottie-web` or `lottie-react`:

```html
<div id="logo" class="h-8 w-24"></div>
<script>
import lottie from 'lottie-web';
lottie.loadAnimation({
  container: document.getElementById('logo'),
  path: '/brand/lottie/InteractorLogo_Light.json',
  loop: false, autoplay: true
});
</script>
```

---

## Common Validation Errors

| Error | Fix |
|-------|-----|
| Using `bg-primary` for Create button | Use `bg-[#4CD964]` explicitly |
| Using `<img>` for logo | Use Lottie animation |
| Single notification badge | Add second badge for errors |
| Warning at top of drawer | Move warning BELOW the problematic item |
