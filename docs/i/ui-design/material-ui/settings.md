# MUI Settings Pages

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
