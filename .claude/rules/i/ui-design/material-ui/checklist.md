# MUI Implementation Checklist & Validation

## Implementation Checklist

When implementing navigation with Material UI:

### Global Navigation Bar (AppBar)
- [ ] **Brand assets** copied from `.claude/assets/i/brand/` to app's public/assets directory
- [ ] **Interactor icon** uses `icon_simple_green_v1.png` from brand icons
- [ ] **Interactor logo** uses Lottie animation (`InteractorLogo_*.json`)
- [ ] **Theme-aware logo**: Light mode uses `InteractorLogo_Light.json`, dark mode uses `InteractorLogo_Dark.json`
- [ ] **Left section** contains (in order): Sidebar toggle, Tools icon, Interactor icon + logo (Lottie)
- [ ] **Center section** contains AI Assistant input field with `flexGrow: 1`
- [ ] **Right section** contains (in order): Notifications, Help, Profile icons
- [ ] Profile icon navigates to full page (`/settings`), NOT a dropdown
- [ ] Notifications icon shows badge with unread count

### Settings/Profile Page (Full Page)
- [ ] Settings page exists at `/settings` or `/profile`
- [ ] Split layout: left sidebar (240px) + main content area
- [ ] Header has "Settings" title with close (✕) button
- [ ] **ACCOUNT section** includes: Profile, Preferences, Notifications
- [ ] **ORGANIZATION section** includes: General, Channels (with count badge), Billing
- [ ] **FEATURES section** includes: Tags, Post Goal
- [ ] **OTHER section** includes: Apps & Extras, Beta Features, Refer a Friend
- [ ] Active item has filled background highlight (not just border)
- [ ] Main content shows form fields with labels above
- [ ] Info banner (blue Alert) at top of content area
- [ ] Form rows: input field + action button (Save Changes)
- [ ] Two Factor Authentication toggle with description
- [ ] Delete Account section with red button at bottom

### Preferences Page (Settings Sub-page)
- [ ] Page title: "Preferences"
- [ ] Settings grouped in Card with rounded corners (`borderRadius: 2`)
- [ ] Each row contains: Title (`fontWeight="medium"`) + Description + Selector
- [ ] Rows separated by Dividers (light gray)
- [ ] **Appearance** setting with theme selector (Light/Dark/System) and sun icon
- [ ] **Timezone** setting with timezone dropdown and globe icon
- [ ] **Time Format** setting (12-hour/24-hour)
- [ ] **Start of Week** setting (Sunday/Monday)
- [ ] **Default Posting Action** setting (Next Available/Custom)
- [ ] Selectors are right-aligned with consistent min-width
- [ ] Descriptions use `color="text.secondary"` and `maxWidth: 500`

### Notifications Page (Settings Sub-page)
- [ ] Page title: "Notifications"
- [ ] **Account activities** section header (`variant="h6"`, `fontWeight="medium"`)
- [ ] Account activities Card with notification rows
- [ ] **From Us** section header below Account activities
- [ ] From Us Card with notification rows
- [ ] Each row contains: Title (`fontWeight="medium"`) + Description + Toggle
- [ ] Rows separated by Dividers (light gray)
- [ ] Toggles (Switch) are right-aligned
- [ ] Cards have rounded corners (`borderRadius: 2`)
- [ ] Section spacing: `mb: 4` between sections, `mb: 2` below headers

**Account Activities Notifications:**
- [ ] Daily Recap
- [ ] Weekly Post Recap
- [ ] Published Post Confirmations
- [ ] Post Failures
- [ ] Empty Queue Alerts
- [ ] Reminders
- [ ] Collaboration
- [ ] Channel Connection Updates
- [ ] Billing and Payment Reminders

**From Us Notifications:**
- [ ] Getting Started
- [ ] User Feedback and Research
- [ ] Product Updates and News

### Left Navigation (Drawer) - Interactor Style

**Active Item Styling**
- [ ] Active indicator: Green left border bar (`4px solid #4CD964`)
- [ ] Active text and icon: Green color (`#4CD964`)
- [ ] Active background: Light green (`rgba(76, 217, 100, 0.1)` or `#E8F8EB`)
- [ ] Inactive text and icons: Gray (`#8E8E93`)

**Section Headers**
- [ ] Typography: `variant="overline"` - uppercase, small, tracked
- [ ] Color: Gray (`text.secondary` or `#8E8E93`)
- [ ] Collapse arrow: ▼ expanded, ▶ collapsed
- [ ] Sections: MANAGE SERVICES, IN-PRODUCT DATA STORAGE, CUSTOM ACTIONS

