# AGENTS.md — Services

Instructions for AI assistants working within the `services/` directory.

## Overview

All backend services are Python 3.12 + FastAPI microservices managed with `uv`.
Each service is independently deployable with its own Docker image, dependencies, and database schema.

## Standard Service Layout

```
services/<name>/
  app/
    __init__.py
    main.py                  ← FastAPI app factory (CORS, lifespan, healthcheck)
    api/
      __init__.py
      v1/
        __init__.py
        router.py            ← Aggregates all sub-routers for this service
        <resource>.py        ← e.g. users.py, tokens.py
    core/
      __init__.py
      config.py              ← pydantic-settings Settings class
      dependencies.py        ← FastAPI Depends() injections (db, current_user)
      security.py            ← Password hashing, JWT (auth-service only)
    models/                  ← SQLAlchemy ORM models (DB tables)
      __init__.py
    schemas/                 ← Pydantic v2 request/response schemas
      __init__.py
    services/                ← Business logic layer
      __init__.py
    repositories/            ← Data access (SQLAlchemy queries)
      __init__.py
  tests/
    __init__.py
    conftest.py              ← pytest fixtures (TestClient, db override)
  Dockerfile
  pyproject.toml
  .env.example
```

## Service Port Map

| Service | Port | Primary DB | Redis |
|---------|------|-----------|-------|
| api-gateway | 8000 | — | — |
| auth-service | 8001 | PostgreSQL | ✓ |
| users-service | 8002 | PostgreSQL | — |
| llm-service | 8003 | — | — |
| notifications-service | 8004 | — | ✓ |

Next available port: **8005**

## Pydantic v2 Rules

```python
# ✓ Correct
from pydantic import BaseModel, ConfigDict

class UserRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: str

# ✗ Wrong — Pydantic v1 style
class UserRead(BaseModel):
    class Config:
        orm_mode = True
```

## Required Endpoints

Every service must expose:

```python
@app.get("/healthz")
async def health_check() -> dict[str, str]:
    return {"status": "ok", "service": settings.SERVICE_NAME}
```

## Error Response Shape

All HTTP errors use `HTTPException` with this detail structure:

```python
raise HTTPException(
    status_code=status.HTTP_404_NOT_FOUND,
    detail={"code": "USER_NOT_FOUND", "message": "User not found"},
)
```

## Running a Service Locally (without Docker)

```bash
cd services/<name>
uv sync
uv run fastapi dev app/main.py --port <PORT>
```

## Running Tests

```bash
cd services/<name>
uv run pytest -v --tb=short
# With coverage:
uv run pytest --cov=app --cov-report=term-missing
```

## Adding a New Service Checklist

1. `cp -r services/auth-service services/<new-service>`
2. `pyproject.toml` — update `name`, remove auth-specific deps
3. `app/core/config.py` — set `SERVICE_NAME` and `PORT`
4. `docker-compose.yml` (root) — add service block with next port
5. `.env.example` (root) — add `<NEW>_SERVICE_URL`
6. `.github/workflows/ci-services.yml` — add matrix entry
7. Update this file's port map
