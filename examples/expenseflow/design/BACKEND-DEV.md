# ExpenseFlow Backend Development Plan

**Backend Developer:** Luke  
**Date:** July 31, 2025  
**Version:** 1.0

---

## Overview

This document outlines the comprehensive FastAPI backend development implementation plan for ExpenseFlow, incorporating requirements from the PRD, system architecture, security specifications, and integration with mobile and web applications.

### Development Objectives
- **Performance**: <200ms API response times, handle 10,000+ concurrent users
- **Security**: Multi-tenant isolation, end-to-end encryption, complete audit trails
- **Scalability**: Microservices architecture with horizontal scaling
- **Database Strategy**: SQLite (development/POC) → PostgreSQL (production)
- **Integration**: Seamless mobile/web client support, external system APIs

---

## Project Architecture

### FastAPI Project Structure
```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py                    # FastAPI application entry
│   ├── core/
│   │   ├── __init__.py
│   │   ├── config.py              # Configuration management
│   │   ├── security.py            # Security utilities
│   │   ├── database.py            # Database connection
│   │   └── exceptions.py          # Custom exceptions
│   ├── api/
│   │   ├── __init__.py
│   │   ├── deps.py                # Dependencies
│   │   └── v1/
│   │       ├── __init__.py
│   │       ├── router.py          # Main API router
│   │       ├── auth.py            # Authentication endpoints
│   │       ├── users.py           # User management
│   │       ├── expenses.py        # Expense operations
│   │       ├── categories.py      # Expense categories
│   │       ├── approvals.py       # Approval workflows
│   │       ├── analytics.py       # Analytics & reporting
│   │       └── files.py           # File upload/download
│   ├── models/
│   │   ├── __init__.py
│   │   ├── base.py                # Base model classes
│   │   ├── user.py                # User models
│   │   ├── expense.py             # Expense models
│   │   └── audit.py               # Audit trail models
│   ├── schemas/
│   │   ├── __init__.py
│   │   ├── user.py                # User Pydantic schemas
│   │   ├── expense.py             # Expense schemas
│   │   └── common.py              # Common schemas
│   ├── services/
│   │   ├── __init__.py
│   │   ├── auth_service.py        # Authentication logic
│   │   ├── expense_service.py     # Business logic
│   │   ├── notification_service.py # Notifications
│   │   ├── ocr_service.py         # OCR processing
│   │   └── integration_service.py # External integrations
│   ├── utils/
│   │   ├── __init__.py
│   │   ├── encryption.py          # Encryption utilities
│   │   ├── validators.py          # Data validation
│   │   └── helpers.py             # Helper functions
│   └── workers/
│       ├── __init__.py
│       ├── celery_app.py          # Celery configuration
│       └── tasks.py               # Background tasks
├── tests/
│   ├── __init__.py
│   ├── conftest.py                # Test configuration
│   ├── test_auth.py
│   ├── test_expenses.py
│   └── test_integrations.py
├── migrations/                    # Database migrations
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
├── requirements.txt
└── pyproject.toml                # Project configuration
```

### Technology Stack
```python
# Core Framework
fastapi = "^0.104.1"
uvicorn = "^0.24.0"
pydantic = "^2.5.0"

# Database
sqlalchemy = "^2.0.23"
alembic = "^1.12.1"
psycopg2-binary = "^2.9.9"  # PostgreSQL
aiosqlite = "^0.19.0"       # SQLite (development)

# Security
python-jose = "^3.3.0"
passlib = "^1.7.4"
bcrypt = "^4.1.2"
cryptography = "^41.0.7"

# Background Tasks
celery = "^5.3.4"
redis = "^5.0.1"

# File Processing
pillow = "^10.1.0"
python-multipart = "^0.0.6"
pytesseract = "^0.3.10"

# External Services
boto3 = "^1.34.0"           # AWS S3
requests = "^2.31.0"
httpx = "^0.25.2"

# Monitoring & Logging
structlog = "^23.2.0"
prometheus-client = "^0.19.0"
sentry-sdk = "^1.38.0"

# Testing
pytest = "^7.4.3"
pytest-asyncio = "^0.21.1"
httpx = "^0.25.2"
```

---

## Core Implementation

### 1. Application Setup & Configuration

#### FastAPI Application
```python
# app/main.py
from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from fastapi.responses import JSONResponse
import structlog
import time

from app.core.config import settings
from app.core.exceptions import AppException
from app.api.v1.router import api_router

# Configure structured logging
structlog.configure(
    processors=[
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.add_log_level,
        structlog.processors.JSONRenderer()
    ],
    wrapper_class=structlog.stdlib.BoundLogger,
    logger_factory=structlog.stdlib.LoggerFactory(),
    cache_logger_on_first_use=True,
)

logger = structlog.get_logger()

app = FastAPI(
    title="ExpenseFlow API",
    description="Team expense management system",
    version="1.0.0",
    docs_url="/docs" if settings.ENVIRONMENT != "production" else None,
    redoc_url="/redoc" if settings.ENVIRONMENT != "production" else None,
)

# Security middleware
app.add_middleware(
    TrustedHostMiddleware, 
    allowed_hosts=settings.ALLOWED_HOSTS
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Request logging middleware
@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()
    
    response = await call_next(request)
    
    process_time = time.time() - start_time
    logger.info(
        "Request processed",
        method=request.method,
        url=str(request.url),
        status_code=response.status_code,
        process_time=round(process_time, 4)
    )
    
    return response

# Global exception handler
@app.exception_handler(AppException)
async def app_exception_handler(request: Request, exc: AppException):
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": exc.error_code,
            "message": exc.message,
            "details": exc.details
        }
    )

# Health check endpoint
@app.get("/health")
async def health_check():
    return {"status": "healthy", "timestamp": time.time()}

# Include API router
app.include_router(api_router, prefix="/api/v1")

@app.on_event("startup")
async def startup_event():
    logger.info("ExpenseFlow API starting up", version="1.0.0")

@app.on_event("shutdown")
async def shutdown_event():
    logger.info("ExpenseFlow API shutting down")
```

