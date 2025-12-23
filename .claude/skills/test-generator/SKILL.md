---
name: test-generator
description: Generate test scaffolds, suggest test cases, and analyze coverage gaps. Use when implementing new features, fixing bugs, or improving test coverage.
---

# Test Generator Skill

Generate comprehensive test suites following TDD principles and best practices.

## When to Use

- Before implementing new features (TDD)
- When fixing bugs (write regression test first)
- To improve test coverage
- When refactoring existing code
- During code review to identify missing tests

## Instructions

### Step 1: Analyze the Code

Before generating tests:
1. Understand the function/component purpose
2. Identify inputs and outputs
3. Find edge cases
4. Determine error conditions
5. Check for side effects

### Step 2: Test Categories

Generate tests for each category:

#### Unit Tests
- Individual functions
- Pure logic
- Utilities
- Validators

#### Integration Tests
- API endpoints
- Database operations
- Service interactions
- External APIs (mocked)

#### E2E Tests
- Critical user journeys
- Authentication flows
- Core business processes

### Step 3: Test Structure

Use AAA (Arrange-Act-Assert) pattern:

```javascript
describe('ComponentName', () => {
  describe('methodName', () => {
    it('should [expected behavior] when [condition]', () => {
      // Arrange - Set up test data and conditions
      const input = { ... };

      // Act - Execute the code being tested
      const result = methodName(input);

      // Assert - Verify the result
      expect(result).toBe(expected);
    });
  });
});
```

### Step 4: Generate Test Cases

For each function, generate tests for:

#### Happy Path
- Normal input produces expected output
- Common use cases work correctly

#### Edge Cases
- Empty inputs
- Boundary values (min, max)
- Null/undefined handling
- Large inputs

#### Error Cases
- Invalid inputs
- Missing required fields
- Type mismatches
- Permission errors

#### State Changes
- Before and after states
- Side effects verified
- Cleanup performed

## Templates

### JavaScript/TypeScript (Jest)

```javascript
import { functionName } from './module';

describe('functionName', () => {
  // Setup and teardown
  beforeEach(() => {
    // Reset state before each test
  });

  afterEach(() => {
    // Cleanup after each test
  });

  describe('when given valid input', () => {
    it('should return expected result', () => {
      const input = { name: 'test' };
      const result = functionName(input);
      expect(result).toEqual({ success: true });
    });

    it('should handle optional parameters', () => {
      const result = functionName({ name: 'test' });
      expect(result.options).toBeUndefined();
    });
  });

  describe('when given invalid input', () => {
    it('should throw ValidationError for missing name', () => {
      expect(() => functionName({}))
        .toThrow(ValidationError);
    });

    it('should throw TypeError for non-object input', () => {
      expect(() => functionName('string'))
        .toThrow(TypeError);
    });
  });

  describe('edge cases', () => {
    it('should handle empty string name', () => {
      const result = functionName({ name: '' });
      expect(result.name).toBe('');
    });

    it('should handle very long names', () => {
      const longName = 'a'.repeat(10000);
      const result = functionName({ name: longName });
      expect(result.name).toBe(longName);
    });
  });
});
```

### React Component (Testing Library)

```javascript
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ComponentName } from './ComponentName';

describe('ComponentName', () => {
  const defaultProps = {
    title: 'Test Title',
    onSubmit: jest.fn(),
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders correctly with required props', () => {
    render(<ComponentName {...defaultProps} />);

    expect(screen.getByText('Test Title')).toBeInTheDocument();
  });

  it('calls onSubmit when form is submitted', async () => {
    const user = userEvent.setup();
    render(<ComponentName {...defaultProps} />);

    await user.type(screen.getByLabelText('Name'), 'John');
    await user.click(screen.getByRole('button', { name: /submit/i }));

    expect(defaultProps.onSubmit).toHaveBeenCalledWith({ name: 'John' });
  });

  it('displays error message for invalid input', async () => {
    const user = userEvent.setup();
    render(<ComponentName {...defaultProps} />);

    await user.click(screen.getByRole('button', { name: /submit/i }));

    expect(screen.getByText('Name is required')).toBeInTheDocument();
  });

  it('disables submit button while loading', () => {
    render(<ComponentName {...defaultProps} isLoading />);

    expect(screen.getByRole('button', { name: /submit/i })).toBeDisabled();
  });
});
```

