-- Initialize ExpenseFlow Database
-- This script runs when the PostgreSQL container starts for the first time

-- Create initial expense categories
INSERT INTO categories (name, description, is_active, created_at) VALUES
('Travel', 'Travel and transportation expenses', true, NOW()),
('Meals', 'Business meals and entertainment', true, NOW()),
('Office Supplies', 'Office supplies and equipment', true, NOW()),
('Software', 'Software licenses and subscriptions', true, NOW()),
('Training', 'Training and education expenses', true, NOW()),
('Marketing', 'Marketing and advertising expenses', true, NOW()),
('Utilities', 'Utilities and telecommunications', true, NOW()),
('Professional Services', 'Legal, accounting, and consulting fees', true, NOW())
ON CONFLICT (name) DO NOTHING;

-- Create default admin user (password: admin123)
INSERT INTO users (
    email, 
    username, 
    full_name, 
    hashed_password, 
    is_active, 
    is_admin, 
    department, 
    position,
    created_at,
    updated_at
) VALUES (
    'admin@expenseflow.com',
    'admin',
    'System Administrator',
    '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', -- admin123
    true,
    true,
    'Administration',
    'System Administrator',
    NOW(),
    NOW()
) ON CONFLICT (email) DO NOTHING;

-- Create sample manager user (password: manager123)
INSERT INTO users (
    email, 
    username, 
    full_name, 
    hashed_password, 
    is_active, 
    is_admin, 
    department, 
    position,
    created_at,
    updated_at
) VALUES (
    'manager@expenseflow.com',
    'manager',
    'Finance Manager',
    '$2b$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- manager123
    true,
    false,
    'Finance',
    'Manager',
    NOW(),
    NOW()
) ON CONFLICT (email) DO NOTHING;