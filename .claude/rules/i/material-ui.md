# Material UI Design Rules

These rules apply **ONLY** when the project uses Material UI (MUI) as the design system.

---

## Applicability

Apply these rules when:
- `@mui/material` is in `package.json`
- Components import from `@mui/material` or `@mui/icons-material`
- The project explicitly states it uses Material UI/MUI

---

## Navigation Layout Requirements

### Global Navigation Bar (AppBar/Header)

The navigation bar has three distinct sections:

| Section | Elements | Position |
|---------|----------|----------|
| **Left** | Sidebar toggle, Tools icon, Interactor logo | Left-aligned |
| **Center** | AI Assistant input field | Center (flex-grow) |
| **Right** | Notification, Help, Profile icons | Right-aligned |

#### Left Section Elements (in order)

| Element | Icon | Purpose |
|---------|------|---------|
| Sidebar Toggle | `MenuIcon` / `MenuOpenIcon` | Open/close left navigation drawer |
| Tools Selection | `AppsIcon` or `GridViewIcon` | Access tools/applications menu |
| Interactor Logo | Custom logo component | Brand identity, links to home |

#### Center Section

| Element | Component | Purpose |
|---------|-----------|---------|
| AI Assistant Input | `TextField` with `InputAdornment` | Primary AI interaction point |

- Should use `flexGrow: 1` with max-width constraint
- Include search/send icon as adornment
- Placeholder: "Ask AI Assistant..." or similar

#### Right Section Elements (in order)

| Element | Icon | Behavior |
|---------|------|----------|
| Notifications | `NotificationsIcon` | Badge for unread count, opens panel |
| Help | `HelpOutlineIcon` | Opens help/documentation |
| Profile | `AccountCircleIcon` | **Navigates to full Profile page** |

**Important**: Profile is a **full page navigation**, NOT a dropdown menu.

```jsx
// Correct - Global Navigation Bar structure
<AppBar position="fixed">
  <Toolbar>
    {/* LEFT SECTION */}
    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
      <IconButton onClick={toggleDrawer}>
        {drawerOpen ? <MenuOpenIcon /> : <MenuIcon />}
      </IconButton>
      <IconButton>
        <AppsIcon />  {/* Tools selection */}
      </IconButton>
      <InteractorLogo />  {/* Logo with link to home */}
    </Box>

    {/* CENTER SECTION - AI Assistant Input */}
    <Box sx={{ flexGrow: 1, display: 'flex', justifyContent: 'center', mx: 2 }}>
      <TextField
        placeholder="Ask AI Assistant..."
        sx={{ maxWidth: 600, width: '100%' }}
        InputProps={{
          startAdornment: <InputAdornment position="start"><SearchIcon /></InputAdornment>
        }}
      />
    </Box>

    {/* RIGHT SECTION */}
    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
      <IconButton>
        <Badge badgeContent={notificationCount} color="error">
          <NotificationsIcon />
        </Badge>
      </IconButton>
      <IconButton>
        <HelpOutlineIcon />
      </IconButton>
      <IconButton onClick={() => navigate('/profile')}>  {/* Full page, not dropdown */}
        <AccountCircleIcon />
      </IconButton>
    </Box>
  </Toolbar>
</AppBar>
```

### Profile Page Requirements

Profile is a **dedicated full page** (not a dropdown). It must include an Account section with:

| Menu Item | Route | Description |
|-----------|-------|-------------|
| Profile | `/profile` or `/account/profile` | User profile details, avatar, name |
| Preferences | `/preferences` or `/account/preferences` | User settings, theme, language |
| Notifications | `/notifications` or `/account/notifications` | Notification settings and preferences |

