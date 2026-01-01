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

### Preferences Page

The Preferences page shows user preference settings with dropdown selectors.

#### Layout Structure
```
┌──────────────────────────────────────────────────────────────────────────┐
│ Preferences                                                              │
│                                                                          │
│ ┌────────────────────────────────────────────────────────────────────┐  │
│ │                                                                    │  │
│ │  Appearance                                        ☀ Light    ▼   │  │
│ │  Customize the look and feel on this device.                      │  │
│ │                                                                    │  │
│ │─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │  │
│ │                                                                    │  │
│ │  Timezone                                    🌐 Los Angeles (PST) ▼│  │
│ │  Used as the default timezone for new connected channels...       │  │
│ │                                                                    │  │
│ │─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │  │
│ │                                                                    │  │
│ │  Time Format                                         24-hour   ▼  │  │
│ │  Set the time format for the Calendar and Queue.                  │  │
│ │                                                                    │  │
│ │─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │  │
│ │                                                                    │  │
│ │  Start of Week                                        Monday   ▼  │  │
│ │  Set the first day of the week for the Calendar, date picker...   │  │
│ │                                                                    │  │
│ │─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │  │
│ │                                                                    │  │
│ │  Default Posting Action                         Next Available ▼  │  │
│ │  Set a default time to post for the composer...                   │  │
│ │                                                                    │  │
│ └────────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────┘
```

#### Preference Row Component Pattern

| Element | Styling |
|---------|---------|
| Container | Card with rounded corners, subtle border |
| Row separator | Divider between rows (light gray) |
| Title | `variant="body1"`, `fontWeight="medium"` |
| Description | `variant="body2"`, `color="text.secondary"` |
| Selector | `Select` component, right-aligned, min-width for consistency |

#### Common Preference Settings

| Setting | Description | Selector Options |
|---------|-------------|------------------|
| Appearance | Theme mode | Light, Dark, System |
| Timezone | Default timezone | Timezone list with globe icon |
| Time Format | Clock format | 12-hour, 24-hour |
| Start of Week | Calendar start | Sunday, Monday |
| Default Posting Action | Composer default | Next Available, Custom time |

```jsx
// Preferences page structure
const PreferencesPage = () => {
  return (
    <Box sx={{ flex: 1, p: 4 }}>
      <Typography variant="h5" gutterBottom>Preferences</Typography>

      <Card sx={{ borderRadius: 2 }}>
        {/* Appearance Setting */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Appearance
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Customize the look and feel on this device.
              </Typography>
            </Box>
            <Select
              value={appearance}
              onChange={(e) => setAppearance(e.target.value)}
              size="small"
              sx={{ minWidth: 150 }}
              startAdornment={
                <InputAdornment position="start">
                  <LightModeIcon fontSize="small" />
                </InputAdornment>
              }
            >
              <MenuItem value="light">Light</MenuItem>
              <MenuItem value="dark">Dark</MenuItem>
              <MenuItem value="system">System</MenuItem>
            </Select>
          </Box>
        </Box>

        <Divider />

        {/* Timezone Setting */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Timezone
              </Typography>
              <Typography variant="body2" color="text.secondary" sx={{ maxWidth: 500 }}>
                Used as the default timezone for new connected channels and for sending
                email notifications. Also used for calculating your posting streaks.
              </Typography>
            </Box>
            <Select
              value={timezone}
              onChange={(e) => setTimezone(e.target.value)}
              size="small"
              sx={{ minWidth: 180 }}
              startAdornment={
                <InputAdornment position="start">
                  <PublicIcon fontSize="small" />
                </InputAdornment>
              }
            >
              <MenuItem value="America/Los_Angeles">Los Angeles (PST)</MenuItem>
              <MenuItem value="America/New_York">New York (EST)</MenuItem>
              {/* Other timezone options */}
            </Select>
          </Box>
        </Box>

        <Divider />

        {/* Time Format Setting */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Time Format
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Set the time format for the Calendar and Queue.
              </Typography>
            </Box>
            <Select
              value={timeFormat}
              onChange={(e) => setTimeFormat(e.target.value)}
              size="small"
              sx={{ minWidth: 120 }}
            >
              <MenuItem value="12h">12-hour</MenuItem>
              <MenuItem value="24h">24-hour</MenuItem>
            </Select>
          </Box>
        </Box>

        <Divider />

        {/* Start of Week Setting */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Start of Week
              </Typography>
              <Typography variant="body2" color="text.secondary" sx={{ maxWidth: 500 }}>
                Set the first day of the week for the Calendar, date picker, and your posting streaks.
              </Typography>
            </Box>
            <Select
              value={startOfWeek}
              onChange={(e) => setStartOfWeek(e.target.value)}
              size="small"
              sx={{ minWidth: 120 }}
            >
              <MenuItem value="sunday">Sunday</MenuItem>
              <MenuItem value="monday">Monday</MenuItem>
            </Select>
          </Box>
        </Box>

        <Divider />

        {/* Default Posting Action Setting */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Default Posting Action
              </Typography>
              <Typography variant="body2" color="text.secondary" sx={{ maxWidth: 500 }}>
                Set a default time to post for the composer. We will use it whenever the
                composer is triggered without a specific time.
              </Typography>
            </Box>
            <Select
              value={postingAction}
              onChange={(e) => setPostingAction(e.target.value)}
              size="small"
              sx={{ minWidth: 150 }}
            >
              <MenuItem value="next">Next Available</MenuItem>
              <MenuItem value="custom">Custom Time</MenuItem>
            </Select>
          </Box>
        </Box>
      </Card>
    </Box>
  );
};
```

