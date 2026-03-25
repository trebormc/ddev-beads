[![tests](https://github.com/trebormc/ddev-beads/actions/workflows/tests.yml/badge.svg)](https://github.com/trebormc/ddev-beads/actions/workflows/tests.yml)

# ddev-beads

A DDEV add-on that provides [Beads](https://github.com/steveyegge/beads) (bd), a git-backed task tracker for AI agents, in a dedicated container. Other AI containers (OpenCode, Claude Code, Ralph) delegate task tracking to this container via `docker exec`.

## Quick Start

```bash
# Install the add-on
ddev add-on get trebormc/ddev-beads
ddev restart

# Use from host
ddev bd ready
ddev bd create "Implement feature X" -p 1
ddev bd close bd-abc --reason "Done"
```

## Prerequisites

- [DDEV](https://ddev.readthedocs.io/) >= v1.23.5

## Installation

```bash
ddev add-on get trebormc/ddev-beads
```

This add-on is automatically installed as a dependency when you install [ddev-opencode](https://github.com/trebormc/ddev-opencode), [ddev-claude-code](https://github.com/trebormc/ddev-claude-code), or [ddev-ralph](https://github.com/trebormc/ddev-ralph).

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    DDEV Docker Network                    │
│                                                          │
│  ┌──────────────┐                                        │
│  │   Beads      │  <-- docker exec from other containers │
│  │  Container   │                                        │
│  │  - bd CLI    │  Shared volume: /var/www/html/.beads/  │
│  │  - node 22   │                                        │
│  └──────────────┘                                        │
│        ^    ^    ^                                        │
│        │    │    │  docker exec $BEADS_CONTAINER bd ...   │
│        │    │    │                                        │
│  ┌─────┘    │    └─────┐                                 │
│  │          │          │                                  │
│  OpenCode  Claude   Ralph                                │
│            Code                                          │
└──────────────────────────────────────────────────────────┘
```

All AI containers access Beads via `docker exec $BEADS_CONTAINER bd <command>`. A wrapper function is installed in each container so that `bd` commands work transparently.

The `.beads/` directory lives in the project root (`/var/www/html/.beads/`), shared across all containers via the project volume.

## Commands

### `ddev bd`

Execute Beads commands:

```bash
ddev bd ready                              # List ready tasks
ddev bd create "Implement login" -p 1      # Create task (P1 priority)
ddev bd update bd-abc --status in_progress # Mark in progress
ddev bd update bd-abc --notes "Working..." # Add progress notes
ddev bd close bd-abc --reason "Done"       # Close task
ddev bd sync                               # Sync state
ddev bd prime                              # Get context
```

### Priority Levels

| Level | Meaning |
|-------|---------|
| P0 | Critical -- blockers, security |
| P1 | High -- important features |
| P2 | Medium -- normal tasks |
| P3 | Low -- nice-to-haves |

## Related

- [ddev-agents-sync](https://github.com/trebormc/ddev-agents-sync) -- Agents auto-sync from git
- [ddev-opencode](https://github.com/trebormc/ddev-opencode) -- OpenCode AI container
- [ddev-claude-code](https://github.com/trebormc/ddev-claude-code) -- Claude Code container
- [ddev-ralph](https://github.com/trebormc/ddev-ralph) -- Autonomous task runner
- [drupal-ai-agents](https://github.com/trebormc/drupal-ai-agents) -- Agent definitions for Drupal

## Disclaimer

This project is not affiliated with Anthropic, OpenCode, Beads, Playwright, Microsoft, or DDEV. AI-generated code may contain errors -- always review changes before deploying to production. See [menetray.com](https://menetray.com) for more information and [DruScan](https://druscan.com) for Drupal auditing tools.

## License

Apache-2.0. See [LICENSE](LICENSE).
