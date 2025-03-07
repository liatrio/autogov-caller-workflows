FROM ghcr.io/liatrio/python:3.13.2-alpine3.21

ENV VERSION="0.1.0"

LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.description="Dedicated reusable automated governance workflows for internal Liatrio use."
LABEL org.opencontainers.image.authors="AutoGov"

WORKDIR /app

COPY requirements.txt .

RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
    pip install --no-cache-dir -r requirements.txt && \
    chown -R appuser:appgroup /app

COPY app.py .

USER appuser

CMD [ "python3", "-m", "flask", "run", "--host=0.0.0.0", "--no-debug" ]
