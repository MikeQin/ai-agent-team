from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime

from ...core.database import get_db
from ...api.deps import get_current_user
from ...models.user import User
from ...models.expense import Expense, Category, Approval
from ...schemas.expense import (
    ExpenseCreate, ExpenseUpdate, ExpenseResponse, ExpenseWithApprovals,
    CategoryCreate, CategoryResponse,
    ApprovalCreate, ApprovalResponse
)

router = APIRouter()

# Expense endpoints
@router.post("/expenses", response_model=ExpenseResponse)
def create_expense(
    expense_data: ExpenseCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new expense"""
    # Verify category exists
    category = db.query(Category).filter(Category.id == expense_data.category_id).first()
    if not category:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Category not found"
        )
    
    db_expense = Expense(
        **expense_data.dict(),
        employee_id=current_user.id,
        status="draft"
    )
    
    db.add(db_expense)
    db.commit()
    db.refresh(db_expense)
    
    return db_expense

@router.get("/expenses", response_model=List[ExpenseResponse])
def get_expenses(
    skip: int = 0,
    limit: int = 100,
    status: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get user's expenses"""
    query = db.query(Expense).filter(Expense.employee_id == current_user.id)
    
    if status:
        query = query.filter(Expense.status == status)
    
    expenses = query.offset(skip).limit(limit).all()
    return expenses

@router.get("/expenses/{expense_id}", response_model=ExpenseWithApprovals)
def get_expense(
    expense_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get a specific expense"""
    expense = db.query(Expense).filter(
        Expense.id == expense_id,
        Expense.employee_id == current_user.id
    ).first()
    
    if not expense:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Expense not found"
        )
    
    return expense

@router.put("/expenses/{expense_id}", response_model=ExpenseResponse)
def update_expense(
    expense_id: int,
    expense_data: ExpenseUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update an expense (only if in draft status)"""
    expense = db.query(Expense).filter(
        Expense.id == expense_id,
        Expense.employee_id == current_user.id
    ).first()
    
    if not expense:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Expense not found"
        )
    
    if expense.status != "draft":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Can only update draft expenses"
        )
    
    # Update fields
    update_data = expense_data.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(expense, field, value)
    
    expense.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(expense)
    
    return expense

@router.post("/expenses/{expense_id}/submit")
def submit_expense(
    expense_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Submit expense for approval"""
    expense = db.query(Expense).filter(
        Expense.id == expense_id,
        Expense.employee_id == current_user.id
    ).first()
    
    if not expense:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Expense not found"
        )
    
    if expense.status != "draft":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Can only submit draft expenses"
        )
    
    expense.status = "submitted"
    expense.submitted_at = datetime.utcnow()
    
    # Create approval record (simplified - in reality would create based on approval workflow)
    if current_user.manager_id:
        approval = Approval(
            expense_id=expense.id,
            approver_id=current_user.manager_id,
            status="pending"
        )
        db.add(approval)
    
    db.commit()
    
    return {"message": "Expense submitted for approval"}

# Category endpoints
@router.get("/categories", response_model=List[CategoryResponse])
def get_categories(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all active categories"""
    categories = db.query(Category).filter(Category.is_active == True).all()
    return categories

@router.post("/categories", response_model=CategoryResponse)
def create_category(
    category_data: CategoryCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new category (admin only)"""
    if not current_user.is_admin:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    # Check if category already exists
    existing = db.query(Category).filter(Category.name == category_data.name).first()
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Category already exists"
        )
    
    db_category = Category(**category_data.dict())
    db.add(db_category)
    db.commit()
    db.refresh(db_category)
    
    return db_category

# Approval endpoints (for managers)
@router.get("/approvals/pending", response_model=List[ExpenseWithApprovals])
def get_pending_approvals(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get expenses pending approval by current user"""
    approvals = db.query(Approval).filter(
        Approval.approver_id == current_user.id,
        Approval.status == "pending"
    ).all()
    
    expenses = [approval.expense for approval in approvals]
    return expenses

@router.post("/approvals/{approval_id}/approve")
def approve_expense(
    approval_id: int,
    comments: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Approve an expense"""
    approval = db.query(Approval).filter(
        Approval.id == approval_id,
        Approval.approver_id == current_user.id
    ).first()
    
    if not approval:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Approval not found"
        )
    
    if approval.status != "pending":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Approval already processed"
        )
    
    # Update approval
    approval.status = "approved"
    approval.comments = comments
    approval.approved_at = datetime.utcnow()
    
    # Update expense status
    expense = approval.expense
    expense.status = "approved"
    expense.approved_at = datetime.utcnow()
    
    db.commit()
    
    return {"message": "Expense approved"}

@router.post("/approvals/{approval_id}/reject")
def reject_expense(
    approval_id: int,
    comments: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Reject an expense"""
    approval = db.query(Approval).filter(
        Approval.id == approval_id,
        Approval.approver_id == current_user.id
    ).first()
    
    if not approval:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Approval not found"
        )
    
    if approval.status != "pending":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Approval already processed"
        )
    
    # Update approval
    approval.status = "rejected"
    approval.comments = comments
    approval.approved_at = datetime.utcnow()
    
    # Update expense status
    expense = approval.expense
    expense.status = "rejected"
    expense.rejected_at = datetime.utcnow()
    expense.rejection_reason = comments
    
    db.commit()
    
    return {"message": "Expense rejected"}