# AutoFlow Design System - Authentication Pages

Sign in, sign up, and password reset page layouts.

---

## Sign In Page
```html
<div class="min-h-screen flex">
  <!-- Left: Form -->
  <div class="flex-1 flex flex-col justify-center px-8 lg:px-16 bg-white dark:bg-[#1C1C1E]">
    <!-- Logo -->
    <div class="mb-12">
      <a href="/" class="flex items-center gap-2">
        <svg class="w-8 h-8 text-[#4CD964]"><!-- Logo --></svg>
        <span class="text-xl font-bold text-[#4CD964]">AutoFlow</span>
      </a>
    </div>

    <!-- Form -->
    <div class="max-w-md">
      <h1 class="text-3xl font-bold text-[#1C1C1E] dark:text-white mb-2">Let's Sign You In</h1>
      <p class="text-[#8E8E93] mb-8">
        Don't have an account?
        <a href="/signup" class="text-[#4CD964] hover:underline font-medium">Sign up</a>
      </p>

      <form class="space-y-5">
        <!-- Email input with floating label -->
        <div class="relative">
          <input
            type="email"
            id="email"
            class="peer w-full px-4 py-3.5 bg-[#F5F5F7] dark:bg-[#2C2C2E] border border-transparent focus:border-[#4CD964] rounded-full text-[#1C1C1E] dark:text-white placeholder-transparent focus:outline-none"
            placeholder="Email"
          />
          <label
            for="email"
            class="absolute left-4 -top-2.5 px-1 text-xs font-medium text-[#4CD964] bg-white dark:bg-[#1C1C1E] transition-all peer-placeholder-shown:text-base peer-placeholder-shown:text-[#8E8E93] peer-placeholder-shown:top-3.5 peer-placeholder-shown:bg-transparent peer-focus:-top-2.5 peer-focus:text-xs peer-focus:text-[#4CD964] peer-focus:bg-white dark:peer-focus:bg-[#1C1C1E]"
          >
            Username or Email
          </label>
        </div>

        <!-- Password input -->
        <div class="relative">
          <input
            type="password"
            id="password"
            class="w-full px-4 py-3.5 bg-[#F5F5F7] dark:bg-[#2C2C2E] border border-transparent focus:border-[#4CD964] rounded-full text-[#1C1C1E] dark:text-white placeholder-[#8E8E93] focus:outline-none"
            placeholder="Password"
          />
        </div>

        <!-- Remember me & Forgot password -->
        <div class="flex items-center justify-between">
          <label class="inline-flex items-center gap-2 cursor-pointer">
            <input type="checkbox" class="w-4 h-4 rounded border-[#E5E5EA] text-[#4CD964] focus:ring-[#4CD964]"/>
            <span class="text-sm text-[#8E8E93]">Remember Me</span>
          </label>
          <a href="/forgot-password" class="text-sm text-[#4CD964] hover:underline font-medium">Forgot Password</a>
        </div>

        <!-- Submit button -->
        <button type="submit" class="w-full px-6 py-3.5 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-semibold rounded-full transition-colors">
          Login
        </button>

        <!-- Divider -->
        <div class="flex items-center gap-4">
          <div class="flex-1 h-px bg-[#E5E5EA] dark:bg-[#3A3A3C]"></div>
          <span class="text-sm text-[#8E8E93]">OR</span>
          <div class="flex-1 h-px bg-[#E5E5EA] dark:bg-[#3A3A3C]"></div>
        </div>

        <!-- Social login -->
        <div class="flex gap-3">
          <button type="button" class="flex-1 flex items-center justify-center gap-2 px-4 py-3 bg-[#F5F5F7] dark:bg-[#2C2C2E] rounded-full hover:bg-[#E5E5EA] dark:hover:bg-[#3A3A3C] transition-colors">
            <svg class="w-5 h-5" viewBox="0 0 24 24"><!-- Google icon --></svg>
            <span class="text-[#1C1C1E] dark:text-white font-medium">Continue with Google</span>
          </button>
          <button type="button" class="p-3 bg-[#F5F5F7] dark:bg-[#2C2C2E] rounded-full hover:bg-[#E5E5EA] dark:hover:bg-[#3A3A3C] transition-colors">
            <svg class="w-5 h-5 text-[#1877F2]" viewBox="0 0 24 24"><!-- Facebook icon --></svg>
          </button>
        </div>
      </form>

      <!-- Dark mode toggle -->
      <div class="mt-8 flex items-center gap-3">
        <svg class="w-5 h-5 text-[#8E8E93]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"/>
        </svg>
        <span class="text-sm text-[#8E8E93]">Dark theme</span>
        <label class="relative inline-flex items-center cursor-pointer">
          <input type="checkbox" class="sr-only peer"/>
          <div class="w-11 h-6 bg-[#E5E5EA] rounded-full peer peer-checked:bg-[#4CD964] after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:after:translate-x-full"></div>
        </label>
      </div>
    </div>
  </div>

  <!-- Right: Illustration -->
  <div class="hidden lg:flex flex-1 bg-gradient-to-br from-[#E8F8EB] to-[#C8E6C9] dark:from-[#2C2C2E] dark:to-[#1C1C1E] items-center justify-center p-8">
    <img src="illustration.png" alt="Illustration" class="max-w-full max-h-full object-contain"/>
  </div>
</div>
```

