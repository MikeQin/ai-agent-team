from fastapi import APIRouter
from .auth import router as auth_router
from .expenses import router as expenses_router

api_router = APIRouter()

api_router.include_router(auth_router, prefix="/auth", tags=["authentication"])
api_router.include_router(expenses_router, prefix="", tags=["expenses"])