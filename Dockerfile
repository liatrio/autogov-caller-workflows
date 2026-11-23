# public stock python so external consumers can build without liatrio registry auth
FROM python:3.15-slim@sha256:65a65fc7b30b06cb6df4930fd4650697cb23f4c2698ab81fc87e4b031bc36928

# apply latest os security patches and upgrade pip (mirrors the prior base image)
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir --upgrade pip

ENV VERSION="1.0.13"

LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.description="Caller workflows demonstrating automated governance attestations."
LABEL org.opencontainers.image.authors="AutoGov"

# non-root user previously provided by the base image
RUN useradd -m -u 1000 -s /bin/bash appuser
WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt && \
    chown -R appuser:appuser /app

COPY app.py .

USER appuser

CMD [ "python3", "-m", "flask", "run", "--host=0.0.0.0", "--no-debug" ]