#### Configuration Management
```python
# app/core/config.py
from pydantic import BaseSettings, validator
from typing import List, Optional
import secrets

class Settings(BaseSettings):
    # Environment
    ENVIRONMENT: str = "development"
    DEBUG: bool = False
    
    # API Configuration
    API_V1_STR: str = "/api/v1"
    SECRET_KEY: str = secrets.token_urlsafe(32)
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7
    
    # Database
    DATABASE_URL: str = "sqlite+aiosqlite:///./expenseflow.db"
    TEST_DATABASE_URL: str = "sqlite+aiosqlite:///./test_expenseflow.db"
    
    # Security
    BCRYPT_ROUNDS: int = 12
    ALLOWED_HOSTS: List[str] = ["localhost", "127.0.0.1"]
    CORS_ORIGINS: List[str] = ["http://localhost:3000"]
    
    # File Storage
    UPLOAD_FOLDER: str = "./uploads"
    MAX_FILE_SIZE: int = 10 * 1024 * 1024  # 10MB
    ALLOWED_EXTENSIONS: List[str] = [".jpg", ".jpeg", ".png", ".pdf"]
    
    # External Services
    AWS_ACCESS_KEY_ID: Optional[str] = None
    AWS_SECRET_ACCESS_KEY: Optional[str] = None
    AWS_S3_BUCKET: Optional[str] = None
    AWS_REGION: str = "us-east-1"
    
    # OCR Service
    TESSERACT_CMD: str = "/usr/local/bin/tesseract"
    OCR_TIMEOUT: int = 30
    
    # Background Tasks
    CELERY_BROKER_URL: str = "redis://localhost:6379/0"
    CELERY_RESULT_BACKEND: str = "redis://localhost:6379/0"
    
    # Monitoring
    SENTRY_DSN: Optional[str] = None
    LOG_LEVEL: str = "INFO"
    
    @validator("CORS_ORIGINS", pre=True)
    def assemble_cors_origins(cls, v):
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)
    
    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
```

### 2. Database Models & Schemas

#### SQLAlchemy Models
```python
# app/models/base.py
from sqlalchemy import Column, String, DateTime, Boolean
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.dialects.postgresql import UUID
import uuid
from datetime import datetime

Base = declarative_base()

class BaseModel(Base):
    __abstract__ = True
    
    id = Column(
        UUID(as_uuid=True), 
        primary_key=True, 
        default=uuid.uuid4,
        index=True
    )
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(
        DateTime, 
        default=datetime.utcnow, 
        onupdate=datetime.utcnow,
        nullable=False
    )
    is_active = Column(Boolean, default=True, nullable=False)
```

```python
# app/models/user.py
from sqlalchemy import Column, String, Enum, ForeignKey
from sqlalchemy.orm import relationship
from .base import BaseModel
import enum

class UserRole(enum.Enum):
    EMPLOYEE = "employee"
    MANAGER = "manager"
    FINANCE = "finance"
    ADMIN = "admin"

class User(BaseModel):
    __tablename__ = "users"
    
    email = Column(String(255), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    role = Column(Enum(UserRole), default=UserRole.EMPLOYEE, nullable=False)
    department_id = Column(UUID(as_uuid=True), ForeignKey("departments.id"), nullable=True)
    manager_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    
    # Relationships
    expenses = relationship("Expense", back_populates="user")
    approvals = relationship("Approval", foreign_keys="Approval.approver_id")
    manager = relationship("User", remote_side="User.id", back_populates="subordinates")
    subordinates = relationship("User", back_populates="manager")
    department = relationship("Department", back_populates="users")
    
    @property
    def full_name(self):
        return f"{self.first_name} {self.last_name}"
```

```python
# app/models/expense.py
from sqlalchemy import Column, String, Numeric, DateTime, Text, ForeignKey, Enum
from sqlalchemy.orm import relationship
from .base import BaseModel
import enum

class ExpenseStatus(enum.Enum):
    DRAFT = "draft"
    SUBMITTED = "submitted"
    APPROVED = "approved"
    REJECTED = "rejected"
    PAID = "paid"

class Expense(BaseModel):
    __tablename__ = "expenses"
    
    title = Column(String(200), nullable=False)
    description = Column(Text, nullable=True)
    amount = Column(Numeric(10, 2), nullable=False)
    currency = Column(String(3), default="USD", nullable=False)
    date_incurred = Column(DateTime, nullable=False)
    status = Column(Enum(ExpenseStatus), default=ExpenseStatus.DRAFT, nullable=False)
    submission_date = Column(DateTime, nullable=True)
    
    # Foreign Keys
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    category_id = Column(UUID(as_uuid=True), ForeignKey("categories.id"), nullable=False)
    
    # Relationships
    user = relationship("User", back_populates="expenses")
    category = relationship("Category", back_populates="expenses")
    receipts = relationship("Receipt", back_populates="expense", cascade="all, delete-orphan")
    approvals = relationship("Approval", back_populates="expense", cascade="all, delete-orphan")
    audit_logs = relationship("AuditLog", back_populates="expense")

class Receipt(BaseModel):
    __tablename__ = "receipts"
    
    filename = Column(String(255), nullable=False)
    file_url = Column(String(500), nullable=False)
    file_size = Column(Integer, nullable=False)
    mime_type = Column(String(100), nullable=False)
    ocr_data = Column(JSON, nullable=True)
    
    # Foreign Key
    expense_id = Column(UUID(as_uuid=True), ForeignKey("expenses.id"), nullable=False)
    
    # Relationships
    expense = relationship("Expense", back_populates="receipts")
```

