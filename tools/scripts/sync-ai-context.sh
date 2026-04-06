#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

GLOBAL_SRC="$ROOT_DIR/.ai/rules/global.md"
PY_SRC="$ROOT_DIR/.ai/rules/python-fastapi.md"
NEXT_SRC="$ROOT_DIR/.ai/rules/nextjs.md"
FLUTTER_SRC="$ROOT_DIR/.ai/rules/flutter.md"
MICRO_SRC="$ROOT_DIR/.ai/rules/microservices.md"

mkdir -p "$ROOT_DIR/.github/instructions" "$ROOT_DIR/.cursor/rules"

render_copilot_instruction() {
  local description="$1"
  local apply_to="$2"
  local src_file="$3"
  local out_file="$4"

  cat > "$out_file" <<EOF
---
description: "$description"
applyTo: "$apply_to"
---

<!-- GENERATED from $src_file by tools/scripts/sync-ai-context.sh. Do not edit manually. -->

EOF
  cat "$src_file" >> "$out_file"
}

render_cursor_rule() {
  local description="$1"
  local globs="$2"
  local always_apply="$3"
  local src_file="$4"
  local out_file="$5"

  cat > "$out_file" <<EOF
---
description: $description
globs: $globs
alwaysApply: $always_apply
---

<!-- GENERATED from $src_file by tools/scripts/sync-ai-context.sh. Do not edit manually. -->

EOF
  cat "$src_file" >> "$out_file"
}

# Copilot global
cat > "$ROOT_DIR/.github/copilot-instructions.md" <<EOF
<!-- GENERATED from .ai/rules/global.md by tools/scripts/sync-ai-context.sh. Do not edit manually. -->

EOF
cat "$GLOBAL_SRC" >> "$ROOT_DIR/.github/copilot-instructions.md"

# Copilot per-domain instructions
render_copilot_instruction \
  "Use when writing Python FastAPI microservice code: endpoints, route handlers, Pydantic models/schemas, SQLAlchemy models, service logic, repositories, or configuration in the services/ directory." \
  "services/**/*.py" \
  ".ai/rules/python-fastapi.md" \
  "$ROOT_DIR/.github/instructions/python-fastapi.instructions.md"

render_copilot_instruction \
  "Use when writing Next.js App Router code, React components, Server Actions, API routes, layouts, or pages in apps/web/." \
  "apps/web/**" \
  ".ai/rules/nextjs.md" \
  "$ROOT_DIR/.github/instructions/nextjs.instructions.md"

render_copilot_instruction \
  "Use when writing Flutter/Dart code: widgets, Riverpod providers, Freezed models, Go Router navigation, Dio HTTP calls, or feature modules in apps/mobile/." \
  "apps/mobile/**" \
  ".ai/rules/flutter.md" \
  "$ROOT_DIR/.github/instructions/flutter.instructions.md"

render_copilot_instruction \
  "Use when adding new microservices, defining service contracts, working on inter-service communication, configuring Docker, writing Dockerfiles, or following service conventions in the services/ directory." \
  "services/**" \
  ".ai/rules/microservices.md" \
  "$ROOT_DIR/.github/instructions/microservices-conventions.instructions.md"

# Cursor rules
cat > "$ROOT_DIR/.cursor/rules/project.mdc" <<EOF
---
description: Global project rules for system-for-llms-monorepo
alwaysApply: true
---

<!-- GENERATED from .ai/rules/global.md by tools/scripts/sync-ai-context.sh. Do not edit manually. -->

EOF
cat "$GLOBAL_SRC" >> "$ROOT_DIR/.cursor/rules/project.mdc"

render_cursor_rule \
  "Python FastAPI microservices rules for services/ directory" \
  "services/**/*.py" \
  "false" \
  ".ai/rules/python-fastapi.md" \
  "$ROOT_DIR/.cursor/rules/python-fastapi.mdc"

render_cursor_rule \
  "Next.js App Router rules for apps/web/ directory" \
  "apps/web/**" \
  "false" \
  ".ai/rules/nextjs.md" \
  "$ROOT_DIR/.cursor/rules/nextjs.mdc"

render_cursor_rule \
  "Flutter/Dart rules for apps/mobile/ directory" \
  "apps/mobile/**" \
  "false" \
  ".ai/rules/flutter.md" \
  "$ROOT_DIR/.cursor/rules/flutter.mdc"

printf "AI context sync complete.\n"
