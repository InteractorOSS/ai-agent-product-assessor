# Start Implementation Phase

Initialize the Implementation phase for coding and development.

## Instructions

When this command is invoked, perform the following:

### 1. Verify Planning Completion

Check if planning artifacts exist:
- `docs/planning/architecture.md`
- `docs/planning/tasks.md`

If missing, warn that planning phase may be incomplete.

### 2. Set Context

Update the project phase in CLAUDE.md to "implementation".

### 3. Development Environment Check

Verify development setup:
- [ ] Dependencies installed (`npm install` or equivalent)
- [ ] Environment variables configured (`.env`)
- [ ] Development server runs
- [ ] Tests can execute

### 4. Display Implementation Guidelines

```markdown
## Implementation Phase Guidelines

### Before Coding
1. Review the task requirements
2. Understand the acceptance criteria
3. Check related architecture decisions
4. Identify test cases first (TDD)

### While Coding
1. Follow code style guidelines (`.claude/rules/code-style.md`)
2. Write tests alongside code
3. Commit frequently with meaningful messages
4. Keep changes focused and atomic

### Code Review Preparation
1. Self-review before requesting review
2. Ensure tests pass
3. Update documentation if needed
4. Run linter and formatter

### AI Collaboration Tips
- Explain context before asking for help
- Review generated code carefully
- Ask for explanations when unclear
- Request tests for generated code
```

### 5. Display Current Tasks

If `docs/planning/tasks.md` exists, show:
- Current sprint/milestone tasks
- Task priorities
- Dependencies

### 6. Suggested Prompts

```
"Help me implement [feature] based on the architecture"
"Write tests for [function/component]"
"Review this code for [concerns]"
"Refactor [code] to improve [aspect]"
"Add error handling to [function]"
"Implement [pattern] for [use case]"
```

### 7. Available Skills

```markdown
### Skills for Implementation
- `code-review` - Review code for quality and security
- `test-generator` - Generate test scaffolds
- `doc-generator` - Update documentation
```

## Output

```markdown
## Implementation Phase Initialized

**Status**: Ready for development

### Architecture Summary
[Show key points from architecture doc if available]

### Current Tasks
[List tasks from planning if available]

### Development Checklist
- [ ] Environment configured
- [ ] Dependencies installed
- [ ] Tests running
- [ ] Linter configured

### Guidelines Reference
- Code style: `.claude/rules/code-style.md`
- Testing: `.claude/rules/testing.md`
- Security: `.claude/rules/security.md`
- Git workflow: `.claude/rules/git-workflow.md`

### Skills Available
- `code-review` - Code quality analysis
- `test-generator` - Create test scaffolds
- `doc-generator` - Update documentation

### Quick Commands
```bash
mix phx.server   # Start development server
mix test         # Run tests
mix format       # Format code
mix credo        # Static analysis
```

What would you like to implement first?
```

## Validation Requirements

### Entry Validation
Before starting implementation, verify planning outputs:
```
"Validate planning documents"
```

### During Implementation - Validate Every Change

After generating ANY code, run these validation commands:

```bash
# Required after every code generation
mix compile --warnings-as-errors    # Must pass
mix format --check-formatted        # Must pass
mix credo --strict                  # Should pass

# After writing tests
mix test                            # Must pass
```

### Code Generation Validation Checklist

After generating each type of code:

| Generated Code | Validation |
|---------------|------------|
| Schema/Migration | `mix ecto.migrate`, check rollback works |
| Context functions | `mix compile`, verify pattern matching |
| LiveView | Check mount/handle_params/handle_event pattern |
| Controller | Verify action_fallback, proper responses |
| Tests | `mix test`, verify meaningful assertions |

### Continuous Validation

Run after each significant change:
```elixir
# In IEx during development
recompile()  # Check for compilation errors
```

### Exit Gate Validation
Before proceeding to `/run-review`:

- [ ] All code compiles without warnings
- [ ] All tests pass
- [ ] Code is formatted (`mix format`)
- [ ] Credo passes (`mix credo --strict`)
- [ ] Coverage meets minimum threshold
- [ ] No TODO comments left in code

Run the `validator` skill:
```
"Validate the implementation before code review"
```
