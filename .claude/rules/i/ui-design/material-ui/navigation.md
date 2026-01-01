# MUI Navigation - Global Navigation Bar

## Global Navigation Bar (AppBar/Header)

The navigation bar has three distinct sections:

| Section | Elements | Position |
|---------|----------|----------|
| **Left** | Sidebar toggle, Tools icon, Interactor icon, Interactor logo (lottie animated) | Left-aligned |
| **Center** | AI Assistant input field | Center (flex-grow) |
| **Right** | Notification, Help, Profile icons | Right-aligned |

**Brand Asset Sources for Navigation** (copy from `.claude/assets/i/brand/` to your app first):
- **Interactor Icon (Light Mode)**: `icons/icon_simple_green_v1.png`
- **Interactor Icon (Dark Mode)**: `icons/icon_simple_white_v1.png` (for visibility on dark backgrounds)
- **Interactor Logo (Lottie)**: `lottie/InteractorLogo_Light.json` (light mode) or `InteractorLogo_Dark.json` (dark mode)

### Left Section Elements (in order)

| Element | Icon/Component | Purpose |
|---------|----------------|---------|
| Sidebar Toggle | `MenuIcon` / `MenuOpenIcon` | Open/close left navigation drawer |
| Tools Selection | `AppsIcon` or `GridViewIcon` | Access tools/applications menu |
| Interactor Logo | **Lottie Animation** (NOT static icon) | Brand identity, links to home |

**IMPORTANT - Interactor Logo**:
- Must use **Lottie animated logo**, NOT a static PNG/SVG
- Light mode: `InteractorLogo_Light.json`
- Dark mode: `InteractorLogo_Dark.json`
- Size: ~100-120px width, 32px height
- Plays once on load, links to home (`/`)

### Center Section - AI Assistant Input

| Element | Component | Purpose |
|---------|-----------|---------|
| AI Assistant Input | `TextField` with `InputAdornment` | Primary AI interaction point |

**Input Field Behavior:**
- Should use `flexGrow: 1` with max-width constraint
- Placeholder: "What can I do for you?" or similar
- **Empty state**: Only shows search/sparkle icon on left
- **Has input**: Send button (`SendIcon`) appears on right
- **Submit**: Press `Enter` key OR click Send button

**On Submit → Opens AI Copilot Right Pane:**
- Right pane slides in (400-480px width)
- Center content area shrinks horizontally to accommodate
- AI Copilot pane is fixed/persistent until closed

---

## AI Copilot Right Pane (Best Practices)

When user submits a query, a right-side AI Copilot panel opens following industry best practices.

### Layout Structure

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  [≡] [⊞] [🟢][Logo]    [What can I do for you?... ➤]      [🔔] [?] [👤]    │
├────────────────────────┬────────────────────────────┬───────────────────────┤
│                        │                            │  AI Copilot      [✕]  │
│                        │                            ├───────────────────────┤
│    Left Drawer         │     Main Content           │  ┌─────────────────┐  │
│    (240px)             │     (flex: 1, shrinks)     │  │ User message    │  │
│                        │                            │  └─────────────────┘  │
│                        │                            │  ┌─────────────────┐  │
│                        │                            │  │ AI response     │  │
│                        │                            │  │ with streaming  │  │
│                        │                            │  │ ...             │  │
│                        │                            │  └─────────────────┘  │
│                        │                            │                       │
│                        │                            │  ┌─────────────────┐  │
│                        │                            │  │ Suggested       │  │
│                        │                            │  │ actions/prompts │  │
│                        │                            │  └─────────────────┘  │
│                        │                            ├───────────────────────┤
│                        │                            │  [What can I do...  ➤]│
│  Feedback              │                            │  Input at bottom      │
│  😞 😟 😐 🙂 😊        │                            │                       │
└────────────────────────┴────────────────────────────┴───────────────────────┘
```

### AI Copilot Pane Specifications

| Property | Value |
|----------|-------|
| Width | 400-480px (fixed) |
| Position | Right side, below AppBar |
| Height | Full viewport height minus AppBar |
| Animation | Slide in from right (200-300ms ease) |
| Close button | Top right corner (✕) |
| Background | `background.paper` with subtle elevation |

### Copilot Header

| Element | Description |
|---------|-------------|
| Title | "AI Copilot" or "Assistant" |
| Close button | `CloseIcon` - closes pane, restores main content width |
| Optional: History | Icon to view conversation history |
| Optional: New chat | Icon to start fresh conversation |

### Message Thread (Best Practices)

**User Messages:**
- Right-aligned or full-width with user indicator
- Background: Primary color (light) or distinct from AI
- Show timestamp on hover
- Avatar or "You" label

**AI Responses:**
- Left-aligned or full-width with AI indicator
- Background: Surface color or subtle gray
- **Streaming**: Show typing indicator, then stream text
- **Code blocks**: Syntax highlighted, copy button
- **Actions**: Inline buttons for "Copy", "Insert", "Apply"
- Sparkle/AI icon indicator

**Message Spacing:**
- Gap between messages: 16px
- Padding inside message: 12-16px
- Max message width: 100% of pane (no horizontal scroll)

### Suggested Actions / Quick Prompts

Below the conversation, show contextual suggestions:

```jsx
<Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1, p: 2 }}>
  <Chip label="Explain this code" onClick={...} variant="outlined" />
  <Chip label="Fix errors" onClick={...} variant="outlined" />
  <Chip label="Add tests" onClick={...} variant="outlined" />
  <Chip label="Optimize" onClick={...} variant="outlined" />
