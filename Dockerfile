FROM python:3.12-slim AS builder

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/

WORKDIR /app

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-dev

FROM gcr.io/distroless/python3-debian12:nonroot

USER nonroot
WORKDIR /app

COPY --from=builder --chown=nonroot:nonroot /app/.venv /app/.venv
COPY --chown=nonroot:nonroot . .

ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8501

ENTRYPOINT ["streamlit", "run", "src/QR_app.py"]
CMD ["--server.port=8501", "--server.address=0.0.0.0", "--server.enableCORS=false"]