### API Endpoint (Supertest)

```javascript
import request from 'supertest';
import { app } from '../app';
import { db } from '../database';

describe('POST /api/users', () => {
  beforeEach(async () => {
    await db.clear('users');
  });

  afterAll(async () => {
    await db.close();
  });

  describe('with valid data', () => {
    it('should create user and return 201', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({ email: 'test@example.com', name: 'Test' })
        .expect(201);

      expect(response.body).toMatchObject({
        id: expect.any(String),
        email: 'test@example.com',
        name: 'Test',
      });
    });
  });

  describe('with invalid data', () => {
    it('should return 400 for missing email', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({ name: 'Test' })
        .expect(400);

      expect(response.body.error).toBe('Email is required');
    });

    it('should return 400 for invalid email format', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({ email: 'invalid', name: 'Test' })
        .expect(400);

      expect(response.body.error).toBe('Invalid email format');
    });
  });

  describe('with duplicate email', () => {
    it('should return 409 conflict', async () => {
      await request(app)
        .post('/api/users')
        .send({ email: 'test@example.com', name: 'Test' });

      const response = await request(app)
        .post('/api/users')
        .send({ email: 'test@example.com', name: 'Test 2' })
        .expect(409);

      expect(response.body.error).toBe('Email already exists');
    });
  });
});
```

### Python (pytest)

```python
import pytest
from module import function_name

class TestFunctionName:
    """Tests for function_name."""

    def test_returns_expected_result_with_valid_input(self):
        """Should return expected result when given valid input."""
        result = function_name({'name': 'test'})
        assert result == {'success': True}

    def test_raises_validation_error_for_missing_name(self):
        """Should raise ValidationError when name is missing."""
        with pytest.raises(ValidationError) as exc_info:
            function_name({})
        assert 'name is required' in str(exc_info.value)

    @pytest.mark.parametrize('input,expected', [
        ('', ''),
        ('a', 'a'),
        ('a' * 1000, 'a' * 1000),
    ])
    def test_handles_various_name_lengths(self, input, expected):
        """Should handle names of various lengths."""
        result = function_name({'name': input})
        assert result['name'] == expected

    @pytest.fixture
    def mock_database(self, mocker):
        """Provide a mocked database connection."""
        return mocker.patch('module.database')

    def test_saves_to_database(self, mock_database):
        """Should save the result to database."""
        function_name({'name': 'test'})
        mock_database.save.assert_called_once()
```

## Output Format

When generating tests:

```markdown
## Test Generation Summary

**Target**: `src/services/userService.ts`
**Test File**: `src/services/__tests__/userService.test.ts`

### Tests Generated

| Category | Count | Description |
|----------|-------|-------------|
| Happy Path | 3 | Normal operation tests |
| Edge Cases | 5 | Boundary and empty input tests |
| Error Cases | 4 | Invalid input and error handling |
| Integration | 2 | Database interaction tests |

### Coverage Estimate
- Statements: ~95%
- Branches: ~90%
- Functions: 100%

### Recommended Additional Tests
- [ ] Test concurrent access
- [ ] Test timeout handling
- [ ] Test rate limiting
```

## Best Practices

1. **One assertion per test** (when practical)
2. **Descriptive test names** - Should read like documentation
3. **Independent tests** - No test should depend on another
4. **Fast tests** - Mock external dependencies
5. **Deterministic** - Same result every time
6. **Test behavior, not implementation**
