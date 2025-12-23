# Code Review Checklist

## Code Quality

### Naming
- [ ] Variable names are descriptive and meaningful
- [ ] Function names describe what they do (verb + noun)
- [ ] Class names are nouns in PascalCase
- [ ] Constants are in SCREAMING_SNAKE_CASE
- [ ] No single-letter variables except in loops
- [ ] No abbreviations unless universally understood

### Structure
- [ ] Functions are small (< 30 lines ideal)
- [ ] Single responsibility per function/class
- [ ] No deeply nested code (max 3 levels)
- [ ] Related code is grouped together
- [ ] Files are not too long (< 300 lines ideal)

### Readability
- [ ] Code is self-documenting
- [ ] Complex logic has explanatory comments
- [ ] No commented-out code
- [ ] Consistent formatting throughout
- [ ] Logical ordering of methods

### Error Handling
- [ ] All errors are caught and handled appropriately
- [ ] Error messages are user-friendly
- [ ] Errors are logged with context
- [ ] No silent failures
- [ ] Custom error types where appropriate

---

## Security

### Input Validation
- [ ] All user input is validated
- [ ] Validation happens server-side
- [ ] Input length limits enforced
- [ ] Whitelist validation preferred over blacklist
- [ ] File uploads validated (type, size, content)

### Authentication & Authorization
- [ ] Auth checks on all protected routes
- [ ] Proper session management
- [ ] Tokens have appropriate expiration
- [ ] Permissions checked before actions
- [ ] No privilege escalation possible

### Data Protection
- [ ] Sensitive data encrypted at rest
- [ ] HTTPS enforced for sensitive data
- [ ] No sensitive data in URLs
- [ ] No sensitive data in logs
- [ ] PII handled according to policy

### Common Vulnerabilities
- [ ] No SQL injection (parameterized queries)
- [ ] No XSS (output encoding)
- [ ] No CSRF (tokens validated)
- [ ] No path traversal
- [ ] No command injection

---

## Performance

### Database
- [ ] No N+1 queries
- [ ] Appropriate indexes exist
- [ ] Queries are optimized
- [ ] Connection pooling used
- [ ] No unnecessary data fetched

### Memory & CPU
- [ ] No memory leaks
- [ ] Large datasets paginated
- [ ] Heavy operations are async
- [ ] Caching used appropriately
- [ ] No blocking operations in hot paths

### Network
- [ ] API calls are minimized
- [ ] Response payloads are lean
- [ ] Compression enabled
- [ ] CDN used for static assets
- [ ] Proper timeout handling

---

## Testing

### Coverage
- [ ] New code has tests
- [ ] Critical paths have 100% coverage
- [ ] Overall coverage meets threshold
- [ ] Edge cases tested
- [ ] Error paths tested

### Quality
- [ ] Tests are readable
- [ ] Tests have clear descriptions
- [ ] One assertion per test (ideally)
- [ ] Tests are independent
- [ ] No flaky tests

### Types
- [ ] Unit tests for business logic
- [ ] Integration tests for APIs
- [ ] E2E tests for critical flows
- [ ] Appropriate use of mocks

---

## Documentation

- [ ] README is current
- [ ] API documentation updated
- [ ] Code comments explain "why"
- [ ] CHANGELOG updated
- [ ] Migration guide if needed

---

## Best Practices

- [ ] No magic numbers
- [ ] No hardcoded strings
- [ ] Environment variables for config
- [ ] Feature flags for risky changes
- [ ] Backward compatibility maintained
- [ ] Dependencies are justified
