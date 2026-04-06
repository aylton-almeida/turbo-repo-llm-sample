# System for LLMs — Monorepo

## Overview

Polyglot monorepo: **Next.js 15** web app, **Flutter** mobile app, and **Python FastAPI** microservices. Designed for LLM-first development with GitHub Copilot, Cursor, and Claude Code.

## Architecture

```
┌──────────────────────┐    ┌────────────────────────────┐
│   Web (Next.js :3000)│    │   Mobile (Flutter)          │
└──────────┬───────────┘    └─────────────┬──────────────┘
           │                              │
           └──────────────┬───────────────┘
                          ▼
           ┌──────────────────────────────┐
           │  API Gateway  (FastAPI :8000) │
           │  routing · auth middleware    │
           │  rate limiting                │
           └──────┬──────┬──────┬─────────┘
                  │      │      │
         ┌────────┘  ┌───┘  ┌───┘
         ▼           ▼      ▼
  Auth(:8001)  Users(:8002)  LLM(:8003)  Notifications(:8004)
  PostgreSQL   PostgreSQL    OpenAI/     Redis
  Redis                      Anthropic
```

## Repository Layout

```
.
├── apps/
│   ├── web/          → Next.js 15 (App Router, TypeScript)
│   └── mobile/       → Flutter 3.22 (Dart, Riverpod, feature-first)
├── services/
│   ├── api-gateway/  → FastAPI :8000 — main entry, auth middleware
│   ├── auth-service/ → FastAPI :8001 — JWT / OAuth
│   ├── users-service/→ FastAPI :8002 — user CRUD
│   ├── llm-service/  → FastAPI :8003 — LLM orchestration (LangChain)
│   └── notifications-service/ → FastAPI :8004 — push/email/SMS
├── packages/
│   ├── types/        → @mono/types      shared TypeScript interfaces
│   ├── ui/           → @mono/ui         shared React components
│   ├── utils/        → @mono/utils      shared JS utilities
│   └── api-client/   → @mono/api-client typed HTTP clients
├── infrastructure/   → Docker Compose, Kubernetes manifests
├── docs/             → Architecture decisions, dev guides
└── tools/scripts/    → Seed scripts, generators
```

## Prerequisites

- Node.js 20+, pnpm 9+
- Python 3.12+, uv (`curl -LsSf https://astral.sh/uv/install.sh | sh`)
- Flutter 3.22+ / Dart SDK 3.3+
- Docker Desktop

## Install All Dependencies

```bash
make install
# Equivalent to:
pnpm install                                              # JS/TS
cd apps/mobile && flutter pub get                        # Flutter
cd apps/mobile && dart run build_runner build             # codegen
melos bootstrap                                          # Flutter workspace
# Each Python service installs its own env: cd services/<name> && uv sync
```

## Run Everything Locally

```bash
make dev                    # Docker services (bg) + web dev server

# Or individually:
make docker-up              # PostgreSQL + Redis + all FastAPI services (background)
make dev-web                # http://localhost:3000
make dev-mobile             # requires emulator/device

# Run a single Python service without Docker (hot reload):
cd services/auth-service
uv sync
uv run fastapi dev app/main.py --port 8001
```

## Build

```bash
make build                  # JS/TS (Turborepo)
make build-mobile           # Flutter app bundle
pnpm turbo run build --filter=@mono/web   # web only
```

## Test

```bash
make test-all               # all stacks
pnpm turbo run test         # JS/TS only
make test-services          # all Python services (pytest)
make test-mobile            # Flutter
# Single service:
cd services/auth-service && uv run pytest -v
```

## Lint & Format

```bash
make lint       # ESLint + flutter analyze + ruff + mypy
make format     # Prettier + dart format + ruff format
```

## Code Generation (Flutter)

After adding or modifying Riverpod providers or Freezed models:

```bash
make gen
# or:
cd apps/mobile && dart run build_runner build --delete-conflicting-outputs
```

## Adding a New Microservice

1. Copy an existing service: `cp -r services/auth-service services/my-service`
2. Update `services/my-service/pyproject.toml` — set `name = "my-service"`
3. Update `services/my-service/app/core/config.py` — set `SERVICE_NAME`, `PORT`
4. Add service block to `docker-compose.yml` (next port after 8004)
5. Add `MY_SERVICE_URL` to root `.env.example`
6. Add matrix entry to `.github/workflows/ci-services.yml`
7. Update `services/AGENTS.md` port map

Use the Copilot agent: open Copilot Chat → `@scaffold-service`

## Adding a Shared TypeScript Package

1. `mkdir -p packages/<name>/src`
2. Create `packages/<name>/package.json` with `"name": "@mono/<name>"`
3. Create `packages/<name>/tsconfig.json` (extend `../../tsconfig.base.json`)
4. Create `packages/<name>/src/index.ts`
5. Add path alias to `tsconfig.base.json`
6. Add `"@mono/<name>": "workspace:*"` to consuming app's `package.json`

Use the Copilot agent: open Copilot Chat → `@scaffold-package`

## Adding a Flutter Feature

1. Create `apps/mobile/lib/features/<name>/` with `data/`, `domain/`, `presentation/`
2. Add Riverpod provider with `@riverpod` annotation
3. Add Freezed model with `@freezed` annotation
4. Register route in `apps/mobile/lib/app/router.dart`
5. Run `make gen` to regenerate code

Use the Copilot agent: open Copilot Chat → `@scaffold-flutter-feature`

## Service Communication

- All clients hit the **API Gateway** at `:8000`
- Services communicate internally via HTTP REST (env var `<UPSTREAM>_SERVICE_URL`)
- Service URLs injected via environment variables — never hardcoded
- Error response shape: `{"detail": {"code": "SNAKE_CASE", "message": "..."}}`
- All services expose `GET /healthz → {"status": "ok", "service": "<name>"}`

## Key Dependencies

| Area | Libraries |
|------|-----------|
| Web | Next.js 15, React 19, TypeScript 5 |
| Mobile | Flutter 3.22, Riverpod 2, Freezed, Go Router, Dio |
| Services | FastAPI 0.115, Pydantic v2, SQLAlchemy 2, Alembic, asyncpg |
| LLM Service | LangChain, LangGraph, OpenAI SDK, Anthropic SDK |
| DB / Cache | PostgreSQL 16 (asyncpg), Redis 7 |
| Tooling | Turborepo 2, pnpm 9, uv, Melos, Docker Compose, GitHub Actions |

## Environment Variables

Copy `.env.example` → `.env` and `services/<name>/.env.example` → `services/<name>/.env`.

See `.env.example` for documentation on all variables.

## Docs

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — architecture decisions
- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) — dev conventions, branch strategy, PR guidelines
