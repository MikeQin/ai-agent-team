from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class CategoryBase(BaseModel):
    name: str
    description: Optional[str] = None

class CategoryCreate(CategoryBase):
    pass

class CategoryResponse(CategoryBase):
    id: int
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

class ExpenseBase(BaseModel):
    amount: float
    currency: str = "USD"
    description: str
    expense_date: datetime
    category_id: int
    project_code: Optional[str] = None
    business_purpose: Optional[str] = None

class ExpenseCreate(ExpenseBase):
    pass

class ExpenseUpdate(BaseModel):
    amount: Optional[float] = None
    description: Optional[str] = None
    expense_date: Optional[datetime] = None
    category_id: Optional[int] = None
    project_code: Optional[str] = None
    business_purpose: Optional[str] = None

class ExpenseResponse(ExpenseBase):
    id: int
    employee_id: int
    status: str
    receipt_url: Optional[str]
    receipt_filename: Optional[str]
    submitted_at: Optional[datetime]
    approved_at: Optional[datetime]
    rejected_at: Optional[datetime]
    rejection_reason: Optional[str]
    created_at: datetime
    updated_at: datetime
    
    # Related objects
    category: CategoryResponse
    
    class Config:
        from_attributes = True

class ApprovalBase(BaseModel):
    status: str
    comments: Optional[str] = None

class ApprovalCreate(ApprovalBase):
    expense_id: int

class ApprovalResponse(ApprovalBase):
    id: int
    expense_id: int
    approver_id: int
    approved_at: Optional[datetime]
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True

class ExpenseWithApprovals(ExpenseResponse):
    approvals: List[ApprovalResponse] = []