#### Pydantic Schemas
```python
# app/schemas/expense.py
from pydantic import BaseModel, validator
from typing import Optional, List
from datetime import datetime
from decimal import Decimal
from app.models.expense import ExpenseStatus

class ExpenseBase(BaseModel):
    title: str
    description: Optional[str] = None
    amount: Decimal
    currency: str = "USD"
    date_incurred: datetime
    category_id: str

class ExpenseCreate(ExpenseBase):
    @validator('amount')
    def validate_amount(cls, v):
        if v <= 0:
            raise ValueError('Amount must be positive')
        if v > 10000:  # Business rule example
            raise ValueError('Amount exceeds maximum limit')
        return v
    
    @validator('title')
    def validate_title(cls, v):
        if not v or len(v.strip()) < 3:
            raise ValueError('Title must be at least 3 characters')
        return v.strip()

class ExpenseUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    amount: Optional[Decimal] = None
    date_incurred: Optional[datetime] = None
    category_id: Optional[str] = None

class ExpenseInDB(ExpenseBase):
    id: str
    user_id: str
    status: ExpenseStatus
    submission_date: Optional[datetime]
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True

class ExpenseResponse(ExpenseInDB):
    user: "UserResponse"
    category: "CategoryResponse"
    receipts: List["ReceiptResponse"] = []
    approvals: List["ApprovalResponse"] = []

class ReceiptCreate(BaseModel):
    filename: str
    file_size: int
    mime_type: str

class ReceiptResponse(BaseModel):
    id: str
    filename: str
    file_url: str
    file_size: int
    mime_type: str
    ocr_data: Optional[dict] = None
    created_at: datetime
    
    class Config:
        from_attributes = True
```

### 3. Authentication & Security

#### JWT Authentication Service
```python
# app/services/auth_service.py
from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from sqlalchemy.orm import Session
from app.core.config import settings
from app.models.user import User
from app.core.exceptions import AuthenticationException

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class AuthService:
    @staticmethod
    def verify_password(plain_password: str, hashed_password: str) -> bool:
        return pwd_context.verify(plain_password, hashed_password)
    
    @staticmethod
    def get_password_hash(password: str) -> str:
        return pwd_context.hash(password)
    
    @staticmethod
    def authenticate_user(db: Session, email: str, password: str) -> Optional[User]:
        user = db.query(User).filter(User.email == email, User.is_active == True).first()
        if not user or not AuthService.verify_password(password, user.hashed_password):
            return None
        return user
    
    @staticmethod
    def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
        to_encode = data.copy()
        if expires_delta:
            expire = datetime.utcnow() + expires_delta
        else:
            expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        
        to_encode.update({"exp": expire, "type": "access"})
        encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm="HS256")
        return encoded_jwt
    
    @staticmethod
    def create_refresh_token(data: dict):
        to_encode = data.copy()
        expire = datetime.utcnow() + timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
        to_encode.update({"exp": expire, "type": "refresh"})
        encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm="HS256")
        return encoded_jwt
    
    @staticmethod
    def verify_token(token: str, token_type: str = "access") -> dict:
        try:
            payload = jwt.decode(token, settings.SECRET_KEY, algorithms=["HS256"])
            
            if payload.get("type") != token_type:
                raise AuthenticationException("Invalid token type")
            
            user_id: str = payload.get("sub")
            if user_id is None:
                raise AuthenticationException("Invalid token payload")
            
            return {"user_id": user_id, "payload": payload}
        
        except JWTError:
            raise AuthenticationException("Could not validate credentials")
```

#### Security Dependencies
```python
# app/api/deps.py
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.services.auth_service import AuthService
from app.models.user import User, UserRole

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User:
    try:
        token_data = AuthService.verify_token(credentials.credentials)
        user = db.query(User).filter(
            User.id == token_data["user_id"],
            User.is_active == True
        ).first()
        
        if user is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User not found"
            )
        
        return user
    
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

def require_role(required_role: UserRole):
    def role_checker(current_user: User = Depends(get_current_user)) -> User:
        user_role_hierarchy = {
            UserRole.EMPLOYEE: 1,
            UserRole.MANAGER: 2,
            UserRole.FINANCE: 3,
            UserRole.ADMIN: 4
        }
        
        if user_role_hierarchy[current_user.role] < user_role_hierarchy[required_role]:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions"
            )
        
        return current_user
    
    return role_checker

# Specific role dependencies
def get_current_manager(current_user: User = Depends(require_role(UserRole.MANAGER))) -> User:
    return current_user

def get_current_admin(current_user: User = Depends(require_role(UserRole.ADMIN))) -> User:
    return current_user
```

### 4. API Endpoints

