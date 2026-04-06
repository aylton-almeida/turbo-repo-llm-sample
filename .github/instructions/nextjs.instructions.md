---
description: "Use when writing Next.js App Router code, React components, Server Actions, API routes, layouts, or pages in apps/web/."
applyTo: "apps/web/**"
---

<!-- GENERATED from .ai/rules/nextjs.md by tools/scripts/sync-ai-context.sh. Do not edit manually. -->

# Next.js Rules

## Component Model

- Server Components by default
- Add `"use client"` only when hooks, browser APIs, or event handlers are required

## Imports

- Shared types from `@mono/types`
- Shared UI from `@mono/ui`
- Shared utils from `@mono/utils`
- Local alias `@/` maps to `apps/web/src/`

## Rules

- Strict TypeScript (`strict: true`), no `any`
- Every page/layout exports `metadata: Metadata`
- API routes use App Router style: `app/api/*/route.ts`
- Prefer server-side data fetching in Server Components
