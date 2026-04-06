---
description: "Use when writing Python FastAPI microservice code: endpoints, route handlers, Pydantic models/schemas, SQLAlchemy models, service logic, repositories, or configuration in the services/ directory."
applyTo: "services/**/*.py"
---

<!-- GENERATED from .ai/rules/python-fastapi.md by tools/scripts/sync-ai-context.sh. Do not edit manually. -->

# Python FastAPI Rules

## Architecture

Route handler (thin) -> services layer -> repositories layer.

## Rules

- Route handlers must be `async def`
- Pydantic v2 only: use `model_config = ConfigDict(...)`
- Never use `class Config:`
- Configuration must use `pydantic-settings` in `app/core/config.py`
- Use `Depends()` for injected dependencies
- Route decorators should declare `response_model`
- Use `HTTPException` with detail shape `{ "code": "SNAKE_CASE", "message": "..." }`

## Required Healthcheck

```python
@app.get("/healthz")
async def health_check() -> dict[str, str]:
    return {"status": "ok", "service": settings.SERVICE_NAME}
```
