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

### Profile Page Requirements (Full Settings Page)

Profile/Settings is a **dedicated full page** with a left sidebar navigation and main content area.

#### Example Layout Structure
```
┌────────────────────┬─────────────────────────────────────────────────────┐
│ Settings      ✕    │                                                     │
│                    │                                                     │
│ ACCOUNT            │  Profile                                            │
│   Profile     ←    │  ┌─────────────────────────────────────────────────┐│
│   Preferences      │  │ ℹ Add a backup email to your account as an     ││
│   Notifications    │  │   additional security measure                   ││
│                    │  └─────────────────────────────────────────────────┘│
│ ORGANIZATION       │                                                      │
│   General          │  Email                                              │
│   Channels      2  │  ┌────────────────────────────┐  ┌──────────────┐  │
│   Billing          │  │ dev@example.com            │  │ Save Changes │  │
│                    │  └────────────────────────────┘  └──────────────┘  │
│ FEATURES           │                                                      │
│   Tags             │  Backup Email                                       │
│   Post Goal        │  ┌────────────────────────────┐  ┌──────────────┐  │
│                    │  │ backup@email.com           │  │ Save Changes │  │
│ OTHER              │  └────────────────────────────┘  └──────────────┘  │
│   Apps & Extras    │                                                      │
│   Beta Features    │  Password                                           │
│   Refer a Friend   │  ┌────────────────────────────┐  ┌─────────────────┐│
│                    │  │ New password               │  │ Change Password ││
│                    │  └────────────────────────────┘  └─────────────────┘│
│                    │  ─────────────────────────────────────────────────  │
│                    │                                                      │
│                    │  Two Factor Authentication                    [○━━] │
│                    │  Two factor authentication adds an extra layer...   │
│                    │                                                      │
│                    │  ─────────────────────────────────────────────────  │
│                    │                                                      │
│                    │  Delete your account                                │
│                    │  When you delete your account, you lose access...   │
│                    │                              ┌─────────────────────┐│
│                    │                              │   Delete Account    ││
│                    │                              └─────────────────────┘│
└────────────────────┴─────────────────────────────────────────────────────┘
```

#### Settings Sidebar Sections

| Section | Menu Items | Description |
|---------|------------|-------------|
| **ACCOUNT** | Profile, Preferences, Notifications | User account settings |
| **ORGANIZATION** | General, Channels, Billing | Organization-level settings |
| **FEATURES** | Tags, Post Goal | Feature-specific settings |
| **OTHER** | Apps & Extras, Beta Features, Refer a Friend | Miscellaneous settings |

#### Active Item Styling

| Property | Value |
|----------|-------|
| Active indicator | Green left border bar (`borderLeft: 4px solid #4CD964`) |
| Active text | Green color (`#4CD964`) or primary color |
| Active background | Light green tint or transparent |
| Badge (count) | Gray text, right-aligned |

