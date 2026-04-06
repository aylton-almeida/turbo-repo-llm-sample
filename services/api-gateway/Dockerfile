FROM python:3.12-slim AS base
WORKDIR /app
COPY --from=ghcr.io/astral-sh/uv:0.5 /uv /uvx /bin/

FROM base AS deps
COPY pyproject.toml uv.lock* ./
RUN uv sync --frozen --no-install-project

FROM deps AS final
COPY . .
RUN uv sync --frozen

EXPOSE ${PORT:-8000}
CMD ["sh", "-c", "uv run uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