</Box>
```

### Input Area (Bottom of Pane)

| Property | Value |
|----------|-------|
| Position | Fixed at bottom of pane |
| Component | `TextField` multiline (auto-expand, max 4 rows) |
| Placeholder | "Ask a follow-up..." |
| Send button | Appears when input has text |
| Submit | Enter (without Shift) or click Send |
| Shift+Enter | New line in input |

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Enter` | Submit message |
| `Shift+Enter` | New line |
| `Escape` | Close copilot pane |
| `Cmd/Ctrl+K` | Focus AI input (global) |

### State Management

```typescript
interface CopilotState {
  isOpen: boolean;
  messages: Message[];
  isStreaming: boolean;
  inputValue: string;
  error: string | null;
}

interface Message {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: Date;
  status: 'sending' | 'sent' | 'error';
}
```

### Animation & Transitions

```jsx
// Main content shrinks when copilot opens
<Box
  sx={{
    flex: 1,
    transition: 'margin-right 0.25s ease',
    marginRight: copilotOpen ? '440px' : 0,
  }}
>
  {/* Main content */}
</Box>

// Copilot pane slides in
<Drawer
  anchor="right"
  variant="persistent"
  open={copilotOpen}
  sx={{
    '& .MuiDrawer-paper': {
      width: 440,
      top: 64, // AppBar height
      height: 'calc(100vh - 64px)',
    },
  }}
>
  {/* Copilot content */}
</Drawer>
```

### Responsive Behavior

