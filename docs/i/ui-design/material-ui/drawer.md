# MUI Left Navigation (Drawer/Sidebar)

## ⚠️ CRITICAL Drawer Requirements

These patterns are **MANDATORY** - verify before implementing:

| Requirement | ❌ WRONG | ✅ CORRECT |
|-------------|----------|------------|
| **Create Button** | Orange/blue/primary color | **GREEN** `#4CD964` button at TOP |
| **Warnings** | At top of drawer as banner | **BELOW** the specific item with the issue |
| **Feedback** | Missing or scrollable | 5 emoji faces **FIXED at BOTTOM** |

### Warning Placement - CRITICAL

```
❌ WRONG                              ✅ CORRECT
┌─────────────────────────┐          ┌─────────────────────────┐
│  [+ Create]             │          │  [+ Create]  🟢         │
├─────────────────────────┤          ├─────────────────────────┤
│  ┌─────────────────────┐│          │  CHANNELS               │
│  │ ⚠️ Warning banner   ││ ← WRONG  │  👤 peter@inter...   0  │ ← Issue
│  └─────────────────────┘│          │  ┌─────────────────────┐│
│  CHANNELS               │          │  │ ⚠️ Warning message  ││ ← CORRECT
│  👤 peter@inter...   0  │          │  └─────────────────────┘│
│  👤 Peter Jung       0  │          │  👤 Peter Jung       0  │
└─────────────────────────┘          └─────────────────────────┘
```

**Why below?** Creates clear visual association - users immediately know which item has the problem.

---

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
│  [  + Create  ]  🟢             │  ← GREEN button (#4CD964), opens dropdown
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

**CRITICAL**: Warning messages must be placed **BELOW** the feature that has the problem.

❌ **WRONG**: Warning at top of drawer as a global banner
✅ **CORRECT**: Warning immediately below the specific item with the issue

| Property | Value |
|----------|-------|
| Position | **Immediately BELOW** the problematic item (NOT at top of drawer!) |
| Style | Warning background (light orange/amber) |
| Icon | `WarningIcon` or `ErrorOutlineIcon` |
| Action | Clickable to fix the issue |

**❌ WRONG - Warning at top:**
```
┌─────────────────────────────────┐
│  [+ Create]                     │
├─────────────────────────────────┤
│  ┌─────────────────────────────┐│
│  │ ⚠️ 2 channels need...       ││  ← WRONG! Not at top!
│  └─────────────────────────────┘│
│  CHANNELS                       │
│  📧 All Channels             0  │
│  👤 peter@interactor...      0  │
│  👤 Peter Jung/Pulzze        0  │
└─────────────────────────────────┘
```

**✅ CORRECT - Warning below problematic item:**
```
┌─────────────────────────────────┐
│  [+ Create]                     │
├─────────────────────────────────┤
│  CHANNELS                       │
│  📧 All Channels             0  │
│  👤 peter@interactor...      0  │  ← Item with issue
│  ┌─────────────────────────────┐│
│  │ ⚠️ 2 channels need...       ││  ← Warning BELOW this item
│  │   Click to reconnect     >  ││
│  └─────────────────────────────┘│
│  👤 Peter Jung/Pulzze        0  │  ← Next item (no issue)
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

Fixed at the bottom of the drawer. Shows emoji faces for quick feedback. Clicking any emoji opens a modal for detailed feedback collection.

**Production Design Reference**: See `docs/i/ui-design/modals-dropdowns.md` for the complete Feedback Modal specification with screenshot-accurate styling.

| Component | Description |
|-----------|-------------|
| Label | "Feedback" text above emoji row |
| Emojis | 5 faces from negative to positive (😞 😟 😐 🙂 😊) |
| Action | Clicking any emoji opens feedback modal with pre-selected rating |

**Rating Labels:**

| Rating | Emoji | Label |
|--------|-------|-------|
| 1 | 😞 | Very Dissatisfied |
| 2 | 😟 | Dissatisfied |
| 3 | 😐 | Neutral |
| 4 | 🙂 | Satisfied |
| 5 | 😊 | Very Satisfied |

**Complete Implementation with Feedback Modal:**

```jsx
import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
  IconButton,
  Divider,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  TextField,
} from '@mui/material';
import CloseIcon from '@mui/icons-material/Close';
import DescriptionOutlinedIcon from '@mui/icons-material/DescriptionOutlined';

