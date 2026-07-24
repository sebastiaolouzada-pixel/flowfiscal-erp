from fastapi import APIRouter

router = APIRouter()

# Import routers from submodules
from app.api.v1.endpoints import (
    health,
    users,
    invoices,
)

# Include endpoint routers
router.include_router(health.router, tags=["Health"])
router.include_router(users.router, prefix="/users", tags=["Users"])
router.include_router(invoices.router, prefix="/invoices", tags=["Invoices"])

api_router = router
