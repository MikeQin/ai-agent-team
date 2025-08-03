import pytest
from datetime import datetime
from app.models.expense import Expense

def test_create_expense(authenticated_client, test_category):
    """Test creating a new expense"""
    expense_data = {
        "amount": 99.99,
        "description": "Test expense",
        "expense_date": "2024-01-15T00:00:00",
        "category_id": test_category.id,
        "project_code": "PROJ001",
        "business_purpose": "Testing expense creation"
    }
    
    response = authenticated_client.post("/api/v1/expenses", json=expense_data)
    assert response.status_code == 200
    
    data = response.json()
    assert data["amount"] == expense_data["amount"]
    assert data["description"] == expense_data["description"]
    assert data["category_id"] == expense_data["category_id"]
    assert data["status"] == "draft"

def test_create_expense_invalid_category(authenticated_client):
    """Test creating expense with invalid category"""
    expense_data = {
        "amount": 99.99,
        "description": "Test expense",
        "expense_date": "2024-01-15T00:00:00",
        "category_id": 99999  # Non-existent category
    }
    
    response = authenticated_client.post("/api/v1/expenses", json=expense_data)
    assert response.status_code == 404
    assert "Category not found" in response.json()["detail"]

def test_get_expenses(authenticated_client, test_category, test_user, db_session):
    """Test retrieving user's expenses"""
    # Create test expense
    expense = Expense(
        amount=150.50,
        description="Test expense",
        expense_date=datetime(2024, 1, 15),
        category_id=test_category.id,
        employee_id=test_user.id,
        status="submitted"
    )
    db_session.add(expense)
    db_session.commit()
    
    response = authenticated_client.get("/api/v1/expenses")
    assert response.status_code == 200
    
    data = response.json()
    assert len(data) == 1
    assert data[0]["amount"] == 150.50
    assert data[0]["description"] == "Test expense"

def test_get_expenses_with_status_filter(authenticated_client, test_category, test_user, db_session):
    """Test filtering expenses by status"""
    # Create expenses with different statuses
    expenses = [
        Expense(amount=100, description="Draft", expense_date=datetime.now(), 
               category_id=test_category.id, employee_id=test_user.id, status="draft"),
        Expense(amount=200, description="Submitted", expense_date=datetime.now(), 
               category_id=test_category.id, employee_id=test_user.id, status="submitted"),
    ]
    
    for expense in expenses:
        db_session.add(expense)
    db_session.commit()
    
    # Test filter by status
    response = authenticated_client.get("/api/v1/expenses?status=draft")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 1
    assert data[0]["status"] == "draft"

def test_update_expense(authenticated_client, test_category, test_user, db_session):
    """Test updating a draft expense"""
    # Create draft expense
    expense = Expense(
        amount=100.00,
        description="Original description",
        expense_date=datetime(2024, 1, 15),
        category_id=test_category.id,
        employee_id=test_user.id,
        status="draft"
    )
    db_session.add(expense)
    db_session.commit()
    
    # Update expense
    update_data = {
        "amount": 150.00,
        "description": "Updated description"
    }
    
    response = authenticated_client.put(f"/api/v1/expenses/{expense.id}", json=update_data)
    assert response.status_code == 200
    
    data = response.json()
    assert data["amount"] == 150.00
    assert data["description"] == "Updated description"

def test_update_submitted_expense_fails(authenticated_client, test_category, test_user, db_session):
    """Test that submitted expenses cannot be updated"""
    # Create submitted expense
    expense = Expense(
        amount=100.00,
        description="Submitted expense",
        expense_date=datetime(2024, 1, 15),
        category_id=test_category.id,
        employee_id=test_user.id,
        status="submitted"
    )
    db_session.add(expense)
    db_session.commit()
    
    # Try to update
    update_data = {"amount": 150.00}
    
    response = authenticated_client.put(f"/api/v1/expenses/{expense.id}", json=update_data)
    assert response.status_code == 400
    assert "Can only update draft expenses" in response.json()["detail"]

def test_submit_expense(authenticated_client, test_category, test_user, test_manager, db_session):
    """Test submitting an expense for approval"""
    # Set manager for user
    test_user.manager_id = test_manager.id
    db_session.commit()
    
    # Create draft expense
    expense = Expense(
        amount=100.00,
        description="Expense to submit",
        expense_date=datetime(2024, 1, 15),
        category_id=test_category.id,
        employee_id=test_user.id,
        status="draft"
    )
    db_session.add(expense)
    db_session.commit()
    
    # Submit expense
    response = authenticated_client.post(f"/api/v1/expenses/{expense.id}/submit")
    assert response.status_code == 200
    assert "submitted for approval" in response.json()["message"]

def test_get_categories(authenticated_client, test_category):
    """Test retrieving expense categories"""
    response = authenticated_client.get("/api/v1/categories")
    assert response.status_code == 200
    
    data = response.json()
    assert len(data) >= 1
    assert any(cat["name"] == test_category.name for cat in data)

def test_create_category_admin_only(authenticated_client, test_manager, client):
    """Test that only admins can create categories"""
    # Test with regular user (should fail)
    category_data = {
        "name": "New Category",
        "description": "A new category"
    }
    
    response = authenticated_client.post("/api/v1/categories", json=category_data)
    assert response.status_code == 403
    
    # Test with admin user (should succeed)
    login_response = client.post(
        "/api/v1/auth/login",
        data={"username": test_manager.email, "password": "managerpassword"}
    )
    admin_token = login_response.json()["access_token"]
    
    admin_client = client
    admin_client.headers.update({"Authorization": f"Bearer {admin_token}"})
    
    response = admin_client.post("/api/v1/categories", json=category_data)
    assert response.status_code == 200
    
    data = response.json()
    assert data["name"] == category_data["name"]

def test_unauthorized_access(client):
    """Test that endpoints require authentication"""
    # Test without auth token
    response = client.get("/api/v1/expenses")
    assert response.status_code == 401

def test_invalid_token(client):
    """Test with invalid auth token"""
    client.headers.update({"Authorization": "Bearer invalid_token"})
    response = client.get("/api/v1/expenses")
    assert response.status_code == 401