// Rating configuration
const RATINGS = [
  { value: 1, emoji: '😞', label: 'Very Dissatisfied' },
  { value: 2, emoji: '😟', label: 'Dissatisfied' },
  { value: 3, emoji: '😐', label: 'Neutral' },
  { value: 4, emoji: '🙂', label: 'Satisfied' },
  { value: 5, emoji: '😊', label: 'Very Satisfied' },
];

const FeedbackSection = () => {
  const [modalOpen, setModalOpen] = useState(false);
  const [selectedRating, setSelectedRating] = useState(null);
  const [comment, setComment] = useState('');

  // Get current page URL for context
  const pageUrl = typeof window !== 'undefined' ? window.location.pathname : '';

  const handleEmojiClick = (rating) => {
    setSelectedRating(rating);
    setModalOpen(true);
  };

  const handleRatingSelect = (rating) => {
    setSelectedRating(rating);
  };

  const handleClose = () => {
    setModalOpen(false);
    setSelectedRating(null);
    setComment('');
  };

  const handleSubmit = () => {
    if (!selectedRating) return;

    const feedbackData = {
      rating: selectedRating,
      comment: comment,
      page_url: pageUrl,
      user_id: getCurrentUserId(), // Implement based on your auth
      user_agent: navigator.userAgent,
      viewport: `${window.innerWidth}x${window.innerHeight}`,
      timestamp: new Date().toISOString(),
    };

    // Log or send to your feedback service
    console.log('[Feedback]', feedbackData);

    // Show success message (implement your notification system)
    // showNotification('Thank you for your feedback!');

    handleClose();
  };

  const getRatingLabel = (rating) => {
    return RATINGS.find(r => r.value === rating)?.label || '';
  };

  return (
    <>
      {/* Feedback trigger section - fixed at bottom of drawer */}
      <Box sx={{ flexGrow: 1 }} />  {/* Spacer to push to bottom */}
      <Divider />
      <Box sx={{ p: 2 }}>
        <Typography
          variant="overline"
          sx={{
            color: 'text.secondary',
            fontWeight: 600,
            letterSpacing: 1.2,
          }}
        >
          Feedback
        </Typography>
        <Box sx={{ display: 'flex', justifyContent: 'space-around', mt: 1 }}>
          {RATINGS.map((rating) => (
            <IconButton
              key={rating.value}
              onClick={() => handleEmojiClick(rating.value)}
              aria-label={rating.label}
              sx={{
                fontSize: '1.5rem',
                opacity: 0.6,
                transition: 'all 0.2s ease',
                '&:hover': {
                  opacity: 1,
                  transform: 'scale(1.1)',
                },
                '&:focus': {
                  outline: '2px solid #4CD964',
                  outlineOffset: 2,
                },
              }}
            >
              {rating.emoji}
            </IconButton>
          ))}
        </Box>
      </Box>

      {/* Feedback Modal */}
      <Dialog
        open={modalOpen}
        onClose={handleClose}
        maxWidth="sm"
        fullWidth
        PaperProps={{
          sx: {
            borderRadius: 4,
            maxWidth: 448,
          },
        }}
      >
        {/* Close button */}
        <IconButton
          onClick={handleClose}
          sx={{
            position: 'absolute',
            top: 16,
            right: 16,
            color: 'text.secondary',
            '&:hover': {
              bgcolor: 'action.hover',
            },
          }}
        >
          <CloseIcon />
        </IconButton>

        <DialogContent sx={{ pt: 4, pb: 3, px: 3 }}>
          {/* Title */}
          <Typography
            variant="h5"
            fontWeight="bold"
            textAlign="center"
            sx={{ mb: 0.5 }}
          >
            Share Your Feedback
          </Typography>
          <Typography
            variant="body2"
            color="text.secondary"
            textAlign="center"
            sx={{ mb: 3 }}
          >
            How are you feeling about your experience?
          </Typography>

          {/* Emoji rating selector */}
          <Box
            sx={{
              display: 'flex',
              justifyContent: 'center',
              gap: 1,
              mb: 1,
            }}
          >
            {RATINGS.map((rating) => (
              <IconButton
                key={rating.value}
                onClick={() => handleRatingSelect(rating.value)}
                aria-label={`${rating.label} - ${rating.value} star`}
                sx={{
                  fontSize: '1.5rem',
                  width: 48,
                  height: 48,
                  borderRadius: '50%',  // Circular button (production design)
                  transition: 'all 0.2s ease',
                  // Selected state: green circular background
                  bgcolor: selectedRating === rating.value
                    ? 'rgba(76, 217, 100, 0.2)'  // #4CD964 at 20% opacity
                    : 'transparent',
                  outline: selectedRating === rating.value
                    ? '2px solid #4CD964'
                    : 'none',
                  '&:hover': {
                    bgcolor: selectedRating === rating.value
                      ? 'rgba(76, 217, 100, 0.2)'
                      : 'action.hover',
                  },
                }}
              >
                {rating.emoji}
              </IconButton>
            ))}
          </Box>

          {/* Rating label - shows below selected emoji */}
          <Typography
            variant="body2"
            textAlign="center"
            sx={{
              color: 'text.primary',  // Regular text color (production design)
              fontWeight: 500,
              height: 20,
              mb: 3,
            }}
          >
            {selectedRating ? getRatingLabel(selectedRating) : ''}
          </Typography>

          {/* Comment textarea */}
          <Typography
            variant="body2"
            fontWeight="medium"
            sx={{ mb: 1 }}
          >
            What can we improve?{' '}
            <Typography component="span" color="text.secondary" fontWeight="normal">
              (optional)
            </Typography>
          </Typography>
          <TextField
            multiline
            rows={3}
            fullWidth
            placeholder="Tell us more about your experience..."
            value={comment}
            onChange={(e) => setComment(e.target.value)}
            sx={{
              mb: 2,
              '& .MuiOutlinedInput-root': {
                borderRadius: 3,
                bgcolor: 'action.hover',
                '& fieldset': {
                  border: 'none',
                },
                '&:focus-within': {
                  outline: '2px solid #4CD964',
                },
              },
            }}
          />

          {/* Context display */}
          <Box
            sx={{
              display: 'flex',
              alignItems: 'center',
              gap: 1,
              color: 'text.secondary',
              mb: 3,
            }}
          >
            <DescriptionOutlinedIcon sx={{ fontSize: 18 }} />
            <Typography variant="body2">
              Feedback for:{' '}
              <Typography component="span" color="text.primary">
                {pageUrl}
              </Typography>
            </Typography>
          </Box>
        </DialogContent>

        {/* Action buttons */}
        <DialogActions sx={{ px: 3, pb: 3, gap: 1.5 }}>
          <Button
            onClick={handleClose}
            fullWidth
            sx={{
              borderRadius: 50,
              py: 1.5,
              bgcolor: 'action.hover',
              color: 'text.primary',
              textTransform: 'none',
              fontWeight: 500,
              '&:hover': {
                bgcolor: 'action.selected',
              },
            }}
          >
            Cancel
          </Button>
          <Button
            onClick={handleSubmit}
            fullWidth
            disabled={!selectedRating}
            sx={{
              borderRadius: 50,
              py: 1.5,
              bgcolor: '#4CD964',
              color: 'white',
              textTransform: 'none',
              fontWeight: 600,
              '&:hover': {
                bgcolor: '#3DBF55',
              },
              '&:disabled': {
                bgcolor: '#4CD964',
                opacity: 0.5,
                color: 'white',
              },
            }}
          >
            Submit Feedback
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

// Helper function - implement based on your auth system
const getCurrentUserId = () => {
  // Return user ID from your auth context/store
  return null;
};

export default FeedbackSection;
```

**Feedback Data Schema:**

| Field | Type | Description |
|-------|------|-------------|
| `rating` | integer (1-5) | Required. The selected emoji rating |
| `comment` | string | Optional. Additional feedback text |
| `page_url` | string | Current page URL/path |
| `user_id` | string/null | Authenticated user ID (if available) |
| `user_agent` | string | Browser user agent string |
| `viewport` | string | Window dimensions (e.g., "1920x1080") |
| `timestamp` | string | ISO 8601 timestamp |

**Integration in Drawer:**

```jsx
const AppDrawer = () => {
  return (
    <Drawer
      variant="permanent"
      sx={{
        width: 256,
        '& .MuiDrawer-paper': {
          width: 256,
          display: 'flex',
          flexDirection: 'column',
        },
      }}
    >
      {/* Create Button */}
      <Box sx={{ p: 2 }}>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          fullWidth
          sx={{
            borderRadius: 2,
            bgcolor: '#4CD964',
            '&:hover': { bgcolor: '#3DBF55' },
          }}
        >
          Create
        </Button>
      </Box>

      {/* Navigation sections */}
      <Box sx={{ flex: 1, overflow: 'auto' }}>
        {/* ... navigation items ... */}
      </Box>

      {/* Feedback Section - uses flexGrow spacer internally */}
      <FeedbackSection />
    </Drawer>
  );
};
```

---