```jsx
// Settings page structure
const SettingsPage = () => {
  return (
    <Box sx={{ display: 'flex', minHeight: '100vh' }}>
      {/* Settings Sidebar */}
      <Box sx={{ width: 240, borderRight: 1, borderColor: 'divider' }}>
        {/* Header with close button */}
        <Box sx={{ p: 2, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <Typography variant="h6">Settings</Typography>
          <IconButton onClick={handleClose}>
            <CloseIcon />
          </IconButton>
        </Box>

        {/* ACCOUNT Section */}
        <Typography variant="overline" sx={{ px: 2, color: 'text.secondary' }}>
          ACCOUNT
        </Typography>
        <List disablePadding>
          <ListItemButton
            selected={activeTab === 'profile'}
            onClick={() => setActiveTab('profile')}
            sx={{
              borderLeft: activeTab === 'profile' ? '4px solid #4CD964' : '4px solid transparent',
              '&.Mui-selected': { color: '#4CD964', bgcolor: 'transparent' }
            }}
          >
            <ListItemIcon><PersonIcon /></ListItemIcon>
            <ListItemText primary="Profile" />
          </ListItemButton>
          <ListItemButton selected={activeTab === 'preferences'}>
            <ListItemIcon><SettingsIcon /></ListItemIcon>
            <ListItemText primary="Preferences" />
          </ListItemButton>
          <ListItemButton selected={activeTab === 'notifications'}>
            <ListItemIcon><NotificationsIcon /></ListItemIcon>
            <ListItemText primary="Notifications" />
          </ListItemButton>
        </List>

        {/* ORGANIZATION Section */}
        <Typography variant="overline" sx={{ px: 2, mt: 2, color: 'text.secondary' }}>
          ORGANIZATION
        </Typography>
        <List disablePadding>
          <ListItemButton>
            <ListItemIcon><BusinessIcon /></ListItemIcon>
            <ListItemText primary="General" />
          </ListItemButton>
          <ListItemButton>
            <ListItemIcon><ForumIcon /></ListItemIcon>
            <ListItemText primary="Channels" />
            <Typography variant="body2" color="text.secondary">2</Typography>
          </ListItemButton>
          <ListItemButton>
            <ListItemIcon><PaymentIcon /></ListItemIcon>
            <ListItemText primary="Billing" />
          </ListItemButton>
        </List>

        {/* FEATURES Section */}
        <Typography variant="overline" sx={{ px: 2, mt: 2, color: 'text.secondary' }}>
          FEATURES
        </Typography>
        <List disablePadding>
          <ListItemButton>
            <ListItemIcon><LocalOfferIcon /></ListItemIcon>
            <ListItemText primary="Tags" />
          </ListItemButton>
          <ListItemButton>
            <ListItemIcon><TrackChangesIcon /></ListItemIcon>
            <ListItemText primary="Post Goal" />
          </ListItemButton>
        </List>

        {/* OTHER Section */}
        <Typography variant="overline" sx={{ px: 2, mt: 2, color: 'text.secondary' }}>
          OTHER
        </Typography>
        <List disablePadding>
          <ListItemButton>
            <ListItemIcon><ExtensionIcon /></ListItemIcon>
            <ListItemText primary="Apps & Extras" />
          </ListItemButton>
          <ListItemButton>
            <ListItemIcon><ScienceIcon /></ListItemIcon>
            <ListItemText primary="Beta Features" />
          </ListItemButton>
          <ListItemButton>
            <ListItemIcon><CardGiftcardIcon /></ListItemIcon>
            <ListItemText primary="Refer a Friend" />
          </ListItemButton>
        </List>
      </Box>

      {/* Main Content Area */}
      <Box sx={{ flex: 1, p: 4 }}>
        <Typography variant="h5" gutterBottom>Profile</Typography>

        {/* Info Banner */}
        <Alert severity="info" sx={{ mb: 3, borderRadius: 1 }}>
          Add a backup email to your account as an additional security measure
        </Alert>

        {/* Email Field */}
        <Box sx={{ mb: 3 }}>
          <Typography variant="body2" color="text.secondary" gutterBottom>
            Email
          </Typography>
          <Box sx={{ display: 'flex', gap: 2 }}>
            <TextField value={email} fullWidth sx={{ maxWidth: 400 }} />
            <Button variant="outlined">Save Changes</Button>
          </Box>
        </Box>

        {/* Backup Email Field */}
        <Box sx={{ mb: 3 }}>
          <Typography variant="body2" color="text.secondary" gutterBottom>
            Backup Email
          </Typography>
          <Box sx={{ display: 'flex', gap: 2 }}>
            <TextField placeholder="backup@email.com" fullWidth sx={{ maxWidth: 400 }} />
            <Button variant="outlined">Save Changes</Button>
          </Box>
        </Box>

        {/* Password Field */}
        <Box sx={{ mb: 3 }}>
          <Typography variant="body2" color="text.secondary" gutterBottom>
            Password
          </Typography>
          <Box sx={{ display: 'flex', gap: 2 }}>
            <TextField type="password" placeholder="New password" fullWidth sx={{ maxWidth: 400 }} />
            <Button variant="outlined">Change Password</Button>
          </Box>
        </Box>

        <Divider sx={{ my: 4 }} />

        {/* Two Factor Authentication */}
        <Box sx={{ mb: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="subtitle1" fontWeight="medium">
                Two Factor Authentication
              </Typography>
              <Typography variant="body2" color="text.secondary" sx={{ maxWidth: 600 }}>
                Two factor authentication adds an extra layer of security for your account.
                Whenever you log in to your account, after entering your username and password,
                you will be asked for a second authentication code that will be sent to you
                via email or generated on an authentication app, such as Google Authenticator or Authy.
              </Typography>
            </Box>
            <Switch />
          </Box>
        </Box>

        <Divider sx={{ my: 4 }} />

        {/* Delete Account */}
        <Box>
          <Typography variant="subtitle1" fontWeight="medium" gutterBottom>
            Delete your account
          </Typography>
          <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
            When you delete your account, you lose access to account services, and we
            permanently delete your personal data.
          </Typography>
          <Button variant="contained" color="error">
            Delete Account
          </Button>
        </Box>
      </Box>
    </Box>
  );
};
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

#### AutoFlow Left Navigation Design

The AutoFlow left navigation follows a clean, sectioned design with collapsible groups.

##### Visual Structure (AutoFlow Style)
```
┌─────────────────────────────────┐
│  🔲 Solution                     │  ← Top-level nav item (grid icon)
├─────────────────────────────────┤
│  MANAGE SERVICES            ▼   │  ← Section header (collapsible)
│  ┃ 🖥️ Servers                   │  ← Active item (green left bar)
│    ⏱️ Timers                     │
│    🔗 Connections                │
│    📁 Files                      │
├─────────────────────────────────┤
│  IN-PRODUCT DATA STORAGE    ▼   │  ← Section header
│  ┃ 🖥️ Servers                   │  ← Active item (green left bar)
│    📊 Schemas                    │
│    🔀 Flows                      │
├─────────────────────────────────┤
│  CUSTOM ACTIONS             ▶   │  ← Collapsed section
│  ┃ 📋 Tables                ▼   │  ← Active + expandable
│       In Progress           8   │  ← Sub-item with count
│       Pending               4   │
│       Completed            12   │
└─────────────────────────────────┘
```

##### Active Item Styling (AutoFlow)

| Property | Value |
|----------|-------|
| Active indicator | Green left border bar (`borderLeft: 4px solid #4CD964`) |
| Active text | Green color (`color: #4CD964`) |
| Active icon | Green color |
| Active background | Light green (`rgba(76, 217, 100, 0.1)`) or `#E8F8EB` |
| Inactive text | Gray (`#8E8E93`) |
| Inactive icon | Gray (`#8E8E93`) |