#### Expense Management API
```python
# app/api/v1/expenses.py
from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from sqlalchemy.orm import Session
from typing import List, Optional
from app.core.database import get_db
from app.api.deps import get_current_user, get_current_manager
from app.models.user import User
from app.models.expense import Expense, ExpenseStatus
from app.schemas.expense import ExpenseCreate, ExpenseUpdate, ExpenseResponse
from app.services.expense_service import ExpenseService
from app.services.ocr_service import OCRService

router = APIRouter()

@router.post("/", response_model=ExpenseResponse, status_code=status.HTTP_201_CREATED)
async def create_expense(
    expense_data: ExpenseCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new expense"""
    expense = await ExpenseService.create_expense(
        db=db, 
        expense_data=expense_data, 
        user_id=current_user.id
    )
    return expense

@router.get("/", response_model=List[ExpenseResponse])
async def get_expenses(
    status: Optional[ExpenseStatus] = None,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get user's expenses with optional filtering"""
    expenses = await ExpenseService.get_user_expenses(
        db=db,
        user_id=current_user.id,
        status=status,
        skip=skip,
        limit=limit
    )
    return expenses

@router.get("/{expense_id}", response_model=ExpenseResponse)
async def get_expense(
    expense_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get a specific expense"""
    expense = await ExpenseService.get_expense(
        db=db, 
        expense_id=expense_id, 
        user_id=current_user.id
    )
    
    if not expense:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Expense not found"
        )
    
    return expense

@router.put("/{expense_id}", response_model=ExpenseResponse)
async def update_expense(
    expense_id: str,
    expense_update: ExpenseUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update an expense (only allowed for draft/rejected expenses)"""
    expense = await ExpenseService.update_expense(
        db=db,
        expense_id=expense_id,
        user_id=current_user.id,
        expense_update=expense_update
    )
    
    if not expense:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Expense not found or cannot be updated"
        )
    
    return expense

@router.post("/{expense_id}/submit")
async def submit_expense(
    expense_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Submit an expense for approval"""
    success = await ExpenseService.submit_expense(
        db=db,
        expense_id=expense_id,
        user_id=current_user.id
    )
    
    if not success:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot submit expense"
        )
    
    return {"message": "Expense submitted successfully"}

@router.post("/{expense_id}/receipts")
async def upload_receipt(
    expense_id: str,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Upload a receipt for an expense"""
    
    # Validate file
    if not file.content_type.startswith('image/') and file.content_type != 'application/pdf':
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Only image and PDF files are allowed"
        )
    
    # Process receipt with OCR
    receipt = await ExpenseService.upload_receipt(
        db=db,
        expense_id=expense_id,
        user_id=current_user.id,
        file=file
    )
    
    return {"message": "Receipt uploaded successfully", "receipt_id": receipt.id}

# Manager-only endpoints
@router.get("/pending-approvals", response_model=List[ExpenseResponse])
async def get_pending_approvals(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_manager: User = Depends(get_current_manager)
):
    """Get expenses pending approval for manager's team"""
    expenses = await ExpenseService.get_pending_approvals(
        db=db,
        manager_id=current_manager.id,
        skip=skip,
        limit=limit
    )
    return expenses

@router.post("/{expense_id}/approve")
async def approve_expense(
    expense_id: str,
    comments: Optional[str] = None,
    db: Session = Depends(get_db),
    current_manager: User = Depends(get_current_manager)
):
    """Approve an expense"""
    success = await ExpenseService.approve_expense(
        db=db,
        expense_id=expense_id,
        approver_id=current_manager.id,
        comments=comments
    )
    
    if not success:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot approve expense"
        )
    
    return {"message": "Expense approved successfully"}

@router.post("/{expense_id}/reject")
async def reject_expense(
    expense_id: str,
    reason: str,
    db: Session = Depends(get_db),
    current_manager: User = Depends(get_current_manager)
):
    """Reject an expense"""
    success = await ExpenseService.reject_expense(
        db=db,
        expense_id=expense_id,
        approver_id=current_manager.id,
        reason=reason
    )
    
    if not success:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot reject expense"
        )
    
    return {"message": "Expense rejected"}
```

### 5. Business Logic Services

