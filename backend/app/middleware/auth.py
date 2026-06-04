from fastapi import Depends, Header, HTTPException

from app.routes.auth import decode_jwt


async def get_current_user(authorization: str | None = Header(default=None)):
    if not authorization or not authorization.lower().startswith("bearer "):
        raise HTTPException(status_code=401, detail="Missing bearer token")
    token = authorization.split(" ", 1)[1]
    username = decode_jwt(token)
    if not username:
        raise HTTPException(status_code=401, detail="Invalid token")
    return username