---

## Forgot Password Page
```html
<div class="min-h-screen flex">
  <!-- Left: Form -->
  <div class="flex-1 flex flex-col justify-center px-8 lg:px-16 bg-white dark:bg-[#1C1C1E]">
    <!-- Logo -->
    <div class="mb-12">
      <a href="/" class="flex items-center gap-2">
        <svg class="w-8 h-8 text-[#4CD964]"><!-- Logo --></svg>
        <span class="text-xl font-bold text-[#4CD964]">AutoFlow</span>
      </a>
    </div>

    <!-- Form -->
    <div class="max-w-md">
      <h1 class="text-3xl font-bold text-[#1C1C1E] dark:text-white mb-2">Forgot Password</h1>
      <p class="text-[#8E8E93] mb-8">
        Enter your email address and we'll send you a link to reset your password.
      </p>

      <form class="space-y-5">
        <!-- Email input -->
        <div class="relative">
          <input
            type="email"
            id="email"
            class="peer w-full px-4 py-3.5 bg-[#F5F5F7] dark:bg-[#2C2C2E] border border-transparent focus:border-[#4CD964] rounded-full text-[#1C1C1E] dark:text-white placeholder-transparent focus:outline-none"
            placeholder="Email"
          />
          <label
            for="email"
            class="absolute left-4 -top-2.5 px-1 text-xs font-medium text-[#4CD964] bg-white dark:bg-[#1C1C1E] transition-all peer-placeholder-shown:text-base peer-placeholder-shown:text-[#8E8E93] peer-placeholder-shown:top-3.5 peer-placeholder-shown:bg-transparent peer-focus:-top-2.5 peer-focus:text-xs peer-focus:text-[#4CD964] peer-focus:bg-white dark:peer-focus:bg-[#1C1C1E]"
          >
            Email Address
          </label>
        </div>

        <!-- Submit button -->
        <button type="submit" class="w-full px-6 py-3.5 bg-[#4CD964] hover:bg-[#3DBF55] text-white font-semibold rounded-full transition-colors">
          Send Reset Link
        </button>

        <!-- Back to login -->
        <div class="text-center">
          <a href="/login" class="text-sm text-[#4CD964] hover:underline font-medium">
            ← Back to Login
          </a>
        </div>
      </form>
    </div>
  </div>

  <!-- Right: Illustration -->
  <div class="hidden lg:flex flex-1 bg-gradient-to-br from-[#E8F8EB] to-[#C8E6C9] dark:from-[#2C2C2E] dark:to-[#1C1C1E] items-center justify-center p-8">
    <img src="illustration.png" alt="Illustration" class="max-w-full max-h-full object-contain"/>
  </div>
</div>
```

---

## Authentication Page Specifications

| Element | Specification |
|---------|---------------|
| Layout | Split screen: form left, illustration right |
| Form Max Width | `max-w-md` |
| Form Side Padding | `px-8 lg:px-16` |
| Heading Size | `text-3xl font-bold` |
| Input Padding | `px-4 py-3.5` |
| Button Padding | `px-6 py-3.5` |
| Illustration Side | Gradient background (`from-[#E8F8EB] to-[#C8E6C9]`) |
| Illustration Side (dark) | `from-[#2C2C2E] to-[#1C1C1E]` |
| Form Spacing | `space-y-5` |
| Logo Margin | `mb-12` |
| Heading Margin | `mb-2` (title), `mb-8` (subtitle) |

---

## Social Login Buttons
```html
<!-- Google button (full width) -->
<button type="button" class="flex-1 flex items-center justify-center gap-2 px-4 py-3 bg-[#F5F5F7] dark:bg-[#2C2C2E] rounded-full hover:bg-[#E5E5EA] dark:hover:bg-[#3A3A3C] transition-colors">
  <svg class="w-5 h-5" viewBox="0 0 24 24">
    <!-- Google logo SVG -->
    <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
    <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
    <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
    <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
  </svg>
  <span class="text-[#1C1C1E] dark:text-white font-medium">Continue with Google</span>
</button>

<!-- Facebook button (icon only) -->
<button type="button" class="p-3 bg-[#F5F5F7] dark:bg-[#2C2C2E] rounded-full hover:bg-[#E5E5EA] dark:hover:bg-[#3A3A3C] transition-colors">
  <svg class="w-5 h-5 text-[#1877F2]" viewBox="0 0 24 24" fill="currentColor">
    <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
  </svg>
</button>
```

---

## OR Divider
```html
<div class="flex items-center gap-4">
  <div class="flex-1 h-px bg-[#E5E5EA] dark:bg-[#3A3A3C]"></div>
  <span class="text-sm text-[#8E8E93]">OR</span>
  <div class="flex-1 h-px bg-[#E5E5EA] dark:bg-[#3A3A3C]"></div>
</div>
```