#### Expense Service
```python
# app/services/expense_service.py
from sqlalchemy.orm import Session
from sqlalchemy import and_, or_
from typing import List, Optional
from fastapi import UploadFile, HTTPException
import uuid
from datetime import datetime

from app.models.expense import Expense, Receipt, ExpenseStatus, Approval
from app.models.user import User
from app.schemas.expense import ExpenseCreate, ExpenseUpdate
from app.services.ocr_service import OCRService
from app.services.notification_service import NotificationService
from app.utils.file_storage import FileStorage

class ExpenseService:
    @staticmethod
    async def create_expense(
        db: Session, 
        expense_data: ExpenseCreate, 
        user_id: str
    ) -> Expense:
        """Create a new expense"""
        
        # Validate user permissions
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        
        # Create expense
        expense = Expense(
            **expense_data.dict(),
            user_id=user_id,
            id=str(uuid.uuid4())
        )
        
        db.add(expense)
        db.commit()
        db.refresh(expense)
        
        # Log audit trail
        await ExpenseService._create_audit_log(
            db, expense.id, user_id, "CREATED", "Expense created"
        )
        
        return expense
    
    @staticmethod
    async def get_user_expenses(
        db: Session,
        user_id: str,
        status: Optional[ExpenseStatus] = None,
        skip: int = 0,
        limit: int = 100
    ) -> List[Expense]:
        """Get expenses for a specific user"""
        
        query = db.query(Expense).filter(Expense.user_id == user_id)
        
        if status:
            query = query.filter(Expense.status == status)
        
        return query.offset(skip).limit(limit).all()
    
    @staticmethod
    async def submit_expense(
        db: Session,
        expense_id: str,
        user_id: str
    ) -> bool:
        """Submit an expense for approval"""
        
        expense = db.query(Expense).filter(
            and_(
                Expense.id == expense_id,
                Expense.user_id == user_id,
                Expense.status == ExpenseStatus.DRAFT
            )
        ).first()
        
        if not expense:
            return False
        
        # Validate expense has required data
        if not expense.receipts:
            raise HTTPException(
                status_code=400,
                detail="Cannot submit expense without receipts"
            )
        
        # Update status
        expense.status = ExpenseStatus.SUBMITTED
        expense.submission_date = datetime.utcnow()
        
        db.commit()
        
        # Create audit log
        await ExpenseService._create_audit_log(
            db, expense_id, user_id, "SUBMITTED", "Expense submitted for approval"
        )
        
        # Notify manager
        await NotificationService.notify_manager_new_expense(
            db, expense.user.manager_id, expense
        )
        
        return True
    
    @staticmethod
    async def approve_expense(
        db: Session,
        expense_id: str,
        approver_id: str,
        comments: Optional[str] = None
    ) -> bool:
        """Approve an expense"""
        
        # Verify approver has permission
        expense = db.query(Expense).filter(Expense.id == expense_id).first()
        if not expense or expense.status != ExpenseStatus.SUBMITTED:
            return False
        
        # Check if approver is the user's manager
        if expense.user.manager_id != approver_id:
            raise HTTPException(
                status_code=403,
                detail="Not authorized to approve this expense"
            )
        
        # Update expense status
        expense.status = ExpenseStatus.APPROVED
        
        # Create approval record
        approval = Approval(
            id=str(uuid.uuid4()),
            expense_id=expense_id,
            approver_id=approver_id,
            status="approved",
            comments=comments,
            approved_at=datetime.utcnow()
        )
        
        db.add(approval)
        db.commit()
        
        # Create audit log
        await ExpenseService._create_audit_log(
            db, expense_id, approver_id, "APPROVED", comments or "Expense approved"
        )
        
        # Notify employee
        await NotificationService.notify_expense_approved(
            db, expense.user_id, expense
        )
        
        return True
    
    @staticmethod
    async def upload_receipt(
        db: Session,
        expense_id: str,
        user_id: str,
        file: UploadFile
    ) -> Receipt:
        """Upload and process a receipt"""
        
        # Verify expense ownership
        expense = db.query(Expense).filter(
            and_(
                Expense.id == expense_id,
                Expense.user_id == user_id
            )
        ).first()
        
        if not expense:
            raise HTTPException(status_code=404, detail="Expense not found")
        
        # Upload file to storage
        file_url = await FileStorage.upload_file(file, f"receipts/{expense_id}")
        
        # Process with OCR
        ocr_data = await OCRService.process_receipt(file)
        
        # Create receipt record
        receipt = Receipt(
            id=str(uuid.uuid4()),
            expense_id=expense_id,
            filename=file.filename,
            file_url=file_url,
            file_size=file.size,
            mime_type=file.content_type,
            ocr_data=ocr_data
        )
        
        db.add(receipt)
        
        # Auto-update expense if OCR extracted data
        if ocr_data and expense.status == ExpenseStatus.DRAFT:
            if ocr_data.get('amount'):
                expense.amount = ocr_data['amount']
            if ocr_data.get('date'):
                expense.date_incurred = ocr_data['date']
            if ocr_data.get('merchant') and not expense.description:
                expense.description = f"Purchase from {ocr_data['merchant']}"
        
        db.commit()
        db.refresh(receipt)
        
        return receipt
    
    @classmethod
    async def _create_audit_log(
        cls,
        db: Session,
        expense_id: str,
        user_id: str,
        action: str,
        details: str
    ):
        """Create an audit log entry"""
        from app.models.audit import AuditLog
        
        audit_log = AuditLog(
            id=str(uuid.uuid4()),
            expense_id=expense_id,
            user_id=user_id,
            action=action,
            details=details,
            timestamp=datetime.utcnow()
        )
        
        db.add(audit_log)
        db.commit()
```

### 6. OCR Processing Service