```jsx
// Profile page structure
<ProfilePage>
  <AccountSection>
    <List>
      <ListItemButton component={Link} to="/account/profile">
        <ListItemIcon><PersonIcon /></ListItemIcon>
        <ListItemText primary="Profile" />
      </ListItemButton>
      <ListItemButton component={Link} to="/account/preferences">
        <ListItemIcon><SettingsIcon /></ListItemIcon>
        <ListItemText primary="Preferences" />
      </ListItemButton>
      <ListItemButton component={Link} to="/account/notifications">
        <ListItemIcon><NotificationsIcon /></ListItemIcon>
        <ListItemText primary="Notifications" />
      </ListItemButton>
    </List>
  </AccountSection>
  {/* Additional profile content */}
</ProfilePage>
```

### Left Navigation Bar (Drawer/Sidebar)

The left navigation has four distinct zones:

| Zone | Position | Content |
|------|----------|---------|
| **Create Button** | Top (fixed) | "+ Create" button for major features |
| **Section 1** | Below Create | Selection-only items (no create option) |
| **Section 2** | Middle | Expandable sections with create capability |
| **Feedback** | Bottom (fixed) | Emoji feedback faces |

#### Visual Structure
```
┌─────────────────────────────────┐
│  [  + Create  ]                 │  ← Orange button, opens dropdown
├─────────────────────────────────┤
│  🏠 For you                     │  ← No arrow (home/landing)
│  🕐 Recent                    > │  ← Arrow opens dropdown RIGHT
│  ⭐ Starred                   > │  ← Arrow opens dropdown RIGHT
│  📋 Plans                     > │  ← Arrow opens dropdown RIGHT
├─────────────────────────────────┤
│  📁 WORKSPACES           + ··· │  ← Hover shows + and ...
│     RECENT                      │
│     [T] test                    │  ← Selected item highlighted
│                                 │
│  > DASHBOARDS            + ··· │  ← Expandable with + and ...
│                                 │
│  ⊞ APPS                  + ··· │
│                                 │
│  🔽 FILTERS              + ··· │
├─────────────────────────────────┤
│  Feedback                       │
│  😞 😟 😐 🙂 😊                 │  ← Click opens comment section
└─────────────────────────────────┘
```

#### Create Button (Top)

| Property | Value |
|----------|-------|
| Position | Fixed at top of drawer |
| Style | Primary color (orange), full width with padding |
| Icon | `AddIcon` (+) on left |
| Action | Opens dropdown menu with major feature creation options |

```jsx
<Button
  variant="contained"
  color="primary"
  startIcon={<AddIcon />}
  fullWidth
  onClick={handleCreateMenuOpen}
  sx={{ m: 2, borderRadius: 2 }}
>
  Create
</Button>
<Menu anchorEl={createAnchor} open={Boolean(createAnchor)}>
  <MenuItem>New Workspace</MenuItem>
  <MenuItem>New Dashboard</MenuItem>
  <MenuItem>New App</MenuItem>
  {/* Other create options */}
</Menu>
```

#### Section 1: Selection-Only Items

Items that navigate or filter content without create functionality. Dropdown opens to the **right**.

| Item | Icon | Behavior |
|------|------|----------|
| For you | `HomeIcon` | Navigates to home/personalized view |
| Recent | `HistoryIcon` | Arrow on right, dropdown opens RIGHT |
| Starred | `StarIcon` | Arrow on right, dropdown opens RIGHT |
| Plans | `AssignmentIcon` | Arrow on right, dropdown opens RIGHT |

```jsx
{/* Section 1 - Selection only items */}
<List>
  <ListItemButton>
    <ListItemIcon><HomeIcon /></ListItemIcon>
    <ListItemText primary="For you" />
  </ListItemButton>

  <ListItemButton onClick={handleRecentMenuOpen}>
    <ListItemIcon><HistoryIcon /></ListItemIcon>
    <ListItemText primary="Recent" />
    <ChevronRightIcon />  {/* Opens dropdown to the RIGHT */}
  </ListItemButton>

  <ListItemButton onClick={handleStarredMenuOpen}>
    <ListItemIcon><StarIcon /></ListItemIcon>
    <ListItemText primary="Starred" />
    <ChevronRightIcon />
  </ListItemButton>

  <ListItemButton onClick={handlePlansMenuOpen}>
    <ListItemIcon><AssignmentIcon /></ListItemIcon>
    <ListItemText primary="Plans" />
    <ChevronRightIcon />
  </ListItemButton>
</List>
<Divider />
```