**Navigation Items**
- [ ] Icons use outlined/stroke style (not filled)
- [ ] Expandable items show expand/collapse arrow on right
- [ ] Sub-items with counts show count right-aligned in gray

**Create Button (Top)** - Optional
- [ ] "+ Create" button at top of drawer
- [ ] Button is orange/primary color, full width
- [ ] Opens dropdown menu with major feature creation options

**Section 1 (Selection-Only Items)** - Optional
- [ ] "For you" item with home icon (no arrow)
- [ ] "Recent", "Starred", "Plans" items with right arrow
- [ ] Dropdown menus open to the RIGHT (not down)
- [ ] Divider separates Section 1 from Section 2

**Section 2 (Expandable Sections)** - Optional
- [ ] WORKSPACES, DASHBOARDS, APPS, FILTERS sections exist
- [ ] Section headers use `variant="overline"` typography
- [ ] Default state: shows section icon
- [ ] Hover state: icon changes to expand arrow
- [ ] Hover state: `+` and `...` icons appear on right
- [ ] `+` opens create dialog for that section
- [ ] `...` opens options menu
- [ ] Sections expand DOWNWARD (not right)
- [ ] Expanded items show avatar with first letter

**Feedback Section (Bottom - Fixed)** - Optional
- [ ] "Feedback" label above emoji row
- [ ] 5 emoji faces: 😞 😟 😐 🙂 😊
- [ ] `flexGrow: 1` spacer pushes feedback to bottom
- [ ] Clicking emoji opens bottom drawer with comment field
- [ ] Comment drawer has Cancel and Submit buttons

---

## Validation

Before completing any MUI navigation implementation, verify:

### AppBar Visual Check
```
┌──────────────────────────────────────────────────────────────────────────┐
│ [≡] [⊞] [🟢][Lottie Logo]    [   Ask AI Assistant...   ]   [🔔] [?] [👤]│
│  ↑    ↑   ↑       ↑                     ↑                    ↑   ↑   ↑   │
│  │    │   │       │                     │                    │   │   │   │
│ Toggle Tools Icon AnimatedLogo      AI Input             Notif Help Prof │
└──────────────────────────────────────────────────────────────────────────┘
```

1. **Left**: Sidebar toggle → Tools → Interactor Icon → Lottie Logo (in that order)
2. **Interactor Icon**: `icon_simple_green_v1.png` from `.claude/assets/i/brand/icons/` (24x24px)
3. **Lottie Logo**: Theme-aware animation from `.claude/assets/i/brand/lottie/InteractorLogo_*.json`
4. **Center**: AI Assistant input field (centered, max-width constrained)
5. **Right**: Notifications → Help → Profile (in that order)
6. **Profile**: Clicking navigates to `/profile` page (no dropdown)

### Settings Page Visual Check
```
┌──────────────────────────────────────────────────────────────────────────┐
│ Settings                                              ✕                  │
├────────────────────┬─────────────────────────────────────────────────────┤
│ ACCOUNT            │  [Page Title]                                       │
│ ┃ Profile     ←    │  ┌─────────────────────────────────────────────────┐│
│   Preferences      │  │ ℹ Info banner (blue Alert)                      ││
│   Notifications    │  └─────────────────────────────────────────────────┘│
│                    │                                                      │
│ ORGANIZATION       │  Label                                              │
│   General          │  ┌────────────────────────┐  ┌──────────────┐       │
│   Channels      2  │  │ Input field            │  │ Save Changes │       │
│   Billing          │  └────────────────────────┘  └──────────────┘       │
│                    │                                                      │
│ FEATURES           │  ─────────────────────────────────────────────────  │
│   Tags             │                                                      │
│   Post Goal        │  Section Title                              [Toggle]│
│                    │  Description text...                                │
│ OTHER              │                                                      │
│   Apps & Extras    │  ─────────────────────────────────────────────────  │
│   Beta Features    │                                                      │
│   Refer a Friend   │  Danger Section                                     │
│                    │  Description text...     ┌─────────────────────┐    │
│                    │                          │   Danger Button     │    │
│                    │                          └─────────────────────┘    │
└────────────────────┴─────────────────────────────────────────────────────┘
```