#### OCR Service Implementation
```python
# app/services/ocr_service.py
import pytesseract
from PIL import Image
import io
import re
from datetime import datetime
from typing import Dict, Optional
from fastapi import UploadFile
import logging

logger = logging.getLogger(__name__)

class OCRService:
    @staticmethod
    async def process_receipt(file: UploadFile) -> Dict:
        """Process receipt image with OCR and extract structured data"""
        
        try:
            # Read image file
            image_data = await file.read()
            image = Image.open(io.BytesIO(image_data))
            
            # Preprocess image for better OCR
            processed_image = OCRService._preprocess_image(image)
            
            # Extract text using Tesseract
            extracted_text = pytesseract.image_to_string(
                processed_image,
                config='--oem 3 --psm 6'
            )
            
            # Parse structured data from text
            parsed_data = OCRService._parse_receipt_data(extracted_text)
            
            return {
                'raw_text': extracted_text,
                'parsed_data': parsed_data,
                'confidence': parsed_data.get('confidence', 0.5),
                'processing_timestamp': datetime.utcnow().isoformat()
            }
            
        except Exception as e:
            logger.error(f"OCR processing failed: {str(e)}")
            return {
                'error': str(e),
                'confidence': 0.0,
                'processing_timestamp': datetime.utcnow().isoformat()
            }
    
    @staticmethod
    def _preprocess_image(image: Image.Image) -> Image.Image:
        """Preprocess image for better OCR results"""
        
        # Convert to grayscale
        if image.mode != 'L':
            image = image.convert('L')
        
        # Enhance contrast and sharpness
        from PIL import ImageEnhance
        
        # Increase contrast
        enhancer = ImageEnhance.Contrast(image)
        image = enhancer.enhance(1.5)
        
        # Increase sharpness
        enhancer = ImageEnhance.Sharpness(image)
        image = enhancer.enhance(2.0)
        
        return image
    
    @staticmethod
    def _parse_receipt_data(text: str) -> Dict:
        """Parse structured data from OCR text"""
        
        parsed_data = {}
        confidence_scores = []
        
        # Extract amount
        amount_patterns = [
            r'\$(\d+\.?\d*)',
            r'total[:\s]*\$?(\d+\.?\d*)',
            r'amount[:\s]*\$?(\d+\.?\d*)',
        ]
        
        for pattern in amount_patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                try:
                    parsed_data['amount'] = float(match.group(1))
                    confidence_scores.append(0.8)
                    break
                except ValueError:
                    continue
        
        # Extract date
        date_patterns = [
            r'(\d{1,2}[/-]\d{1,2}[/-]\d{4})',
            r'(\d{4}[/-]\d{1,2}[/-]\d{1,2})',
            r'(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\s+\d{1,2},?\s+\d{4}',
        ]
        
        for pattern in date_patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                try:
                    date_str = match.group(1)
                    # Try to parse different date formats
                    for fmt in ['%m/%d/%Y', '%Y/%m/%d', '%m-%d-%Y', '%Y-%m-%d']:
                        try:
                            parsed_data['date'] = datetime.strptime(date_str, fmt).date()
                            confidence_scores.append(0.7)
                            break
                        except ValueError:
                            continue
                    if 'date' in parsed_data:
                        break
                except Exception:
                    continue
        
        # Extract merchant/vendor
        # Look for merchant names (usually at the top of receipt)
        lines = text.split('\n')
        for i, line in enumerate(lines[:5]):  # Check first 5 lines
            line = line.strip()
            if len(line) > 3 and not re.match(r'^\d+[/-]\d+[/-]\d+', line):
                # Skip lines that look like dates, phone numbers, or addresses
                if not re.search(r'\d{3}-\d{3}-\d{4}|\d{3}\s+\w+\s+(st|ave|rd|blvd)', line, re.IGNORECASE):
                    parsed_data['merchant'] = line
                    confidence_scores.append(0.6)
                    break
        
        # Calculate overall confidence
        if confidence_scores:
            parsed_data['confidence'] = sum(confidence_scores) / len(confidence_scores)
        else:
            parsed_data['confidence'] = 0.3
        
        return parsed_data
```

### 7. Background Tasks with Celery

#### Celery Configuration
```python
# app/workers/celery_app.py
from celery import Celery
from app.core.config import settings

celery_app = Celery(
    "expenseflow",
    broker=settings.CELERY_BROKER_URL,
    backend=settings.CELERY_RESULT_BACKEND,
    include=["app.workers.tasks"]
)

celery_app.conf.update(
    task_serializer="json",
    accept_content=["json"],
    result_serializer="json",
    timezone="UTC",
    enable_utc=True,
    task_routes={
        "app.workers.tasks.process_receipt_ocr": {"queue": "ocr"},
        "app.workers.tasks.send_notification_email": {"queue": "notifications"},
        "app.workers.tasks.generate_expense_report": {"queue": "reports"},
    }
)
```

#### Background Tasks
```python
# app/workers/tasks.py
from celery import current_task
from app.workers.celery_app import celery_app
from app.core.database import SessionLocal
from app.services.ocr_service import OCRService
from app.services.notification_service import NotificationService
from app.models.expense import Receipt
import logging

logger = logging.getLogger(__name__)

@celery_app.task(bind=True)
def process_receipt_ocr(self, receipt_id: str):
    """Background task to process receipt OCR"""
    
    try:
        db = SessionLocal()
        
        # Update task status
        current_task.update_state(
            state='PROGRESS',
            meta={'status': 'Processing receipt...'}
        )
        
        receipt = db.query(Receipt).filter(Receipt.id == receipt_id).first()
        if not receipt:
            raise ValueError(f"Receipt {receipt_id} not found")
        
        # Process OCR (this would download the file and process it)
        # For now, we'll simulate the processing
        ocr_result = {
            'amount': 25.99,
            'date': '2025-07-31',
            'merchant': 'Sample Restaurant',
            'confidence': 0.85
        }
        
        # Update receipt with OCR data
        receipt.ocr_data = ocr_result
        db.commit()
        
        current_task.update_state(
            state='SUCCESS',
            meta={'status': 'OCR processing completed', 'result': ocr_result}
        )
        
        return ocr_result
        
    except Exception as exc:
        logger.error(f"OCR processing failed for receipt {receipt_id}: {str(exc)}")
        current_task.update_state(
            state='FAILURE',
            meta={'status': 'OCR processing failed', 'error': str(exc)}
        )
        raise
    
    finally:
        db.close()

@celery_app.task
def send_notification_email(user_id: str, expense_id: str, notification_type: str):
    """Send notification email to user"""
    
    try:
        db = SessionLocal()
        
        # Get user and expense details
        # Send email notification
        # Log notification sent
        
        logger.info(f"Notification sent to user {user_id} for expense {expense_id}")
        
    except Exception as exc:
        logger.error(f"Failed to send notification: {str(exc)}")
        raise
    
    finally:
        db.close()

@celery_app.task
def generate_expense_report(user_id: str, date_range: dict, report_type: str):
    """Generate expense report in background"""
    
    try:
        db = SessionLocal()
        
        # Generate report
        # Upload to S3 or file storage
        # Notify user when ready
        
        logger.info(f"Report generated for user {user_id}")
        
    except Exception as exc:
        logger.error(f"Failed to generate report: {str(exc)}")
        raise
    
    finally:
        db.close()
```

