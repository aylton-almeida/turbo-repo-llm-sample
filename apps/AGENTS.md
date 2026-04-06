# AGENTS.md — Apps

Instructions for AI assistants working within the apps/ directory.

## Web App (apps/web/) — Next.js 15

Stack: Next.js 15, React 19, TypeScript 5, App Router.

### File Structure

```
apps/web/src/
  app/                        ← App Router root
    (auth)/                   ← Route group: login, register, forgot-password
    (dashboard)/              ← Route group: protected pages
      layout.tsx              ← Protected layout with auth check
    api/                      ← Route handlers (server-side API)
    layout.tsx                ← Root layout
    page.tsx                  ← Home page (/)
    globals.css
  components/
    ui/                       ← Primitive components (Button, Input, Modal)
    <feature>/                ← Feature-scoped components
  lib/
    actions/                  ← Server Actions ("use server")
    api/                      ← Fetch wrappers calling @mono/api-client
    utils.ts
  types/                      ← Page/component-local types
```

### Key Rules

- Server Components by default; add "use client" only when required
- Import shared types from @mono/types
- Import shared UI from @mono/ui
- Use @/ alias for local imports from apps/web/src/
- Every page file exports metadata: Metadata
- API route handlers: app/api/<resource>/route.ts (App Router)
- Prefer server-side data fetching in Server Components

### Running

```bash
cd apps/web
pnpm dev
pnpm build
pnpm type-check
```
