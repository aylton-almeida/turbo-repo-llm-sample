.PHONY: dev dev-web dev-mobile dev-services install build build-mobile \
	test test-all test-services test-mobile lint format docker-up docker-down \
	ai-sync \
        docker-rebuild gen clean help

ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# ─────────────────────────────────────────────────────────────
# Development
# ─────────────────────────────────────────────────────────────
dev: docker-up
	pnpm turbo run dev --parallel

dev-web:
	cd apps/web && pnpm dev

dev-mobile:
	cd apps/mobile && flutter run

dev-services:
	docker compose up --build

# ─────────────────────────────────────────────────────────────
# Install / Bootstrap
# ─────────────────────────────────────────────────────────────
install:
	pnpm install
	cd apps/mobile && flutter pub get && dart run build_runner build --delete-conflicting-outputs
	melos bootstrap

# ─────────────────────────────────────────────────────────────
# Build
# ─────────────────────────────────────────────────────────────
build:
	pnpm turbo run build

build-mobile:
	cd apps/mobile && flutter build appbundle

# ─────────────────────────────────────────────────────────────
# Code Generation (Flutter)
# ─────────────────────────────────────────────────────────────
gen:
	cd apps/mobile && dart run build_runner build --delete-conflicting-outputs

# ─────────────────────────────────────────────────────────────
# AI Context Sync
# ─────────────────────────────────────────────────────────────
ai-sync:
	bash tools/scripts/sync-ai-context.sh

# ─────────────────────────────────────────────────────────────
# Test
# ─────────────────────────────────────────────────────────────
test:
	pnpm turbo run test

test-services:
	@for service in services/*/; do \
		echo "\n── Testing $$service ──────────────────────"; \
		(cd "$$service" && uv run pytest --tb=short -q); \
	done

test-mobile:
	cd apps/mobile && flutter test

test-all: test test-services test-mobile

# ─────────────────────────────────────────────────────────────
# Lint & Format
# ─────────────────────────────────────────────────────────────
lint:
	pnpm turbo run lint
	cd apps/mobile && flutter analyze
	@for service in services/*/; do \
		echo "\n── Linting $$service ──────────────────────"; \
		(cd "$$service" && uv run ruff check . && uv run mypy app/); \
	done

format:
	pnpm run format
	cd apps/mobile && dart format .
	@for service in services/*/; do \
		(cd "$$service" && uv run ruff format .); \
	done

# ─────────────────────────────────────────────────────────────
# Docker
# ─────────────────────────────────────────────────────────────
docker-up:
	docker compose up -d

docker-down:
	docker compose down

docker-rebuild:
	docker compose up --build -d

# ─────────────────────────────────────────────────────────────
# Clean
# ─────────────────────────────────────────────────────────────
clean:
	pnpm turbo run clean
	cd apps/mobile && flutter clean
	pnpm store prune

# ─────────────────────────────────────────────────────────────
# Help
# ─────────────────────────────────────────────────────────────
help:
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Development:"
	@echo "  dev              Start all services (Docker + Turborepo dev)"
	@echo "  dev-web          Start only the Next.js web app"
	@echo "  dev-mobile       Start the Flutter mobile app"
	@echo "  dev-services     Start backend services via Docker Compose (with rebuild)"
	@echo ""
	@echo "Setup:"
	@echo "  install          Install all dependencies (JS, Flutter, Python via uv)"
	@echo ""
	@echo "Build:"
	@echo "  build            Build all JS/TS apps and packages"
	@echo "  build-mobile     Build Flutter app bundle"
	@echo "  gen              Run Flutter/Dart code generation (Riverpod, Freezed)"
	@echo "  ai-sync          Regenerate Copilot/Cursor rules from .ai/rules"
	@echo ""
	@echo "Testing:"
	@echo "  test             Run JS/TS tests via Turborepo"
	@echo "  test-services    Run pytest across all Python services"
	@echo "  test-mobile      Run Flutter tests"
	@echo "  test-all         Run all tests across all stacks"
	@echo ""
	@echo "Quality:"
	@echo "  lint             Lint all stacks (ESLint, flutter analyze, ruff + mypy)"
	@echo "  format           Auto-format all code (Prettier, dart format, ruff format)"
	@echo ""
	@echo "Docker:"
	@echo "  docker-up        Start Docker services in background"
	@echo "  docker-down      Stop Docker services"
	@echo "  docker-rebuild   Rebuild and restart all Docker services"
	@echo ""
	@echo "  clean            Clean all build artifacts"
