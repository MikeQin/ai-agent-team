import pytest
from fastapi.testclient import TestClient

def test_health_check(client):
    """Test basic health check endpoint"""
    response = client.get("/")
    assert response.status_code == 200
    assert "ExpenseFlow API is running" in response.json()["message"]

def test_register_user(client):
    """Test user registration"""
    user_data = {
        "email": "newuser@example.com",
        "username": "newuser",
        "full_name": "New User",
        "password": "newpassword",
        "department": "Engineering",
        "position": "Developer"
    }
    
    response = client.post("/api/v1/auth/register", json=user_data)
    assert response.status_code == 200
    
    data = response.json()
    assert data["email"] == user_data["email"]
    assert data["username"] == user_data["username"]
    assert data["full_name"] == user_data["full_name"]
    assert "hashed_password" not in data

def test_register_duplicate_email(client, test_user):
    """Test registration with duplicate email"""
    user_data = {
        "email": test_user.email,
        "username": "different_username",
        "full_name": "Different User",
        "password": "password"
    }
    
    response = client.post("/api/v1/auth/register", json=user_data)
    assert response.status_code == 400
    assert "already registered" in response.json()["detail"]

def test_login_success(client, test_user):
    """Test successful login"""
    form_data = {
        "username": test_user.email,  # OAuth2 uses 'username' field
        "password": "testpassword"
    }
    
    response = client.post("/api/v1/auth/login", data=form_data)
    assert response.status_code == 200
    
    data = response.json()
    assert "access_token" in data
    assert data["token_type"] == "bearer"

def test_login_invalid_credentials(client):
    """Test login with invalid credentials"""
    form_data = {
        "username": "nonexistent@example.com",
        "password": "wrongpassword"
    }
    
    response = client.post("/api/v1/auth/login", data=form_data)
    assert response.status_code == 401
    assert "Incorrect email or password" in response.json()["detail"]

def test_login_inactive_user(client, test_user, db_session):
    """Test login with inactive user"""
    # Deactivate user
    test_user.is_active = False
    db_session.commit()
    
    form_data = {
        "username": test_user.email,
        "password": "testpassword"
    }
    
    response = client.post("/api/v1/auth/login", data=form_data)
    assert response.status_code == 400
    assert "Inactive user" in response.json()["detail"]