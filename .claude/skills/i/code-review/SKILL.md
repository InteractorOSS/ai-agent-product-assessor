---
name: code-review
description: Perform comprehensive code review with security, performance, and best practices analysis. Use when reviewing PRs, before commits, or for code quality assessment.
author: David Jung
---

# Code Review Skill

Perform thorough code reviews following established best practices and project standards.

## When to Use

- Before creating a pull request
- When reviewing others' code
- After completing a feature implementation
- For periodic code quality assessments

## Instructions

When performing a code review, follow these steps:

### Step 1: Understand Context

Before reviewing code:
1. Understand the purpose of the changes
2. Review related requirements or tickets
3. Check if tests are included
4. Identify the scope of changes

### Step 2: Code Quality Analysis

Reference: [checklist.md](checklist.md)

Check for:
- [ ] Clear and descriptive naming (variables, functions, classes)
- [ ] Single responsibility principle adherence
- [ ] DRY (Don't Repeat Yourself) compliance
- [ ] Proper error handling with meaningful messages
- [ ] Appropriate logging (not too verbose, not silent)
- [ ] No hardcoded values (use constants or config)
- [ ] Clean code structure and organization
- [ ] Consistent coding style

### Step 3: Security Review

Check for:
- [ ] Input validation on all user inputs
- [ ] Parameterized queries (no SQL injection)
- [ ] Output encoding (XSS prevention)
- [ ] Authentication/authorization checks
- [ ] No sensitive data in logs or responses
- [ ] Secure dependency versions

### Step 4: Performance Review

Check for:
- [ ] N+1 query patterns
- [ ] Unnecessary loops or iterations
- [ ] Memory leak potential
- [ ] Efficient algorithms for the use case
- [ ] Appropriate caching usage
- [ ] Lazy loading where beneficial

### Step 5: Test Review

Check for:
- [ ] Adequate test coverage for new code
- [ ] Edge cases covered
- [ ] Integration tests where needed
- [ ] Meaningful test descriptions
- [ ] No flaky tests
- [ ] Mocks used appropriately

### Step 6: Documentation Review

Check for:
- [ ] Updated README if needed
- [ ] API documentation current
- [ ] Complex logic has explanatory comments
- [ ] JSDoc/docstrings for public functions
- [ ] CHANGELOG updated (if applicable)

## Output Format

Provide the review in this structured format:

```markdown
## Code Review Summary

**Files Reviewed**: [count]
**Overall Assessment**: [APPROVE | REQUEST_CHANGES | COMMENT]

---

### Critical Issues (Must Fix)

> Issues that block approval

1. **[Category]** - [File:Line]
   - Issue: [Description]
   - Suggestion: [How to fix]

---

### Suggestions (Should Fix)

> Issues that should be addressed but don't block

1. **[Category]** - [File:Line]
   - Issue: [Description]
   - Suggestion: [How to improve]

---

### Minor Notes (Nice to Have)

> Optional improvements

- [Note 1]
- [Note 2]

---

### Positive Highlights

> What was done well

- [Highlight 1]
- [Highlight 2]
```

## Examples

### Example 1: Reviewing an API endpoint

```
Review this new /api/users endpoint:
1. Check input validation for all parameters
2. Verify authorization checks
3. Review error responses for information leakage
4. Check database query efficiency
5. Verify response format consistency
```

### Example 2: Reviewing a React component

```
Review this React component:
1. Check for unnecessary re-renders
2. Verify proper use of hooks
3. Check accessibility attributes
4. Review prop types/TypeScript types
5. Verify error boundaries where needed
```

### Example 3: Reviewing a database migration

```
Review this migration:
1. Check for backward compatibility
2. Verify index efficiency
3. Review data integrity constraints
4. Check rollback safety
5. Verify large table handling
```
