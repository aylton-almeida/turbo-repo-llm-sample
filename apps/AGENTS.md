# AGENTS.md — Apps

Instructions for AI assistants working within the `apps/` directory.

## Web App (`apps/web/`) — Next.js 15

**Stack**: Next.js 15, React 19, TypeScript 5, App Router

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

- **Server Components by default** — only add `"use client"` for: React hooks, browser APIs, event listeners, client-only libs
- Import shared types with `import type { User } from '@mono/types'`
- Import shared UI with `import { Button } from '@mono/ui'`
- Local imports use `@/` alias (maps to `apps/web/src/`)
- Every page file exports `metadata: Metadata`
- API route handlers: `app/api/<resource>/route.ts` (App Router, not Pages Router)
- Data fetching: `async/await` in Server Components — no `useEffect` for data

### Running

```bash
cd apps/web
pnpm dev      # http://localhost:3000
pnpm build
pnpm type-check
```

---

## Mobile App (`apps/mobile/`) — Flutter

**Stack**: Flutter 3.22, Dart 3.3, Riverpod 2 (codegen), Freezed, Go Router, Dio

### File Structure

```
apps/mobile/lib/
  main.dart                   ← Entrypoint: ProviderScope → App
  app/
    app.dart                  ← MaterialApp.router setup
    router.dart               ← GoRouter configuration (routerProvider)
    theme.dart                ← AppTheme (light + dark)
  features/
    <name>/
      data/
        datasources/          ← Dio API calls
        models/               ← Freezed + json_serializable models
        repositories/         ← Concrete repository implementations
      domain/
        entities/             ← Pure Dart business objects
        repositories/         ← Abstract repository interfaces
        usecases/             ← Single-purpose use cases
      presentation/
        pages/                ← Full-screen ConsumerWidget pages
        widgets/              ← Feature-scoped widgets
        providers/            ← @riverpod providers (+ .g.dart generated)
  shared/
    widgets/                  ← App-wide reusable widgets
    utils/                    ← Dart utility functions
  core/
    network/                  ← Dio client setup + interceptors
    constants.dart
```

### Key Rules

- **Riverpod codegen** — always use `@riverpod` annotation; run `make gen` after changes
- **Freezed models** — `@freezed` for all data transfer and domain objects
- **Go Router** — always use named routes; never `Navigator.push()`
- `ConsumerWidget` over `StatelessWidget` when Riverpod state is needed
- Pass `super.key` in all widget constructors
- Never use `print()` — use `debugPrint()` in debug blocks only
- HTTP via injected Dio instance; never create `Dio()` inline

### Running

```bash
cd apps/mobile
flutter run         # requires emulator or physical device
flutter test        # run unit + widget tests
make gen            # regenerate Riverpod + Freezed code
```