---

## Database Migration Strategy

### SQLite to PostgreSQL Migration
```python
# scripts/migrate_to_postgresql.py
import asyncio
import sqlite3
import asyncpg
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.core.config import settings
from app.models.base import Base

async def migrate_database():
    """Migrate data from SQLite to PostgreSQL"""
    
    # Create PostgreSQL tables
    pg_engine = create_engine(settings.DATABASE_URL)
    Base.metadata.create_all(bind=pg_engine)
    
    # Connect to both databases
    sqlite_conn = sqlite3.connect("expenseflow.db")
    sqlite_conn.row_factory = sqlite3.Row
    
    pg_conn = await asyncpg.connect(settings.DATABASE_URL)
    
    try:
        # Migrate users
        users = sqlite_conn.execute("SELECT * FROM users").fetchall()
        for user in users:
            await pg_conn.execute("""
                INSERT INTO users (id, email, hashed_password, first_name, last_name, 
                                 role, created_at, updated_at)
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
            """, *user)
        
        # Migrate expenses
        expenses = sqlite_conn.execute("SELECT * FROM expenses").fetchall()
        for expense in expenses:
            await pg_conn.execute("""
                INSERT INTO expenses (id, title, description, amount, currency,
                                    date_incurred, status, user_id, category_id,
                                    created_at, updated_at)
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
            """, *expense)
        
        print("Migration completed successfully")
        
    finally:
        sqlite_conn.close()
        await pg_conn.close()

if __name__ == "__main__":
    asyncio.run(migrate_database())
```

---

## Performance Optimization

### Database Query Optimization
```python
# app/utils/query_optimizer.py
from sqlalchemy.orm import Session, selectinload, joinedload
from app.models.expense import Expense

class QueryOptimizer:
    @staticmethod
    def get_expenses_optimized(db: Session, user_id: str, limit: int = 100):
        """Optimized query for expenses with relationships"""
        
        return db.query(Expense).options(
            joinedload(Expense.user),
            joinedload(Expense.category),
            selectinload(Expense.receipts),
            selectinload(Expense.approvals).joinedload("approver")
        ).filter(
            Expense.user_id == user_id
        ).limit(limit).all()
    
    @staticmethod
    def get_pending_approvals_optimized(db: Session, manager_id: str):
        """Optimized query for pending approvals"""
        
        return db.query(Expense).options(
            joinedload(Expense.user),
            joinedload(Expense.category),
            selectinload(Expense.receipts)
        ).join(Expense.user).filter(
            User.manager_id == manager_id,
            Expense.status == ExpenseStatus.SUBMITTED
        ).all()
```

### Caching Strategy
```python
# app/utils/cache.py
import redis
import json
from datetime import timedelta
from app.core.config import settings

redis_client = redis.Redis.from_url(settings.CELERY_BROKER_URL)

class CacheService:
    @staticmethod
    def set_cache(key: str, value: dict, expiry: timedelta = timedelta(minutes=15)):
        """Set cache value with expiry"""
        redis_client.setex(
            key,
            int(expiry.total_seconds()),
            json.dumps(value, default=str)
        )
    
    @staticmethod
    def get_cache(key: str):
        """Get cached value"""
        cached = redis_client.get(key)
        if cached:
            return json.loads(cached)
        return None
    
    @staticmethod
    def invalidate_cache(pattern: str):
        """Invalidate cache by pattern"""
        keys = redis_client.keys(pattern)
        if keys:
            redis_client.delete(*keys)
    
    @staticmethod
    def cache_user_expenses(user_id: str, expenses: list):
        """Cache user expenses"""
        CacheService.set_cache(
            f"user_expenses:{user_id}",
            expenses,
            timedelta(minutes=5)
        )
    
    @staticmethod
    def get_cached_user_expenses(user_id: str):
        """Get cached user expenses"""
        return CacheService.get_cache(f"user_expenses:{user_id}")
```

---

## Testing Strategy

### Unit Tests
```python
# tests/test_expense_service.py
import pytest
from sqlalchemy.orm import Session
from app.services.expense_service import ExpenseService
from app.schemas.expense import ExpenseCreate
from app.models.user import User, UserRole
from app.models.expense import Expense, ExpenseStatus

@pytest.fixture
def sample_user(db_session: Session):
    user = User(
        id="user-123",
        email="test@example.com",
        hashed_password="hashed",
        first_name="Test",
        last_name="User",
        role=UserRole.EMPLOYEE
    )
    db_session.add(user)
    db_session.commit()
    return user

@pytest.fixture
def sample_expense_data():
    return ExpenseCreate(
        title="Business Lunch",
        description="Client meeting",
        amount=25.99,
        currency="USD",
        date_incurred="2025-07-31T12:00:00",
        category_id="cat-123"
    )

class TestExpenseService:
    
    @pytest.mark.asyncio
    async def test_create_expense(self, db_session: Session, sample_user: User, sample_expense_data: ExpenseCreate):
        # Test expense creation
        expense = await ExpenseService.create_expense(
            db=db_session,
            expense_data=sample_expense_data,
            user_id=sample_user.id
        )
        
        assert expense.title == sample_expense_data.title
        assert expense.amount == sample_expense_data.amount
        assert expense.user_id == sample_user.id
        assert expense.status == ExpenseStatus.DRAFT
    
    @pytest.mark.asyncio
    async def test_submit_expense_without_receipt_fails(self, db_session: Session, sample_user: User):
        # Create expense without receipt
        expense = Expense(
            id="expense-123",
            title="Test Expense",
            amount=10.00,
            user_id=sample_user.id,
            category_id="cat-123",
            status=ExpenseStatus.DRAFT
        )
        db_session.add(expense)
        db_session.commit()
        
        # Attempt to submit should fail
        result = await ExpenseService.submit_expense(
            db=db_session,
            expense_id=expense.id,
            user_id=sample_user.id
        )
        
        assert result is False
    
    @pytest.mark.asyncio
    async def test_approve_expense_by_manager(self, db_session: Session):
        # Create manager and employee
        manager = User(
            id="manager-123",
            email="manager@example.com",
            hashed_password="hashed",
            first_name="Manager",
            last_name="User",
            role=UserRole.MANAGER
        )
        
        employee = User(
            id="employee-123",
            email="employee@example.com",
            hashed_password="hashed",
            first_name="Employee",
            last_name="User",
            role=UserRole.EMPLOYEE,
            manager_id=manager.id
        )
        
        expense = Expense(
            id="expense-123",
            title="Test Expense",
            amount=10.00,
            user_id=employee.id,
            category_id="cat-123",
            status=ExpenseStatus.SUBMITTED
        )
        
        db_session.add_all([manager, employee, expense])
        db_session.commit()
        
        # Manager approves expense
        result = await ExpenseService.approve_expense(
            db=db_session,
            expense_id=expense.id,
            approver_id=manager.id,
            comments="Approved for client meeting"
        )
        
        assert result is True
        
        # Refresh expense from database
        db_session.refresh(expense)
        assert expense.status == ExpenseStatus.APPROVED
```