### Notifications Page

The Notifications page shows notification settings organized by category with toggle switches.

#### Layout Structure
```
┌──────────────────────────────────────────────────────────────────────────┐
│ Notifications                                                            │
│                                                                          │
│ Account activities                                                       │
│ ┌────────────────────────────────────────────────────────────────────┐  │
│ │                                                                    │  │
│ │  Daily Recap                                               [×━━━] │  │
│ │  Receive a daily summary of post performance, comments...         │  │
│ │                                                                    │  │
│ │─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │  │
│ │                                                                    │  │
│ │  Weekly Post Recap                                         [×━━━] │  │
│ │  A weekly report on the performance of your channels...           │  │
│ │                                                                    │  │
│ │─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │  │
│ │                                                                    │  │
│ │  Published Post Confirmations                              [×━━━] │  │
│ │  Receive an email for any post that is successfully published...  │  │
│ │                                                                    │  │
│ │  ... more notification rows ...                                   │  │
│ └────────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│ From Us                                                                  │
│ ┌────────────────────────────────────────────────────────────────────┐  │
│ │                                                                    │  │
│ │  Getting Started                                           [×━━━] │  │
│ │  Useful tips and best practices for getting the most out...       │  │
│ │                                                                    │  │
│ │  ... more notification rows ...                                   │  │
│ └────────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────┘
```

#### Notification Row Component Pattern

| Element | Styling |
|---------|---------|
| Section header | `variant="h6"`, `fontWeight="medium"`, `mb: 2` |
| Container | Card with rounded corners, subtle border |
| Row separator | Divider between rows (light gray) |
| Title | `variant="body1"`, `fontWeight="medium"` |
| Description | `variant="body2"`, `color="text.secondary"` |
| Toggle | `Switch` component, right-aligned |

#### Notification Categories

**Account Activities:**
| Notification | Description |
|--------------|-------------|
| Daily Recap | Daily summary of post performance, comments, and schedule |
| Weekly Post Recap | Weekly report on channel and post performance |
| Published Post Confirmations | Email when posts are successfully published |
| Post Failures | Email when a post fails to publish |
| Empty Queue Alerts | Alert when no content is scheduled |
| Reminders | Reminders to post and build content habit |
| Collaboration | Team member contribution notifications |
| Channel Connection Updates | Channel connection status changes |
| Billing and Payment Reminders | Billing-related emails |

**From Us:**
| Notification | Description |
|--------------|-------------|
| Getting Started | Tips and best practices |
| User Feedback and Research | Participation in feedback and research |
| Product Updates and News | New features and announcements |

