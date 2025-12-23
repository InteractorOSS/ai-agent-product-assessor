---
name: doc-generator
description: Auto-generate and update project documentation including README, API docs, and changelogs. Use when adding features, updating APIs, or preparing releases.
---

# Documentation Generator Skill

Automatically generate and maintain project documentation.

## When to Use

- After implementing new features
- When updating APIs
- Before releases (changelog)
- When onboarding documentation is outdated
- After significant refactoring

## Instructions

### Step 1: Identify Documentation Needs

Analyze the codebase to determine what documentation is needed:

1. **README.md** - Project overview, setup, usage
2. **API Documentation** - Endpoints, parameters, responses
3. **CHANGELOG.md** - Version history
4. **Code Comments** - JSDoc/docstrings
5. **Architecture Docs** - System design

### Step 2: README Generation

Generate or update README with these sections:

```markdown
# Project Name

Brief description of the project.

## Features

- Feature 1
- Feature 2

## Prerequisites

- Node.js >= 18
- npm >= 9

## Installation

\`\`\`bash
git clone <repo>
cd <project>
npm install
\`\`\`

## Configuration

Copy `.env.example` to `.env` and configure:

| Variable | Description | Required |
|----------|-------------|----------|
| `VAR_1` | Description | Yes |

## Usage

\`\`\`bash
npm run dev     # Development
npm run build   # Production build
npm test        # Run tests
\`\`\`

## API Reference

Brief overview or link to API docs.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License

[License Type]
```

### Step 3: API Documentation

For each endpoint, document:

```markdown
## Endpoint Name

Brief description.

**URL**: `METHOD /path`

**Authentication**: Required/None

### Request

**Headers**:
| Name | Value | Required |
|------|-------|----------|
| `Authorization` | `Bearer <token>` | Yes |

**Path Parameters**:
| Name | Type | Description |
|------|------|-------------|
| `id` | string | Resource ID |

**Query Parameters**:
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `page` | number | 1 | Page number |

**Body**:
\`\`\`json
{
  "field": "value"
}
\`\`\`

### Response

**Success (200)**:
\`\`\`json
{
  "data": { ... }
}
\`\`\`

**Error (400)**:
\`\`\`json
{
  "error": "Description"
}
\`\`\`

### Example

\`\`\`bash
curl -X GET "https://api.example.com/endpoint" \
  -H "Authorization: Bearer token"
\`\`\`
```

### Step 4: Changelog Generation

Follow [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Now removed features

### Fixed
- Bug fixes

### Security
- Vulnerability fixes

## [1.0.0] - YYYY-MM-DD

### Added
- Initial release
```

### Step 5: Code Documentation

#### JavaScript/TypeScript (JSDoc)

```javascript
/**
 * Brief description of the function.
 *
 * @description Longer description if needed.
 * @param {string} name - The user's name
 * @param {Object} options - Configuration options
 * @param {boolean} [options.verbose=false] - Enable verbose mode
 * @returns {Promise<User>} The created user
 * @throws {ValidationError} If name is invalid
 * @example
 * const user = await createUser('John', { verbose: true });
 */
async function createUser(name, options = {}) {
  // ...
}
```

#### Python (Docstrings)

```python
def create_user(name: str, options: dict = None) -> User:
    """Create a new user.

    Args:
        name: The user's name.
        options: Configuration options.
            - verbose (bool): Enable verbose mode. Default: False.

    Returns:
        User: The created user object.

    Raises:
        ValidationError: If name is invalid.

    Example:
        >>> user = create_user('John', {'verbose': True})
    """
    pass
```

## Output Format

When generating documentation:

```markdown
## Documentation Update Summary

**Files Updated**:
- README.md - Added installation section
- docs/api.md - Documented 3 new endpoints
- CHANGELOG.md - Added v1.2.0 entries

**New Documentation**:
- docs/architecture.md - Created

**Recommendations**:
- [ ] Add examples to User API
- [ ] Update deployment guide
- [ ] Add troubleshooting section
```

## Templates

### Function Documentation Template
```
/**
 * [Brief description - what does it do?]
 *
 * @param {Type} paramName - [Description]
 * @returns {ReturnType} [What is returned]
 * @throws {ErrorType} [When is it thrown]
 * @example
 * [Usage example]
 */
```

### Module Documentation Template
```
/**
 * @module ModuleName
 * @description [What this module provides]
 *
 * @example
 * import { feature } from './module';
 * feature.doSomething();
 */
```

## Best Practices

1. **Keep it current** - Update docs with code changes
2. **Be concise** - Avoid unnecessary verbosity
3. **Use examples** - Show, don't just tell
4. **Maintain consistency** - Same format throughout
5. **Document the "why"** - Not just the "what"
6. **Version appropriately** - Keep changelog updated
