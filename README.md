# Product Development Template

**⚠️ TEMPLATE PLACEHOLDER - REPLACE THIS FILE**

This README.md is a temporary placeholder. Once you initialize your project and complete development, **replace this file with your application-specific README**.

---

## 📚 Template Documentation

### For Setting Up a New Project (Internal Team)

**👉 [README_SETUP.md](README_SETUP.md)** - Start here!

Complete project creation methodology:
- Project initialization with `init-project.sh`
- The Six Phases (Discovery → Planning → Implementation → Testing → Review → Deployment)
- Setup commands: `/start-discovery`, `/start-planning`, `/start-implementation`
- Proprietary setup workflow

**⚠️ Contains proprietary methodology - internal use only**

---

### For Template Components & Tools (External/Internal)

**👉 [README_i.md](README_i.md)** - Template reference

Shareable template tools and components:
- AI skills: validator, code-review, security-audit, test-generator, etc.
- Development rules and standards
- Template syncing and updates
- UI design system
- Contributing guidelines

**✓ Safe to share with external engineers**

---

## Quick Start

### Creating a New Project

```bash
# 1. Clone template
git clone https://github.com/pulzze/product-dev-template.git my-project
cd my-project

# 2. Initialize project
./scripts/setup/init-project.sh my-project web

# 3. Start development
./scripts/start.sh --setup

# 4. Follow the six-phase workflow
# See README_SETUP.md for complete guide
```

### Using Template Tools in Existing Project

```bash
# Sync latest template updates
./scripts/i/sync-template.sh

# Use template skills
# Example: "use validator skill to check this code"

# See README_i.md for complete guide
```

---

## When to Replace This README

Replace this README.md with your application-specific README when:
- ✅ Project initialization is complete
- ✅ Core application features are implemented
- ✅ You're ready to document YOUR application

Your new README should describe:
- What your application does
- How to install and run it
- API documentation (if applicable)
- Configuration options
- Contributing guidelines for your project

**Template documentation** (README_SETUP.md and README_i.md) will remain available for reference.

---

## Template Contents

**Template Components** (`/i/` folders - Shareable):
- Skills, rules, commands, documentation, scripts

**Setup Components** (`/setup/` folders - Proprietary):
- Six-phase methodology, setup commands, project initialization

See README_SETUP.md and README_i.md for details.

---

**Choose Your Path**:
- 🏗️ **Setting up a new project?** → [README_SETUP.md](README_SETUP.md)
- 🛠️ **Using template tools?** → [README_i.md](README_i.md)
- 📝 **Ready to document your app?** → Replace this README.md

---

Built with Claude Code. Template by Pulzze.
