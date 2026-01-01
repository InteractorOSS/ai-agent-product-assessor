# MUI Left Navigation (Drawer/Sidebar)

### Left Navigation Bar (Drawer/Sidebar)

The left navigation has five distinct zones:

| Zone | Position | Content |
|------|----------|---------|
| **Create Button** | Top (fixed) | Green "+ Create" button for major features |
| **Section 1** | Below Create | Selection-only items (no create option) |
| **Section 2** | Middle (scrollable) | Expandable sections with create capability |
| **Warnings** | Below problematic items | Contextual alerts for items needing attention |
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

#### Interactor Left Navigation Design

The Interactor left navigation follows a clean, sectioned design with collapsible groups.

##### Visual Structure (Interactor Style)
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

##### Active Item Styling (Interactor)

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

##### Icons (Interactor Style)

| Property | Value |
|----------|-------|
| Style | Outlined/stroke icons (not filled) |
| Stroke width | `1.5` for normal icons |
| Size | `w-5 h-5` (20px) for navigation items |
| Default color | Gray (`#8E8E93`) |
| Active color | Green (`#4CD964`) |

```jsx
// Interactor-style Left Navigation
const InteractorDrawer = () => {
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

#### Global Create Button (Top)

| Property | Value |
|----------|-------|
| Position | Fixed at top of drawer |
| Style | **Green** (`#4CD964`), full width with padding |
| Icon | `AddIcon` (+) on left |
| Action | Opens dropdown menu with major feature creation options |

**IMPORTANT**: The Create button must be **green** (Interactor brand color), NOT orange or blue.

```jsx
<Button
  variant="contained"
  startIcon={<AddIcon />}
  fullWidth
  onClick={handleCreateMenuOpen}
  sx={{
    m: 2,
    borderRadius: 2,
    bgcolor: '#4CD964',
    '&:hover': { bgcolor: '#3DBF55' },
  }}
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

---

#### Warning/Alert Messages (Below Feature)

**IMPORTANT**: Warning messages must be placed **BELOW** the feature that has the problem, NOT above or in a separate area.

| Property | Value |
|----------|-------|
| Position | Immediately below the problematic item |
| Style | Warning background (light orange/amber) |
| Icon | `WarningIcon` or `ErrorOutlineIcon` |
| Action | Clickable to fix the issue |

**Visual Structure:**
```
┌─────────────────────────────────┐
│  📧 peter@interactor...      0  │  ← Item with issue
│  ┌─────────────────────────────┐│
│  │ ⚠️ 2 channels need...       ││  ← Warning BELOW item
│  │   Click to reconnect     >  ││
│  └─────────────────────────────┘│
│  👤 Peter Jung/Pulzze        0  │  ← Next item
└─────────────────────────────────┘
```

**Implementation:**
```jsx
{channels.map((channel) => (
  <Box key={channel.id}>
    {/* Channel item */}
    <ListItemButton>
      <Avatar src={channel.avatar} sx={{ mr: 2 }} />
      <ListItemText primary={channel.name} />
      <Typography variant="body2" color="text.secondary">
        {channel.count}
      </Typography>
    </ListItemButton>

    {/* Warning placed BELOW the channel if it has issues */}
    {channel.hasWarning && (
      <Alert
        severity="warning"
        icon={<WarningIcon />}
        onClick={() => handleReconnect(channel.id)}
        sx={{
          mx: 2,
          mb: 1,
          cursor: 'pointer',
          borderRadius: 2,
          '& .MuiAlert-message': { width: '100%' },
        }}
      >
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <Box>
            <Typography variant="body2" fontWeight="medium">
              {channel.warningCount} channels need attention
            </Typography>
            <Typography variant="caption" color="text.secondary">
              Click to reconnect
            </Typography>
          </Box>
          <ChevronRightIcon fontSize="small" />
        </Box>
      </Alert>
    )}
  </Box>
))}
```

**Why Below, Not Above:**
- Users scan top-to-bottom; warning after item creates clear association
- Doesn't push content down unexpectedly when warnings appear
- Matches mental model: "this item → has this problem"

---

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
