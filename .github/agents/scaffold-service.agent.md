---
description: "Use when creating a new FastAPI microservice in services/. Scaffolds the full service folder structure including app/, tests/, Dockerfile, pyproject.toml, and updates docker-compose.yml and CI config."
tools: [read, edit, search]
user-invocable: true
---

You are an expert at scaffolding Python FastAPI microservices in this monorepo.

## Your Task

When asked to create a new service named `<service-name>`:

### 1. Create the directory structure under `services/<service-name>/`

**`app/__init__.py`** — empty

**`app/main.py`**:
```python
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.v1.router import router as api_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    yield  # startup / shutdown hooks go here

app = FastAPI(
    title=settings.SERVICE_NAME,
    version=settings.VERSION,
    docs_url="/docs" if settings.APP_ENV != "production" else None,
    redoc_url=None,
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(api_router, prefix="/api/v1")

@app.get("/healthz", tags=["health"])
async def health_check() -> dict[str, str]:
    return {"status": "ok", "service": settings.SERVICE_NAME}
```

**`app/core/__init__.py`** — empty

**`app/core/config.py`**:
```python
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    SERVICE_NAME: str = "<service-name>"
    VERSION: str = "0.1.0"
    APP_ENV: str = "development"
    PORT: int = <PORT>
    LOG_LEVEL: str = "info"
    CORS_ORIGINS: list[str] = ["http://localhost:3000"]

settings = Settings()
```

**`app/core/dependencies.py`** — placeholder stubs for `Depends()` injections

**`app/api/__init__.py`**, **`app/api/v1/__init__.py`** — empty

**`app/api/v1/router.py`**:
```python
from fastapi import APIRouter
router = APIRouter()
# import and include sub-routers here
```

**`app/models/__init__.py`**, **`app/schemas/__init__.py`**, **`app/services/__init__.py`**, **`app/repositories/__init__.py`** — empty

**`tests/__init__.py`** — empty

**`tests/conftest.py`**:
```python
import pytest
from httpx import AsyncClient, ASGITransport
from app.main import app

@pytest.fixture
async def client() -> AsyncClient:
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as c:
        yield c
```

**`Dockerfile`** — uv multi-stage build (see microservices-conventions.instructions.md)

**`pyproject.toml`** — standard FastAPI deps (see microservices-conventions.instructions.md template)

**`.env.example`** — document all required env vars

### 2. Update root files

- `docker-compose.yml` — add service block (use next available port from `services/AGENTS.md`)
- `.env.example` — add `<SERVICE_NAME_UPPER>_URL=http://localhost:<PORT>`
- `.github/workflows/ci-services.yml` — add `<service-name>` to the matrix
- `services/AGENTS.md` — update port map

## Constraints

- Always check the port map in `services/AGENTS.md` before assigning a port
- Use `uv` — never `pip`, `poetry`, or `conda`
- All route handlers must be `async def`
- Follow the Pydantic v2 patterns in `.github/instructions/python-fastapi.instructions.md`
- Remind the user to copy `.env.example` to `.env` after scaffolding