1. **Layout**: Split layout with 240px sidebar + main content area
2. **Header**: "Settings" title with close (✕) button
3. **Sidebar Sections**: ACCOUNT, ORGANIZATION, FEATURES, OTHER
4. **Active Item**: Filled background highlight on selected item
5. **Form Pattern**: Label above input, action button beside input
6. **Info Banner**: Blue Alert component at top of content
7. **Toggles**: Right-aligned with description text
8. **Danger Zone**: Delete Account section with red button at bottom

### Preferences Page Visual Check
```
┌──────────────────────────────────────────────────────────────────────────┐
│ Preferences                                                              │
│                                                                          │
│ ┌────────────────────────────────────────────────────────────────────┐  │
│ │                                                                    │  │
│ │  Appearance                                        ☀ Light    ▼   │  │
│ │  Customize the look and feel on this device.                      │  │
│ │                                                                    │  │
│ │──────────────────────────────────────────────────────────────────│  │
│ │                                                                    │  │
│ │  Timezone                                    🌐 Los Angeles (PST) ▼│  │
│ │  Used as the default timezone for new connected channels...       │  │
│ │                                                                    │  │
│ │──────────────────────────────────────────────────────────────────│  │
│ │                                                                    │  │
│ │  Time Format                                         24-hour   ▼  │  │
│ │  Set the time format for the Calendar and Queue.                  │  │
│ │                                                                    │  │
│ │  ... more settings ...                                            │  │
│ └────────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────┘
```

1. **Card Container**: Settings in a Card with rounded corners
2. **Row Pattern**: Title + Description (left) | Selector (right)
3. **Title**: `fontWeight="medium"`
4. **Description**: `color="text.secondary"`, limited width
5. **Dividers**: Light gray dividers between each setting row
6. **Selectors**: Right-aligned, consistent width, some with icons

### Notifications Page Visual Check
```
┌──────────────────────────────────────────────────────────────────────────┐
│ Notifications                                                            │
│                                                                          │
│ Account activities                                                       │
│ ┌────────────────────────────────────────────────────────────────────┐  │
│ │                                                                    │  │
│ │  Daily Recap                                               [×━━━] │  │
│ │  Receive a daily summary of post performance...                   │  │
│ │                                                                    │  │
│ │──────────────────────────────────────────────────────────────────│  │
│ │                                                                    │  │
│ │  Weekly Post Recap                                         [×━━━] │  │
│ │  A weekly report on the performance of your channels...           │  │
│ │                                                                    │  │
│ │  ... more notifications ...                                       │  │
│ └────────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│ From Us                                                                  │
│ ┌────────────────────────────────────────────────────────────────────┐  │
│ │                                                                    │  │
│ │  Getting Started                                           [×━━━] │  │
│ │  Useful tips and best practices...                                │  │
│ │                                                                    │  │
│ │  ... more notifications ...                                       │  │
│ └────────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────┘
```

1. **Page Title**: "Notifications" at top
2. **Section Headers**: `variant="h6"`, `fontWeight="medium"` (e.g., "Account activities", "From Us")
3. **Card Containers**: Each section in a Card with rounded corners
4. **Row Pattern**: Title + Description (left) | Toggle Switch (right)
5. **Dividers**: Light gray dividers between each notification row
6. **Toggles**: MUI Switch components, right-aligned
7. **Section Spacing**: `mb: 4` between sections

### Drawer Visual Check
```
┌─────────────────────────────────┐
│  [  + Create  ]                 │  ← Top: Orange button
├─────────────────────────────────┤
│  🏠 For you                     │  ← Section 1: No arrow
│  🕐 Recent                    > │  ← Opens RIGHT
│  ⭐ Starred                   > │
│  📋 Plans                     > │
├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┤
│  📁 WORKSPACES           + ··· │  ← Section 2: Expandable
│  > DASHBOARDS            + ··· │  ← Hover shows + and ...
│  ⊞ APPS                  + ··· │
│  🔽 FILTERS              + ··· │
│                                 │
│         (flex spacer)           │
│                                 │
├─────────────────────────────────┤
│  Feedback                       │  ← Bottom: Fixed
│  😞 😟 😐 🙂 😊                 │  ← Opens comment drawer
└─────────────────────────────────┘
```

1. **Top**: "+ Create" button (orange, full width)
2. **Section 1**: Selection items (For you, Recent, Starred, Plans) - dropdowns open RIGHT
3. **Section 2**: WORKSPACES, DASHBOARDS, APPS, FILTERS - expand DOWN, hover shows + and ...
4. **Bottom**: Feedback emoji faces (fixed position)
5. **Feedback action**: Clicking emoji opens bottom drawer for comments
