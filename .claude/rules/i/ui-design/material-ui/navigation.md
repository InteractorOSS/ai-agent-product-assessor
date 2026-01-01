# MUI Navigation - Global Navigation Bar

## Global Navigation Bar (AppBar/Header)

The navigation bar has three distinct sections:

| Section | Elements | Position |
|---------|----------|----------|
| **Left** | Sidebar toggle, Tools icon, Interactor icon, Interactor logo (lottie animated) | Left-aligned |
| **Center** | AI Assistant input field | Center (flex-grow) |
| **Right** | Notification, Help, Profile icons | Right-aligned |

**Brand Asset Sources for Navigation** (copy from `.claude/assets/brand/` to your app first):
- **Interactor Icon (Light Mode)**: `icons/icon_simple_green_v1.png`
- **Interactor Icon (Dark Mode)**: `icons/icon_simple_white_v1.png` (for visibility on dark backgrounds)
- **Interactor Logo (Lottie)**: `lottie/InteractorLogo_Light.json` (light mode) or `InteractorLogo_Dark.json` (dark mode)

### Left Section Elements (in order)

| Element | Icon | Purpose |
|---------|------|---------|
| Sidebar Toggle | `MenuIcon` / `MenuOpenIcon` | Open/close left navigation drawer |
| Tools Selection | `AppsIcon` or `GridViewIcon` | Access tools/applications menu |
| Interactor Logo | Custom logo component | Brand identity, links to home |

### Center Section

| Element | Component | Purpose |
|---------|-----------|---------|
| AI Assistant Input | `TextField` with `InputAdornment` | Primary AI interaction point |

- Should use `flexGrow: 1` with max-width constraint
- Include search/send icon as adornment
- Placeholder: "Ask AI Assistant..." or similar

### Right Section Elements (in order)

| Element | Icon | Behavior |
|---------|------|----------|
| Notifications | `NotificationsIcon` | Badge for unread count, opens panel |
| Help | `HelpOutlineIcon` | Opens help/documentation |
| Profile | `AccountCircleIcon` | **Navigates to full Profile page** |

**Important**: Profile is a **full page navigation**, NOT a dropdown menu.

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
  const iconSrc = mode === 'dark' ? iconWhite : iconGreen;  // White icon for dark mode visibility
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
      <InteractorLogo mode={theme.palette.mode} />  {/* Logo with link to home */}
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