#### Section 2: Expandable Sections with Create

Sections that can be expanded and support creating new items. Options expand **downward**.

| Section | Icon (default) | Icon (hover) | Hover Actions |
|---------|----------------|--------------|---------------|
| WORKSPACES | `FolderIcon` | `ExpandMoreIcon` | `+` and `...` appear |
| DASHBOARDS | `DashboardIcon` | `ExpandMoreIcon` | `+` and `...` appear |
| APPS | `AppsIcon` | `ExpandMoreIcon` | `+` and `...` appear |
| FILTERS | `FilterListIcon` | `ExpandMoreIcon` | `+` and `...` appear |

**Hover Behavior:**
- Before hover: Shows section icon
- On hover: Icon changes to expand arrow, `+` and `...` icons appear on right
- `+` icon: Creates new item in that section
- `...` icon: Opens options menu (rename, delete, settings, etc.)

```jsx
{/* Section 2 - Expandable sections with create */}
<List>
  {sections.map((section) => (
    <Box key={section.id}>
      <ListItemButton
        onMouseEnter={() => setHoveredSection(section.id)}
        onMouseLeave={() => setHoveredSection(null)}
        onClick={() => toggleSection(section.id)}
      >
        <ListItemIcon>
          {hoveredSection === section.id ? (
            <ExpandMoreIcon />  {/* Arrow on hover */}
          ) : (
            section.icon  {/* Default icon */}
          )}
        </ListItemIcon>
        <ListItemText
          primary={section.name}
          primaryTypographyProps={{ variant: 'overline' }}
        />

        {/* + and ... icons appear on hover */}
        {hoveredSection === section.id && (
          <Box sx={{ display: 'flex', gap: 0.5 }}>
            <IconButton size="small" onClick={(e) => handleCreate(e, section.id)}>
              <AddIcon fontSize="small" />
            </IconButton>
            <IconButton size="small" onClick={(e) => handleOptions(e, section.id)}>
              <MoreHorizIcon fontSize="small" />
            </IconButton>
          </Box>
        )}
      </ListItemButton>

      {/* Expanded content */}
      <Collapse in={expandedSections.includes(section.id)}>
        {section.subsections?.map((sub) => (
          <Box key={sub.id}>
            <Typography variant="caption" sx={{ pl: 4, color: 'text.secondary' }}>
              {sub.label}
            </Typography>
            <List disablePadding>
              {sub.items.map((item) => (
                <ListItemButton
                  key={item.id}
                  selected={selectedItem === item.id}
                  sx={{ pl: 4 }}
                >
                  <Avatar sx={{ width: 24, height: 24, mr: 1, bgcolor: item.color }}>
                    {item.name.charAt(0).toUpperCase()}
                  </Avatar>
                  <ListItemText primary={item.name} />
                </ListItemButton>
              ))}
            </List>
          </Box>
        ))}
      </Collapse>
    </Box>
  ))}
</List>
```

#### Feedback Section (Bottom - Fixed)

Fixed at the bottom of the drawer. Shows emoji faces for quick feedback.

| Component | Description |
|-----------|-------------|
| Label | "Feedback" text above emoji row |
| Emojis | 5 faces from negative to positive (😞 😟 😐 🙂 😊) |
| Action | Clicking any emoji opens comment section at bottom of screen |

