# Global Rules

## Project Overview

Polyglot monorepo: Next.js web and Python FastAPI microservices.

## Universal Rules

- Follow existing naming conventions before adding new ones
- No debug logging in production (`print`, `console.log`, `debugPrint`)
- Never hardcode credentials, URLs, or secrets; use environment variables
- Use Conventional Commits: `feat:`, `fix:`, `chore:`, `refactor:`, `test:`, `docs:`

## Stack Summary

- `apps/web/`: Next.js 15, React 19, TypeScript 5
- `services/*/`: Python 3.12, FastAPI 0.115, Pydantic v2, SQLAlchemy 2
- `packages/*/`: `@mono/types`, `@mono/ui`, `@mono/utils`, `@mono/api-client`
