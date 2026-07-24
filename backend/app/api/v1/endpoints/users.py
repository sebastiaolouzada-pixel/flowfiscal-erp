from fastapi import APIRouter, HTTPException
from typing import List
from pydantic import BaseModel, EmailStr

router = APIRouter()


class UserCreate(BaseModel):
    """User creation schema"""
    email: EmailStr
    full_name: str
    password: str


class UserResponse(BaseModel):
    """User response schema"""
    id: int
    email: str
    full_name: str

    class Config:
        from_attributes = True


class UserUpdate(BaseModel):
    """User update schema"""
    email: EmailStr | None = None
    full_name: str | None = None


# Mock data for demonstration
users_db = [
    {"id": 1, "email": "admin@example.com", "full_name": "Admin User", "password": "hashed_password"},
]


@router.get("", response_model=List[UserResponse])
async def list_users():
    """List all users"""
    return [{"id": u["id"], "email": u["email"], "full_name": u["full_name"]} for u in users_db]


@router.get("/{user_id}", response_model=UserResponse)
async def get_user(user_id: int):
    """Get a specific user by ID"""
    user = next((u for u in users_db if u["id"] == user_id), None)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return {"id": user["id"], "email": user["email"], "full_name": user["full_name"]}


@router.post("", response_model=UserResponse)
async def create_user(user: UserCreate):
    """Create a new user"""
    # Check if user already exists
    if any(u["email"] == user.email for u in users_db):
        raise HTTPException(status_code=400, detail="User already exists")
    
    new_user = {
        "id": len(users_db) + 1,
        "email": user.email,
        "full_name": user.full_name,
        "password": "hashed_password",  # In production, hash the password
    }
    users_db.append(new_user)
    return {"id": new_user["id"], "email": new_user["email"], "full_name": new_user["full_name"]}


@router.put("/{user_id}", response_model=UserResponse)
async def update_user(user_id: int, user: UserUpdate):
    """Update a user"""
    existing_user = next((u for u in users_db if u["id"] == user_id), None)
    if not existing_user:
        raise HTTPException(status_code=404, detail="User not found")
    
    if user.email:
        existing_user["email"] = user.email
    if user.full_name:
        existing_user["full_name"] = user.full_name
    
    return {"id": existing_user["id"], "email": existing_user["email"], "full_name": existing_user["full_name"]}


@router.delete("/{user_id}")
async def delete_user(user_id: int):
    """Delete a user"""
    user = next((u for u in users_db if u["id"] == user_id), None)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    users_db.remove(user)
    return {"message": "User deleted successfully"}
