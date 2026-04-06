# System for LLMs — Monorepo

Polyglot monorepo containing a Next.js web app and Python FastAPI microservices, built for LLM-first development workflows.

## Stack

| Area | Stack |
|------|-------|
| apps/web/ | Next.js 15, React 19, TypeScript 5 (App Router) |
| services/*/ | Python 3.12, FastAPI 0.115, Pydantic v2, SQLAlchemy 2 (async) |
| packages/*/ | Shared TypeScript libraries (@mono/*) |
| Tooling | Turborepo, pnpm, uv, Docker Compose, GitHub Actions |

## Quick Start

### Prerequisites

- Node.js 20+ and pnpm 9+
- Python 3.12+ and uv
- Docker Desktop

### Setup

```bash
# 1. Clone and install all dependencies
make install

# 2. Copy and configure environment variables
cp .env.example .env
for d in services/*/; do cp "$d/.env.example" "$d/.env"; done

# 3. Start everything
make dev
```

Access:
- Web app: http://localhost:3000
- API Gateway: http://localhost:8000/docs
- Auth Service: http://localhost:8001/docs
- Users Service: http://localhost:8002/docs
- LLM Service: http://localhost:8003/docs

## Common Commands

```bash
make dev          # Start Docker services + web dev server
make test-all     # Run all tests across all stacks
make lint         # Lint all stacks
make format       # Auto-format all code
make docker-up    # Start only Docker services (background)
make help         # List all available commands
```

## Repository Structure

```
.
├── apps/
│   └── web/          → Next.js web app
├── services/
│   ├── api-gateway/  → FastAPI :8000 – main entry, routing, auth middleware
│   ├── auth-service/ → FastAPI :8001 – JWT authentication
│   ├── users-service/→ FastAPI :8002 – user CRUD
│   ├── llm-service/  → FastAPI :8003 – LLM orchestration (LangChain)
│   └── notifications-service/ → FastAPI :8004 – push/email/SMS
├── packages/
│   ├── @mono/types       → shared TypeScript interfaces
│   ├── @mono/ui          → shared React components
│   ├── @mono/utils       → shared JS utilities
│   └── @mono/api-client  → typed HTTP clients
├── infrastructure/   → Docker Compose, Kubernetes manifests
├── docs/             → Architecture and development guides
└── tools/            → Dev scripts and generators
```

## LLM-First Development

This repo is configured for AI-assisted coding with:

- GitHub Copilot: .github/copilot-instructions.md + per-domain instruction files in .github/instructions/
- Cursor: .cursor/rules/ with per-stack MDC rules
- Claude Code: CLAUDE.md with full architecture context and build commands

Custom Copilot agents (in .github/agents/):
- scaffold-service — create a new FastAPI microservice
- scaffold-package — create a new @mono/* shared package

## Contributing

See docs/DEVELOPMENT.md for conventions, branch strategy, and PR guidelines.
