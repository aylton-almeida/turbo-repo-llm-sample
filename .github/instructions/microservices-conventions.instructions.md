---
description: "Use when adding new microservices, defining service contracts, working on inter-service communication, configuring Docker, writing Dockerfiles, or following service conventions in the services/ directory."
applyTo: "services/**"
---

<!-- GENERATED from .ai/rules/microservices.md by tools/scripts/sync-ai-context.sh. Do not edit manually. -->

# Microservices Rules

## Service conventions

- One FastAPI service per folder under `services/`
- Each service owns `pyproject.toml`, `Dockerfile`, and `.env.example`
- All required env vars documented in `.env.example`
- Inter-service URLs must come from env vars

## Required error format

```json
{
  "detail": {
    "code": "SNAKE_CASE",
    "message": "..."
  }
}
```

## Current ports

- api-gateway: 8000
- auth-service: 8001
- users-service: 8002
- llm-service: 8003
- notifications-service: 8004
