# Documentation Standards Skill

Standards for maintaining clear, useful documentation.

## Quick Reference

**Principles:**
1. Keep it current - Update docs with code changes
2. Be concise - Avoid unnecessary verbosity
3. Use examples - Show, don't just tell
4. Document the "why" - Not just the "what"
5. Target the audience - Different docs for different readers

**When to Comment:**
- Complex algorithms or business logic
- Non-obvious decisions or workarounds
- Public APIs and interfaces
- Security-sensitive code
- Performance-critical sections

**Don't Comment:**
- Self-explanatory code
- What the code does (should be obvious)
- Every function (use good naming)

---

## Detailed Documentation Guidelines

### Code Documentation

**JSDoc/TSDoc Pattern:**
```typescript
/**
 * Brief description.
 *
 * @param param - Description
 * @returns Description
 * @throws {ErrorType} When condition
 * @example
 * ```typescript
 * const result = functionName(arg);
 * ```
 */
```

**Elixir @doc Pattern:**
```elixir
@doc """
Brief description.

## Parameters
  * `param` - Description

## Examples
    iex> function_name(arg)
    expected_result
"""
@spec function_name(type()) :: return_type()
```

### README Structure

Every project should have:
1. Project Name + Brief description
2. Features list
3. Prerequisites
4. Installation instructions
5. Configuration table
6. Usage examples
7. API Documentation link
8. Contributing guide
9. License

### Changelog Format

Follow [Keep a Changelog](https://keepachangelog.com/):
- **Added** - New features
- **Changed** - Changes in existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Now removed features
- **Fixed** - Bug fixes
- **Security** - Vulnerability fixes

### Architecture Decision Records (ADRs)

Document significant decisions with:
- **Status**: Accepted/Deprecated/Superseded
- **Context**: The situation
- **Decision**: What we chose
- **Rationale**: Why we chose it
- **Alternatives Considered**: What else was evaluated
- **Consequences**: Impact of the decision

### Inline Documentation Tags

```javascript
// TODO: Future improvement needed
// FIXME: Known issue to fix
// HACK: Workaround, remove when fixed
// NOTE: Important context
// SECURITY: Security-related note
// PERFORMANCE: Performance consideration
// DEPRECATED: Use alternative instead
```
