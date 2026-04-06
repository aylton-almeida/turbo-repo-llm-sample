# AGENTS.md — Monorepo Root

Workspace instructions for AI coding assistants (GitHub Copilot, Claude Code, Cursor).

## What This Repo Is

Polyglot monorepo: Next.js 15 web and Python FastAPI microservices.
See CLAUDE.md for full architecture, build commands, and environment setup.

## Stacks at a Glance

| Path | Stack | Key Libraries |
|------|-------|---------------|
| apps/web/ | TypeScript, Next.js 15, App Router | React 19, @mono/* packages |
| services/*/ | Python 3.12, FastAPI 0.115 | Pydantic v2, SQLAlchemy 2, uv |
| packages/*/ | TypeScript | zero runtime deps preferred |

## Monorepo Navigation

```
apps/web/src/app/               ← Next.js App Router pages + layouts
apps/web/src/components/        ← Web-only React components
apps/web/src/lib/               ← Utility functions and providers
services/<name>/app/            ← FastAPI application code
services/<name>/app/api/v1/     ← Route handlers
services/<name>/app/services/   ← Business logic layer
services/<name>/app/repositories/ ← Data access layer
packages/types/src/             ← Shared TypeScript interfaces
packages/ui/src/                ← Shared React components
packages/utils/src/             ← Shared utilities
packages/api-client/src/        ← Typed HTTP client for all services
```

## Essential Build Commands

| Task | Command |
|------|---------|
| Install everything | make install |
| Start all (dev) | make dev |
| Run tests | make test-all |
| Format all code | make format |
| Lint all code | make lint |
| Docker services up | make docker-up |

Full command reference: make help or see CLAUDE.md.

## Universal Coding Rules

- Python: async def for all FastAPI handlers; Pydantic v2 ConfigDict; strict mypy; ruff lint
- TypeScript: strict: true, no any; Server Components by default in Next.js
- No debug logging in production code (print, console.log, debugPrint)
- Conventional Commits: feat:, fix:, chore:, refactor:, test:, docs:

## Service Port Map

| Service | Port |
|---------|------|
| api-gateway | 8000 |
| auth-service | 8001 |
| users-service | 8002 |
| llm-service | 8003 |
| notifications-service | 8004 |
| PostgreSQL | 5432 |
| Redis | 6379 |
| Next.js web | 3000 |

Next available service port: 8005

## Available Copilot Agents

Open GitHub Copilot Chat and use these agents:

| Agent | Trigger | Purpose |
|-------|---------|---------|
| @scaffold-service | Creating a new microservice | Full FastAPI service scaffold |
| @scaffold-package | Adding a @mono/* package | TS package with build config |

## Sub-area Instructions

- services/AGENTS.md — Python microservices conventions
- apps/AGENTS.md — web conventions
