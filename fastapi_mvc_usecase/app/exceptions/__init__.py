"""Application implementation - exceptions."""
from fastapi_mvc_usecase.app.exceptions.http import (
    HTTPException,
    http_exception_handler,
)


__all__ = ("HTTPException", "http_exception_handler")
