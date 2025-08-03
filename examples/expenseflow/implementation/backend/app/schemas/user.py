from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

class UserBase(BaseModel):
    email: EmailStr
    username: str
    full_name: str
    department: Optional[str] = None
    position: Optional[str] = None
    phone: Optional[str] = None

class UserCreate(UserBase):
    password: str
    manager_id: Optional[int] = None

class UserUpdate(BaseModel):
    full_name: Optional[str] = None
    department: Optional[str] = None
    position: Optional[str] = None
    phone: Optional[str] = None
    is_active: Optional[bool] = None
    manager_id: Optional[int] = None

class UserResponse(UserBase):
    id: int
    is_active: bool
    is_admin: bool
    manager_id: Optional[int]
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

class TokenData(BaseModel):
    email: Optional[str] = None