```jsx
// Notifications page structure
const NotificationsPage = () => {
  return (
    <Box sx={{ flex: 1, p: 4 }}>
      <Typography variant="h5" gutterBottom>Notifications</Typography>

      {/* Account Activities Section */}
      <Typography variant="h6" fontWeight="medium" sx={{ mb: 2 }}>
        Account activities
      </Typography>

      <Card sx={{ borderRadius: 2, mb: 4 }}>
        {/* Daily Recap */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Daily Recap
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Receive a daily summary of post performance, comments, and what's scheduled next.
              </Typography>
            </Box>
            <Switch
              checked={notifications.dailyRecap}
              onChange={(e) => setNotifications({ ...notifications, dailyRecap: e.target.checked })}
            />
          </Box>
        </Box>

        <Divider />

        {/* Weekly Post Recap */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Weekly Post Recap
              </Typography>
              <Typography variant="body2" color="text.secondary">
                A weekly report on the performance of your channels and posts.
              </Typography>
            </Box>
            <Switch
              checked={notifications.weeklyRecap}
              onChange={(e) => setNotifications({ ...notifications, weeklyRecap: e.target.checked })}
            />
          </Box>
        </Box>

        <Divider />

        {/* Published Post Confirmations */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Published Post Confirmations
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Receive an email for any post that is successfully published to one of your channels.
              </Typography>
            </Box>
            <Switch
              checked={notifications.postConfirmations}
              onChange={(e) => setNotifications({ ...notifications, postConfirmations: e.target.checked })}
            />
          </Box>
        </Box>

        <Divider />

        {/* Post Failures */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Post Failures
              </Typography>
              <Typography variant="body2" color="text.secondary">
                An email if a post in your queue fails to be published.
              </Typography>
            </Box>
            <Switch
              checked={notifications.postFailures}
              onChange={(e) => setNotifications({ ...notifications, postFailures: e.target.checked })}
            />
          </Box>
        </Box>

        <Divider />

        {/* Empty Queue Alerts */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Empty Queue Alerts
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Receive an alert when you have no more content scheduled for one of your channels.
              </Typography>
            </Box>
            <Switch
              checked={notifications.emptyQueue}
              onChange={(e) => setNotifications({ ...notifications, emptyQueue: e.target.checked })}
            />
          </Box>
        </Box>

        <Divider />

        {/* Reminders */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Reminders
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Receive reminders to post and build a consistent content creation habit.
              </Typography>
            </Box>
            <Switch
              checked={notifications.reminders}
              onChange={(e) => setNotifications({ ...notifications, reminders: e.target.checked })}
            />
          </Box>
        </Box>

        <Divider />

        {/* Collaboration */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Collaboration
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Emails about contributions from team members. For example, if a post is awaiting approval.
              </Typography>
            </Box>
            <Switch
              checked={notifications.collaboration}
              onChange={(e) => setNotifications({ ...notifications, collaboration: e.target.checked })}
            />
          </Box>
        </Box>

        <Divider />

        {/* Channel Connection Updates */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Channel Connection Updates
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Emails about your connected channels. For example, when a channel is disconnected.
              </Typography>
            </Box>
            <Switch
              checked={notifications.channelUpdates}
              onChange={(e) => setNotifications({ ...notifications, channelUpdates: e.target.checked })}
            />
          </Box>
        </Box>

        <Divider />

        {/* Billing and Payment Reminders */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Billing and Payment Reminders
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Emails relating to billing and payment reminders.
              </Typography>
            </Box>
            <Switch
              checked={notifications.billing}
              onChange={(e) => setNotifications({ ...notifications, billing: e.target.checked })}
            />
          </Box>
        </Box>
      </Card>

      {/* From Us Section */}
      <Typography variant="h6" fontWeight="medium" sx={{ mb: 2 }}>
        From Us
      </Typography>

      <Card sx={{ borderRadius: 2 }}>
        {/* Getting Started */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Getting Started
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Useful tips and best practices for getting the most out of the platform.
              </Typography>
            </Box>
            <Switch
              checked={notifications.gettingStarted}
              onChange={(e) => setNotifications({ ...notifications, gettingStarted: e.target.checked })}
            />
          </Box>
        </Box>

        <Divider />

        {/* User Feedback and Research */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                User Feedback and Research
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Emails to participate in user feedback and research to help make the platform better.
              </Typography>
            </Box>
            <Switch
              checked={notifications.feedback}
              onChange={(e) => setNotifications({ ...notifications, feedback: e.target.checked })}
            />
          </Box>
        </Box>

        <Divider />

        {/* Product Updates and News */}
        <Box sx={{ p: 3 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                Product Updates and News
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Occasional emails to help you get the most out of the platform, including new features and product announcements.
              </Typography>
            </Box>
            <Switch
              checked={notifications.productUpdates}
              onChange={(e) => setNotifications({ ...notifications, productUpdates: e.target.checked })}
            />
          </Box>
        </Box>
      </Card>
    </Box>
  );
};
```

### Reusable Settings Row Components

For consistency across all settings pages (Profile, Preferences, Notifications), use these reusable patterns:

#### SettingsRowWithInput (Profile page pattern)
```jsx
const SettingsRowWithInput = ({ label, value, onChange, buttonText, buttonAction }) => (
  <Box sx={{ mb: 3 }}>
    <Typography variant="body2" color="text.secondary" gutterBottom>
      {label}
    </Typography>
    <Box sx={{ display: 'flex', gap: 2 }}>
      <TextField value={value} onChange={onChange} fullWidth sx={{ maxWidth: 400 }} />
      <Button variant="outlined" onClick={buttonAction}>{buttonText}</Button>
    </Box>
  </Box>
);
```

#### SettingsRowWithSelect (Preferences page pattern)
```jsx
const SettingsRowWithSelect = ({ title, description, value, onChange, options, icon }) => (
  <Box sx={{ p: 3 }}>
    <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
      <Box>
        <Typography variant="body1" fontWeight="medium">{title}</Typography>
        <Typography variant="body2" color="text.secondary" sx={{ maxWidth: 500 }}>
          {description}
        </Typography>
      </Box>
      <Select
        value={value}
        onChange={onChange}
        size="small"
        sx={{ minWidth: 150 }}
        startAdornment={icon && <InputAdornment position="start">{icon}</InputAdornment>}
      >
        {options.map((opt) => (
          <MenuItem key={opt.value} value={opt.value}>{opt.label}</MenuItem>
        ))}
      </Select>
    </Box>
  </Box>
);
```

#### SettingsRowWithToggle (Notifications page pattern)
```jsx
const SettingsRowWithToggle = ({ title, description, checked, onChange }) => (
  <Box sx={{ p: 3 }}>
    <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
      <Box>
        <Typography variant="body1" fontWeight="medium">{title}</Typography>
        <Typography variant="body2" color="text.secondary">{description}</Typography>
      </Box>
      <Switch checked={checked} onChange={onChange} />
    </Box>
  </Box>
);
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