```jsx
{/* Feedback section - fixed at bottom */}
<Box sx={{ flexGrow: 1 }} />  {/* Spacer */}
<Divider />
<Box sx={{ p: 2 }}>
  <Typography variant="caption" color="text.secondary">
    Feedback
  </Typography>
  <Box sx={{ display: 'flex', justifyContent: 'space-around', mt: 1 }}>
    {[
      { icon: '😞', value: 1 },
      { icon: '😟', value: 2 },
      { icon: '😐', value: 3 },
      { icon: '🙂', value: 4 },
      { icon: '😊', value: 5 },
    ].map((feedback) => (
      <IconButton
        key={feedback.value}
        onClick={() => handleFeedbackClick(feedback.value)}
        sx={{
          fontSize: '1.5rem',
          opacity: 0.6,
          '&:hover': { opacity: 1 }
        }}
      >
        {feedback.icon}
      </IconButton>
    ))}
  </Box>
</Box>

{/* Feedback comment drawer - slides up from bottom */}
<Drawer
  anchor="bottom"
  open={feedbackOpen}
  onClose={() => setFeedbackOpen(false)}
>
  <Box sx={{ p: 3 }}>
    <Typography variant="h6">
      {getFeedbackTitle(selectedFeedback)}
    </Typography>
    <TextField
      multiline
      rows={3}
      fullWidth
      placeholder="Tell us more about your experience..."
      value={feedbackComment}
      onChange={(e) => setFeedbackComment(e.target.value)}
      sx={{ mt: 2 }}
    />
    <Box sx={{ mt: 2, display: 'flex', justifyContent: 'flex-end', gap: 1 }}>
      <Button onClick={() => setFeedbackOpen(false)}>Cancel</Button>
      <Button variant="contained" onClick={submitFeedback}>Submit</Button>
    </Box>
  </Box>
</Drawer>
```

---

## Implementation Checklist

When implementing navigation with Material UI:

### Global Navigation Bar (AppBar)
- [ ] **Left section** contains (in order): Sidebar toggle, Tools icon, Interactor logo
- [ ] **Center section** contains AI Assistant input field with `flexGrow: 1`
- [ ] **Right section** contains (in order): Notifications, Help, Profile icons
- [ ] Profile icon navigates to full page (`/profile`), NOT a dropdown
- [ ] Notifications icon shows badge with unread count

### Profile Page
- [ ] Profile page exists at `/profile` or `/account/profile`
- [ ] Account section includes "Profile" menu item
- [ ] Account section includes "Preferences" menu item
- [ ] Account section includes "Notifications" menu item

### Left Navigation (Drawer)

**Create Button (Top)**
- [ ] "+ Create" button at top of drawer
- [ ] Button is orange/primary color, full width
- [ ] Opens dropdown menu with major feature creation options

**Section 1 (Selection-Only Items)**
- [ ] "For you" item with home icon (no arrow)
- [ ] "Recent", "Starred", "Plans" items with right arrow
- [ ] Dropdown menus open to the RIGHT (not down)
- [ ] Divider separates Section 1 from Section 2

**Section 2 (Expandable Sections)**
- [ ] WORKSPACES, DASHBOARDS, APPS, FILTERS sections exist
- [ ] Section headers use `variant="overline"` typography
- [ ] Default state: shows section icon
- [ ] Hover state: icon changes to expand arrow
- [ ] Hover state: `+` and `...` icons appear on right
- [ ] `+` opens create dialog for that section
- [ ] `...` opens options menu
- [ ] Sections expand DOWNWARD (not right)
- [ ] Expanded items show avatar with first letter

**Feedback Section (Bottom - Fixed)**
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
┌─────────────────────────────────────────────────────────────────────┐
│ [≡] [⊞] [Logo]     [   Ask AI Assistant...   ]     [🔔] [?] [👤]  │
│  ↑    ↑    ↑                   ↑                     ↑   ↑   ↑     │
│  │    │    │                   │                     │   │   │     │
│ Toggle Tools Logo         AI Input              Notif Help Profile │
└─────────────────────────────────────────────────────────────────────┘
```

1. **Left**: Sidebar toggle → Tools → Logo (in that order)
2. **Center**: AI Assistant input field (centered, max-width constrained)
3. **Right**: Notifications → Help → Profile (in that order)
4. **Profile**: Clicking navigates to `/profile` page (no dropdown)

### Profile Page Check
```
Profile Page must contain Account section with:
├── Profile (user details)
├── Preferences (settings)
└── Notifications (notification settings)
```

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