##### Section Headers

| Property | Value |
|----------|-------|
| Typography | `variant="overline"` - uppercase, small, tracked |
| Color | Gray (`text.secondary` or `#8E8E93`) |
| Collapse arrow | Down arrow (▼) when expanded, right arrow (▶) when collapsed |
| Spacing | `py: 2, mt: 4` above each section |

##### Icons (AutoFlow Style)

| Property | Value |
|----------|-------|
| Style | Outlined/stroke icons (not filled) |
| Stroke width | `1.5` for normal icons |
| Size | `w-5 h-5` (20px) for navigation items |
| Default color | Gray (`#8E8E93`) |
| Active color | Green (`#4CD964`) |

```jsx
// AutoFlow-style Left Navigation
const AutoFlowDrawer = () => {
  return (
    <Drawer
      variant="permanent"
      sx={{
        width: 256,
        '& .MuiDrawer-paper': {
          width: 256,
          bgcolor: 'background.paper',
          borderRight: 1,
          borderColor: 'divider'
        }
      }}
    >
      {/* Top-level Navigation Item */}
      <List>
        <ListItemButton>
          <ListItemIcon>
            <GridViewIcon sx={{ color: '#8E8E93' }} />
          </ListItemIcon>
          <ListItemText primary="Solution" />
        </ListItemButton>
      </List>

      {/* Section: MANAGE SERVICES */}
      <Box sx={{ mt: 2 }}>
        <ListItemButton onClick={() => toggleSection('manage-services')}>
          <ListItemText
            primary="MANAGE SERVICES"
            primaryTypographyProps={{
              variant: 'overline',
              color: 'text.secondary',
              fontWeight: 600,
              letterSpacing: 1.2
            }}
          />
          {expandedSections.includes('manage-services') ? (
            <ExpandMoreIcon sx={{ color: '#8E8E93' }} />
          ) : (
            <ChevronRightIcon sx={{ color: '#8E8E93' }} />
          )}
        </ListItemButton>

        <Collapse in={expandedSections.includes('manage-services')}>
          <List disablePadding>
            {/* Active Item - with green left border */}
            <ListItemButton
              selected={activeItem === 'servers'}
              sx={{
                borderLeft: activeItem === 'servers' ? '4px solid #4CD964' : '4px solid transparent',
                bgcolor: activeItem === 'servers' ? 'rgba(76, 217, 100, 0.1)' : 'transparent',
                '&.Mui-selected': {
                  bgcolor: 'rgba(76, 217, 100, 0.1)',
                },
                '&.Mui-selected .MuiListItemIcon-root': {
                  color: '#4CD964',
                },
                '&.Mui-selected .MuiListItemText-primary': {
                  color: '#4CD964',
                  fontWeight: 500,
                }
              }}
            >
              <ListItemIcon>
                <DnsIcon sx={{ color: activeItem === 'servers' ? '#4CD964' : '#8E8E93' }} />
              </ListItemIcon>
              <ListItemText primary="Servers" />
            </ListItemButton>

            {/* Inactive Items */}
            <ListItemButton sx={{ borderLeft: '4px solid transparent' }}>
              <ListItemIcon>
                <TimerIcon sx={{ color: '#8E8E93' }} />
              </ListItemIcon>
              <ListItemText primary="Timers" sx={{ color: '#8E8E93' }} />
            </ListItemButton>

            <ListItemButton sx={{ borderLeft: '4px solid transparent' }}>
              <ListItemIcon>
                <LinkIcon sx={{ color: '#8E8E93' }} />
              </ListItemIcon>
              <ListItemText primary="Connections" sx={{ color: '#8E8E93' }} />
            </ListItemButton>

            <ListItemButton sx={{ borderLeft: '4px solid transparent' }}>
              <ListItemIcon>
                <FolderIcon sx={{ color: '#8E8E93' }} />
              </ListItemIcon>
              <ListItemText primary="Files" sx={{ color: '#8E8E93' }} />
            </ListItemButton>
          </List>
        </Collapse>
      </Box>

      {/* Section: IN-PRODUCT DATA STORAGE */}
      <Box sx={{ mt: 2 }}>
        <ListItemButton onClick={() => toggleSection('data-storage')}>
          <ListItemText
            primary="IN-PRODUCT DATA STORAGE"
            primaryTypographyProps={{
              variant: 'overline',
              color: 'text.secondary',
              fontWeight: 600,
              letterSpacing: 1.2
            }}
          />
          <ExpandMoreIcon sx={{ color: '#8E8E93' }} />
        </ListItemButton>

        <Collapse in={expandedSections.includes('data-storage')}>
          <List disablePadding>
            <ListItemButton
              selected={activeItem === 'data-servers'}
              sx={{
                borderLeft: activeItem === 'data-servers' ? '4px solid #4CD964' : '4px solid transparent',
                bgcolor: activeItem === 'data-servers' ? 'rgba(76, 217, 100, 0.1)' : 'transparent',
              }}
            >
              <ListItemIcon>
                <StorageIcon sx={{ color: activeItem === 'data-servers' ? '#4CD964' : '#8E8E93' }} />
              </ListItemIcon>
              <ListItemText primary="Servers" />
            </ListItemButton>

            <ListItemButton sx={{ borderLeft: '4px solid transparent' }}>
              <ListItemIcon>
                <TableChartIcon sx={{ color: '#8E8E93' }} />
              </ListItemIcon>
              <ListItemText primary="Schemas" />
            </ListItemButton>

            <ListItemButton sx={{ borderLeft: '4px solid transparent' }}>
              <ListItemIcon>
                <AccountTreeIcon sx={{ color: '#8E8E93' }} />
              </ListItemIcon>
              <ListItemText primary="Flows" />
            </ListItemButton>
          </List>
        </Collapse>
      </Box>

      {/* Section: CUSTOM ACTIONS - with expandable sub-item */}
      <Box sx={{ mt: 2 }}>
        <ListItemButton onClick={() => toggleSection('custom-actions')}>
          <ListItemText
            primary="CUSTOM ACTIONS"
            primaryTypographyProps={{
              variant: 'overline',
              color: 'text.secondary',
              fontWeight: 600,
              letterSpacing: 1.2
            }}
          />
          <ChevronRightIcon sx={{ color: '#8E8E93' }} />
        </ListItemButton>

        <Collapse in={expandedSections.includes('custom-actions')}>
          <List disablePadding>
            {/* Expandable item with sub-items */}
            <ListItemButton
              selected={activeItem === 'tables'}
              onClick={() => toggleSubSection('tables')}
              sx={{
                borderLeft: activeItem === 'tables' ? '4px solid #4CD964' : '4px solid transparent',
                bgcolor: activeItem === 'tables' ? 'rgba(76, 217, 100, 0.1)' : 'transparent',
              }}
            >
              <ListItemIcon>
                <GridOnIcon sx={{ color: activeItem === 'tables' ? '#4CD964' : '#8E8E93' }} />
              </ListItemIcon>
              <ListItemText primary="Tables" />
              {expandedSubSections.includes('tables') ? (
                <ExpandMoreIcon sx={{ color: '#8E8E93' }} />
              ) : (
                <ChevronRightIcon sx={{ color: '#8E8E93' }} />
              )}
            </ListItemButton>

            {/* Sub-items with counts */}
            <Collapse in={expandedSubSections.includes('tables')}>
              <List disablePadding>
                <ListItemButton sx={{ pl: 6, borderLeft: '4px solid transparent' }}>
                  <ListItemText primary="In Progress" />
                  <Typography variant="body2" color="text.secondary">8</Typography>
                </ListItemButton>
                <ListItemButton sx={{ pl: 6, borderLeft: '4px solid transparent' }}>
                  <ListItemText primary="Pending" />
                  <Typography variant="body2" color="text.secondary">4</Typography>
                </ListItemButton>
                <ListItemButton sx={{ pl: 6, borderLeft: '4px solid transparent' }}>
                  <ListItemText primary="Completed" />
                  <Typography variant="body2" color="text.secondary">12</Typography>
                </ListItemButton>
              </List>
            </Collapse>
          </List>
        </Collapse>
      </Box>
    </Drawer>
  );
};
```

---

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
- [ ] Active item has green left border bar (`borderLeft: 4px solid #4CD964`)
- [ ] Main content shows form fields with labels above
- [ ] Info banner (blue Alert) at top of content area
- [ ] Form rows: input field + action button (Save Changes)
- [ ] Two Factor Authentication toggle with description
- [ ] Delete Account section with red button at bottom

### Left Navigation (Drawer) - AutoFlow Style

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
4. **Active Item**: Green left border bar (`4px solid #4CD964`)
5. **Form Pattern**: Label above input, action button beside input
6. **Info Banner**: Blue Alert component at top of content
7. **Toggles**: Right-aligned with description text
8. **Danger Zone**: Delete Account section with red button at bottom

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
