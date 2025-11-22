import os
import asyncpg
import redis
from fastapi import FastAPI

app = FastAPI()

@app.get("/healthz")
async def healthz():
    return {"status": "ok"}

@app.get("/db")
async def db():
    dsn = os.getenv("POSTGRES_DSN")
    assert dsn, "POSTGRES_DSN is not set"
    conn = await asyncpg.connect(dsn)
    row = await conn.fetchval("select 1")
    await conn.close()
    return {"db": row}

@app.get("/cache")
async def cache():
    host = os.getenv("REDIS_HOST", "redis")
    r = redis.Redis(host=host, port=6379)
    r.set("pong", "ok", ex=5)
    return {"cache": r.get("pong").decode()}

