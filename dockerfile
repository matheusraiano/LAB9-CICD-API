
# ==========================================
# STAGE 1: BUILD DEPENDENCIES
# ==========================================
FROM python:3.11-slim AS builder

WORKDIR /app

RUN pip install --upgrade pip

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# ==========================================
# STAGE 2: RUNTIME
# ==========================================
FROM python:3.11-slim

WORKDIR /app

RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup appuser

# Copy installed dependencies
COPY --from=builder /install /usr/local

# Copy application
COPY app/ ./app/

# Set permissions
RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8080

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
