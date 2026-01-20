# Debug Logs

Diagnose → implement fix → verify (Playwright if UI/UX).

> **>95% confident** → implement directly. Otherwise, ask first.

## Execution

```
MAIN: Orchestrate
  ├─► [PARALLEL] Explore: logs + codebase
  ├─► Synthesize → Fix
  └─► [IF UI/UX] validation-gates: Playwright
```

**Parallel spawn:**
```
Task(Explore): "Analyze logs/error.log + logs/all.log for: [issue]"
Task(Explore): "Find code related to: [issue]"
```

## Logs

| File | Contents |
|------|----------|
| `logs/error.log` | Errors/warnings |
| `logs/all.log` | All levels |

**Search:** `tail -100 logs/error.log` · `grep -B5 -A5 "[msg]" logs/all.log`

## After Fix

**Restart:** config, mix.exs, schemas, contexts, hooks, plugs
**Refresh:** JS, CSS, static assets

## Playwright (UI/UX only)

**Trigger:** `phx-click`, `phx-submit`, `handle_event`, UI components, nav, hooks

**Spawn validation-gates with:**
```
Playwright verify: [page], [action], [expected]
File: e2e/tests/verify-fix-{Date.now()}.spec.ts
DELETE file after test completes (pass/fail)
```

**Loop:** FAIL → fix → re-verify (new timestamp) → PASS