| Breakpoint | Behavior |
|------------|----------|
| Desktop (≥1200px) | Side panel, main content shrinks |
| Tablet (768-1199px) | Side panel overlays (doesn't shrink content) |
| Mobile (<768px) | Full-screen modal/sheet |

### Loading & Empty States

**Loading (Streaming):**
- Typing indicator (3 animated dots)
- Skeleton lines appearing progressively
- "AI is thinking..." text

**Empty State (First Open):**
- Welcome message: "How can I help you today?"
- Suggested starter prompts
- Recent conversation history (if any)

**Error State:**
- Error message with retry button
- "Something went wrong. Please try again."

### Right Section Elements (in order)

| Element | Icon | Behavior |
|---------|------|----------|
| Notifications | `NotificationsIcon` | Badge with unread count + error count |
| Help | `HelpOutlineIcon` | Opens help/documentation |
| Profile | `AccountCircleIcon` | **Navigates to full Settings page** |
| Quick Create | `AddIcon` (+) | **Opens Quick Create right panel** |

**Notification Badge - Dual Counter:**
- **Primary badge** (default color): Unread notification count
- **Secondary badge** (red/error): Error count (failed actions, disconnections)
- Show both when errors exist: `[🔔¹ ²]` (1 notification, 2 errors)

```jsx
<IconButton>
  <Badge
    badgeContent={notificationCount}
    color="primary"
    anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
  >
    <Badge
      badgeContent={errorCount}
      color="error"
      anchorOrigin={{ vertical: 'top', horizontal: 'left' }}
    >
      <NotificationsIcon />
    </Badge>
  </Badge>
</IconButton>
```

**Quick Create Button (+):**
- Green circular button with `+` icon
- Opens **Quick Create right panel** (NOT the AI Copilot)
- Quick access to create new items without navigating away

**Important**: Profile is a **full page navigation** to `/settings`, NOT a dropdown menu.

---

## Quick Create Right Panel

The "+" button in the AppBar opens a Quick Create panel for fast item creation.

### Quick Create Panel Specifications

| Property | Value |
|----------|-------|
| Trigger | Click "+" button in AppBar right section |
| Width | 320-400px |
| Position | Right side, below AppBar |
| Content | List of creatable items with icons |

### Quick Create Panel Structure

```
┌────────────────────────┐
│ Quick Create      [✕]  │
├────────────────────────┤
│  📝 New Post           │
│  📅 Schedule Post      │
│  📁 New Folder         │
│  🔗 Connect Channel    │
│  📊 New Dashboard      │
│  ⚡ New Automation     │
└────────────────────────┘
```

```jsx
<Drawer
  anchor="right"
  open={quickCreateOpen}
  onClose={() => setQuickCreateOpen(false)}
  sx={{
    '& .MuiDrawer-paper': {
      width: 360,
      top: 64,
      height: 'calc(100vh - 64px)',
    },
  }}
>
  <Box sx={{ p: 2 }}>
    <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
      <Typography variant="h6">Quick Create</Typography>
      <IconButton onClick={() => setQuickCreateOpen(false)}>
        <CloseIcon />
      </IconButton>
    </Box>
    <List>
      <ListItemButton onClick={() => handleCreate('post')}>
        <ListItemIcon><EditIcon /></ListItemIcon>
        <ListItemText primary="New Post" />
      </ListItemButton>
      <ListItemButton onClick={() => handleCreate('schedule')}>
        <ListItemIcon><ScheduleIcon /></ListItemIcon>
        <ListItemText primary="Schedule Post" />
      </ListItemButton>
      {/* More create options... */}
    </List>
  </Box>
</Drawer>
```

### Implementation Example

```jsx
// Correct - Global Navigation Bar structure
import Lottie from 'lottie-react';
import logoLightAnimation from '@/assets/brand/lottie/InteractorLogo_Light.json';
import logoDarkAnimation from '@/assets/brand/lottie/InteractorLogo_Dark.json';
import iconGreen from '@/assets/brand/icons/icon_simple_green_v1.png';
import iconWhite from '@/assets/brand/icons/icon_simple_white_v1.png';

// InteractorLogo component with theme-aware icon and Lottie animation
const InteractorLogo = ({ mode = 'light' }) => {
  const animationData = mode === 'dark' ? logoDarkAnimation : logoLightAnimation;
  const iconSrc = mode === 'dark' ? iconWhite : iconGreen;
  return (
    <Box
      component={Link}
      to="/"
      sx={{ display: 'flex', alignItems: 'center', textDecoration: 'none' }}
    >
      <img src={iconSrc} alt="" width={24} height={24} style={{ marginRight: 8 }} />
      <Lottie animationData={animationData} style={{ width: 100, height: 32 }} loop={false} />
    </Box>
  );
};

// AI Assistant Input with dynamic Send button
const AIAssistantInput = ({ onSubmit, onOpenCopilot }) => {
  const [inputValue, setInputValue] = useState('');

  const handleSubmit = () => {
    if (inputValue.trim()) {
      onSubmit(inputValue);
      onOpenCopilot();  // Opens right pane
      setInputValue('');
    }
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSubmit();
    }
  };

  return (
    <TextField
      value={inputValue}
      onChange={(e) => setInputValue(e.target.value)}
      onKeyDown={handleKeyDown}
      placeholder="What can I do for you?"
      sx={{ maxWidth: 600, width: '100%' }}
      InputProps={{
        startAdornment: (
          <InputAdornment position="start">
            <AutoAwesomeIcon sx={{ color: 'text.secondary' }} />
          </InputAdornment>
        ),
        // Send button appears only when there's input
        endAdornment: inputValue.trim() && (
          <InputAdornment position="end">
            <IconButton onClick={handleSubmit} edge="end" color="primary">
              <SendIcon />
            </IconButton>
          </InputAdornment>
        ),
      }}
    />
  );
};

// Main App Layout with Copilot pane
const AppLayout = () => {
  const [copilotOpen, setCopilotOpen] = useState(false);
  const [messages, setMessages] = useState([]);

  const handleAISubmit = (query) => {
    setMessages(prev => [...prev, { role: 'user', content: query }]);
    // Trigger AI response...
  };

  return (
    <Box sx={{ display: 'flex' }}>
      <AppBar position="fixed">
        <Toolbar>
          {/* LEFT SECTION */}
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <IconButton onClick={toggleDrawer}>
              {drawerOpen ? <MenuOpenIcon /> : <MenuIcon />}
            </IconButton>
            <IconButton>
              <AppsIcon />
            </IconButton>
            <InteractorLogo mode={theme.palette.mode} />
          </Box>

          {/* CENTER SECTION - AI Assistant Input */}
          <Box sx={{ flexGrow: 1, display: 'flex', justifyContent: 'center', mx: 2 }}>
            <AIAssistantInput
              onSubmit={handleAISubmit}
              onOpenCopilot={() => setCopilotOpen(true)}
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
            <IconButton onClick={() => navigate('/settings')}>
              <AccountCircleIcon />
            </IconButton>
          </Box>
        </Toolbar>
      </AppBar>

      {/* Left Drawer */}
      <LeftDrawer open={drawerOpen} />

      {/* Main Content - shrinks when copilot opens */}
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          p: 3,
          mt: 8, // AppBar height
          transition: 'margin-right 0.25s ease',
          marginRight: copilotOpen ? '440px' : 0,
        }}
      >
        {/* Page content */}
      </Box>

      {/* AI Copilot Right Pane */}
      <Drawer
        anchor="right"
        variant="persistent"
        open={copilotOpen}
        sx={{
          '& .MuiDrawer-paper': {
            width: 440,
            top: 64,
            height: 'calc(100vh - 64px)',
            borderLeft: 1,
            borderColor: 'divider',
          },
        }}
      >
        <CopilotPane
          messages={messages}
          onClose={() => setCopilotOpen(false)}
          onSubmit={handleAISubmit}
        />
      </Drawer>
    </Box>
  );
};
```
