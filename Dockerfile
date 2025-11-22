# Multi-stage, non-root, healthcheck
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.11-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /app
RUN useradd -m appuser && chown -R appuser /app
USER appuser
COPY --from=builder /root/.local /home/appuser/.local
ENV PATH=/home/appuser/.local/bin:$PATH
COPY app/ app/
EXPOSE 8000
HEALTHCHECK CMD python -c 'import socket; s=socket.socket(); s.connect(("localhost",8000))' || exit 1
CMD ["uvicorn","app.main:app","--host","0.0.0.0","--port","8000"]