### Integration Tests
```python
# tests/test_api_integration.py
import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.core.database import get_db
from tests.conftest import override_get_db

client = TestClient(app)

class TestExpenseAPI:
    
    def test_create_expense_authenticated(self, auth_headers):
        expense_data = {
            "title": "Business Lunch",
            "description": "Client meeting",
            "amount": 25.99,
            "currency": "USD",
            "date_incurred": "2025-07-31T12:00:00Z",
            "category_id": "cat-123"
        }
        
        response = client.post(
            "/api/v1/expenses/",
            json=expense_data,
            headers=auth_headers
        )
        
        assert response.status_code == 201
        data = response.json()
        assert data["title"] == expense_data["title"]
        assert data["amount"] == expense_data["amount"]
        assert data["status"] == "draft"
    
    def test_get_expenses_unauthorized(self):
        response = client.get("/api/v1/expenses/")
        assert response.status_code == 401
    
    def test_approve_expense_as_manager(self, manager_auth_headers, submitted_expense_id):
        response = client.post(
            f"/api/v1/expenses/{submitted_expense_id}/approve",
            json={"comments": "Approved"},
            headers=manager_auth_headers
        )
        
        assert response.status_code == 200
        assert response.json()["message"] == "Expense approved successfully"
```

---

## Implementation Timeline

### Phase 1: Core Backend (Weeks 1-4)
- **Week 1**: FastAPI setup, database models, basic CRUD
- **Week 2**: Authentication system, JWT implementation, role-based access
- **Week 3**: Expense management APIs, file upload handling
- **Week 4**: OCR service integration, basic business logic

### Phase 2: Advanced Features (Weeks 5-8)
- **Week 5**: Approval workflows, manager APIs, notification system
- **Week 6**: Background tasks (Celery), email notifications, audit trails
- **Week 7**: Analytics APIs, reporting endpoints, data aggregation
- **Week 8**: External integrations (accounting systems), webhook support

### Phase 3: Optimization & Security (Weeks 9-12)
- **Week 9**: Performance optimization, query optimization, caching
- **Week 10**: Security hardening, input validation, rate limiting
- **Week 11**: Database migration tools, backup strategies
- **Week 12**: Monitoring setup, logging, error tracking

### Phase 4: Testing & Deployment (Weeks 13-16)
- **Week 13**: Comprehensive testing suite, unit and integration tests
- **Week 14**: Load testing, performance testing, security testing
- **Week 15**: API documentation, deployment preparation
- **Week 16**: Production deployment, monitoring setup

---

## Success Metrics

### Performance Targets
- **API Response Time**: <200ms for 95% of requests
- **Database Query Time**: <50ms for simple queries, <200ms for complex
- **File Upload Processing**: <10 seconds for receipt OCR
- **Background Task Processing**: <30 seconds for notifications
- **Concurrent Users**: Support 10,000+ simultaneous connections

### Reliability Metrics
- **Uptime**: 99.9% availability
- **Error Rate**: <0.1% of API requests
- **Data Consistency**: 100% ACID compliance
- **Backup Success**: 100% successful daily backups
- **Security**: Zero data breaches, complete audit trails

### Quality Metrics
- **Test Coverage**: >90% code coverage
- **API Documentation**: 100% endpoint documentation
- **Security Compliance**: Full SOX, GDPR, PCI DSS compliance
- **Code Quality**: Pass all linting and type checking

---

## Conclusion

This comprehensive FastAPI backend development plan provides a robust, secure, and scalable foundation for ExpenseFlow. The architecture emphasizes performance, security, and maintainability while supporting the complex business workflows required for enterprise expense management.

The combination of FastAPI's modern Python features, SQLAlchemy's powerful ORM capabilities, and Celery's background task processing creates a highly efficient backend that can scale from startup to enterprise levels.

By following this implementation plan, the development team will deliver a production-ready API that seamlessly integrates with both mobile and web clients while maintaining the highest standards of security and performance.

---

*This document serves as the complete implementation guide for ExpenseFlow's backend API, ensuring consistent development practices and successful project delivery.*