# AI Context Source of Truth

This folder is the canonical source for AI coding guidance across the monorepo.

## Why this exists

Different tools require different file formats and locations:
- GitHub Copilot: `.github/instructions/*.instructions.md`, `.github/copilot-instructions.md`
- Cursor: `.cursor/rules/*.mdc`
- Claude Code: `CLAUDE.md`, `AGENTS.md`

Instead of manually duplicating guidance in each format, all shared rule content lives in `.ai/rules/`.

## Workflow

1. Update files in `.ai/rules/`
2. Run `make ai-sync`
3. Commit both source files and generated tool-specific files

## Canonical files

- `.ai/rules/global.md`
- `.ai/rules/python-fastapi.md`
- `.ai/rules/nextjs.md`
- `.ai/rules/flutter.md`
- `.ai/rules/microservices.md`

## Generated files (do not edit manually)

- `.github/copilot-instructions.md`
- `.github/instructions/*.instructions.md`
- `.cursor/rules/*.mdc`

If there is a conflict between generated files and manual edits, rerun `make ai-sync` and keep the generated output.
