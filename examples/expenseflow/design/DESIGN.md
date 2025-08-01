# ExpenseFlow - System Architecture Document

## Executive Summary

This document outlines the comprehensive system architecture for ExpenseFlow, a modern expense management platform supporting 10,000+ concurrent users across mobile, web, and API interfaces. The architecture emphasizes scalability, security, compliance, and optimal user experience through offline-first mobile design and real-time web dashboards.

**Key Architecture Decisions:**
- Microservices architecture with domain-driven design
- Event-driven communication for real-time updates
- Multi-tenant data isolation for enterprise security
- Cloud-native deployment with auto-scaling capabilities
- Offline-first mobile app with conflict resolution
- Comprehensive audit trails for financial compliance

---

## 1. High-Level Architecture

### 1.1 Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                             │
├─────────────────────────────────────────────────────────────────┤
│  Flutter Mobile App     │    Next.js Web Dashboard             │
│  (iOS/Android)          │    (Managers/Admins)                 │
│  - Offline-first        │    - Real-time updates               │
│  - OCR capture          │    - Analytics dashboard             │
│  - Push notifications   │    - Approval workflows              │
└─────────────────────────────────────────────────────────────────┘
                                    │
                            ┌───────┴───────┐
                            │  Load Balancer │
                            │  (ALB/CloudFlare) │
                            └───────┬───────┘
                                    │
┌─────────────────────────────────────────────────────────────────┐
│                       API GATEWAY                               │
├─────────────────────────────────────────────────────────────────┤
│  - Authentication & Authorization                               │
│  - Rate Limiting & Throttling                                   │
│  - Request/Response Transformation                              │
│  - API Versioning & Documentation                               │
└─────────────────────────────────────────────────────────────────┘
                                    │
┌─────────────────────────────────────────────────────────────────┐
│                    MICROSERVICES LAYER                          │
├─────────────────────────────────────────────────────────────────┤
│  Auth Service  │  Expense Service  │  OCR Service               │
│  User Service  │  Approval Service │  Notification Service      │
│  File Service  │  Analytics Service│  Integration Service       │
└─────────────────────────────────────────────────────────────────┘
                                    │
┌─────────────────────────────────────────────────────────────────┐
│                     DATA LAYER                                  │
├─────────────────────────────────────────────────────────────────┤
│  PostgreSQL    │    Redis Cache    │    Object Storage         │
│  (Primary DB)  │    (Sessions)     │    (Receipt Images)       │
│  Event Store   │    Search Index   │    Backup Storage         │
└─────────────────────────────────────────────────────────────────┘
```

### 1.2 Architecture Principles

**1. Domain-Driven Design (DDD)**
- Clear bounded contexts for each business domain
- Independent deployment and scaling
- Domain expertise encapsulation

**2. Event-Driven Architecture**
- Asynchronous communication between services
- Event sourcing for audit trails
- Real-time updates across all clients

**3. Microservices Pattern**
- Single responsibility per service
- Independent technology stacks where beneficial
- Fault isolation and resilience

**4. Cloud-Native Design**
- Containerized deployments
- Infrastructure as Code
- Auto-scaling and self-healing

---

## 2. System Components

### 2.1 Client Applications

#### 2.1.1 Flutter Mobile App

**Architecture Pattern:** BLoC (Business Logic Component)

```
┌─── Presentation Layer ────┐
│  Screens & Widgets        │
│  - Expense submission     │
│  - Camera integration     │
│  - Offline sync status    │
└───────────────────────────┘
            │
┌─── Business Logic Layer ──┐
│  BLoC Classes             │
│  - ExpenseBloc            │
│  - CameraBloc             │
│  - SyncBloc               │
└───────────────────────────┘
            │
┌─── Data Layer ───────────┐
│  Repositories             │
│  - Local Storage (SQLite) │
│  - Remote API Client      │
│  - Sync Manager           │
└───────────────────────────┘
```

**Key Features:**
- **Offline-First Architecture**: Complete functionality without network
- **Background Sync**: Intelligent conflict resolution
- **Camera Integration**: Auto-focus, lighting detection, crop guides
- **Push Notifications**: FCM with custom payload handling
- **Biometric Auth**: Face ID, Touch ID, Fingerprint
- **Local Encryption**: AES-256 for sensitive data at rest

**State Management:**
```dart
// Example BLoC architecture for expense submission
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository _repository;
  final SyncManager _syncManager;
  
  ExpenseBloc(this._repository, this._syncManager) : super(ExpenseInitial()) {
    on<SubmitExpense>(_onSubmitExpense);
    on<SyncPendingExpenses>(_onSyncPending);
  }
  
  Future<void> _onSubmitExpense(SubmitExpense event, Emitter<ExpenseState> emit) async {
    // Save locally first
    await _repository.saveLocal(event.expense);
    emit(ExpenseSubmitted(event.expense));
    
    // Attempt sync
    _syncManager.queueForSync(event.expense);
  }
}
```

#### 2.1.2 Next.js Web Dashboard

**Architecture Pattern:** App Router with Server Components

```
┌─── App Router Structure ──────┐
│  app/                         │
│  ├── dashboard/               │
│  │   ├── page.tsx             │
│  │   ├── expenses/            │
│  │   ├── analytics/           │
│  │   └── admin/               │
│  ├── api/                     │
│  │   ├── auth/                │
│  │   └── webhooks/            │
│  └── components/              │
│      ├── shared/              │
│      └── domain/              │
└───────────────────────────────┘
```

**Key Features:**
- **Server-Side Rendering**: Optimal performance and SEO
- **Real-time Updates**: WebSocket integration with optimistic updates
- **Progressive Web App**: Offline capability for core features
- **Responsive Design**: Mobile-first responsive layouts
- **Component Library**: Reusable UI components with TypeScript
- **Advanced Analytics**: Interactive charts with Chart.js/D3.js

**Real-time Architecture:**
```typescript
// WebSocket integration for real-time updates
export const useRealTimeExpenses = (userId: string) => {
  const [expenses, setExpenses] = useState<Expense[]>([]);
  
  useEffect(() => {
    const ws = new WebSocket(`${WS_URL}/expenses/${userId}`);
    
    ws.onmessage = (event) => {
      const update = JSON.parse(event.data);
      setExpenses(prev => updateExpenseInList(prev, update));
    };
    
    return () => ws.close();
  }, [userId]);
  
  return expenses;
};
```

### 2.2 Backend Services

#### 2.2.1 API Gateway

**Technology:** Kong/AWS API Gateway with custom middleware

**Responsibilities:**
- **Authentication & Authorization**: JWT validation, MFA enforcement
- **Rate Limiting**: Per-user and per-endpoint throttling
- **Request Transformation**: API versioning, request/response mapping
- **Monitoring**: Request tracing, performance metrics
- **Security**: DDoS protection, IP whitelisting, request sanitization

**Configuration Example:**
```yaml
services:
  - name: expense-service
    url: http://expense-service:8000
    plugins:
      - name: jwt
        config:
          claims_to_verify: [exp, iat, sub]
      - name: rate-limiting
        config:
          minute: 100
          hour: 1000
      - name: correlation-id
      - name: prometheus
```

#### 2.2.2 Core Microservices

**Service Communication:**
- **Synchronous**: REST APIs for immediate responses
- **Asynchronous**: Event bus (Redis Streams/RabbitMQ) for workflows
- **Data Consistency**: Saga pattern for distributed transactions

##### Authentication Service

```python
# FastAPI service structure
from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

app = FastAPI(title="Auth Service", version="1.0.0")

@app.post("/auth/login")
async def login(credentials: LoginRequest, db: Session = Depends(get_db)):
    # MFA-enabled authentication
    user = await authenticate_user(credentials.email, credentials.password, db)
    if user.mfa_enabled:
        return {"requires_mfa": True, "session_token": generate_temp_token(user)}
    
    access_token = create_access_token(user)
    refresh_token = create_refresh_token(user)
    
    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "expires_in": 3600
    }
```

**Features:**
- JWT-based authentication with refresh tokens
- Multi-factor authentication (TOTP, SMS)
- Role-based access control (RBAC)
- SSO integration (SAML 2.0, OAuth 2.0)
- Session management with Redis
- Account lockout and suspicious activity detection

##### Expense Service

**Domain Model:**
```python
from sqlalchemy import Column, String, DateTime, Decimal, Enum
from sqlalchemy.dialects.postgresql import UUID
import uuid

class Expense(BaseModel):
    __tablename__ = "expenses"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), nullable=False, index=True)
    title = Column(String(255), nullable=False)
    description = Column(Text)
    amount = Column(Decimal(10, 2), nullable=False)
    currency = Column(String(3), default="USD")
    category_id = Column(UUID(as_uuid=True), nullable=False)
    date_incurred = Column(DateTime, nullable=False)
    status = Column(Enum(ExpenseStatus), default=ExpenseStatus.DRAFT)
    tenant_id = Column(UUID(as_uuid=True), nullable=False)  # Multi-tenancy
    
    # Audit fields
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    version = Column(Integer, default=1)  # Optimistic locking
```

**API Design:**
```python
@app.post("/api/v1/expenses", response_model=ExpenseResponse)
async def create_expense(
    expense: ExpenseCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    try:
        # Business logic validation
        validate_expense_policy(expense, current_user.tenant_id)
        
        # Create expense
        db_expense = Expense(**expense.dict(), user_id=current_user.id)
        db.add(db_expense)
        db.commit()
        
        # Publish event for workflow processing
        await event_bus.publish(ExpenseCreated(expense_id=db_expense.id))
        
        return ExpenseResponse.from_orm(db_expense)
        
    except PolicyViolationError as e:
        raise HTTPException(status_code=400, detail=str(e))
```

##### OCR Service

**Architecture:**
```python
from typing import List, Optional
import asyncio
from concurrent.futures import ThreadPoolExecutor

class OCRService:
    def __init__(self):
        self.providers = [
            GoogleVisionOCR(),
            AWSTextractOCR(),
            AzureComputerVisionOCR()
        ]
        self.executor = ThreadPoolExecutor(max_workers=10)
    
    async def extract_receipt_data(self, image_bytes: bytes) -> ReceiptData:
        # Parallel processing with multiple OCR providers
        tasks = []
        for provider in self.providers:
            task = asyncio.get_event_loop().run_in_executor(
                self.executor, provider.extract, image_bytes
            )
            tasks.append(task)
        
        results = await asyncio.gather(*tasks, return_exceptions=True)
        
        # Confidence-based result selection
        best_result = self._select_best_result(results)
        
        # Business logic extraction
        return self._parse_receipt_data(best_result)
    
    def _select_best_result(self, results: List) -> dict:
        valid_results = [r for r in results if not isinstance(r, Exception)]
        return max(valid_results, key=lambda x: x.get('confidence', 0))
```

##### Approval Service

**Workflow Engine:**
```python
from enum import Enum
from dataclasses import dataclass

class ApprovalRule:
    def __init__(self, condition: str, action: str, approver_id: Optional[str] = None):
        self.condition = condition  # e.g., "amount > 100"
        self.action = action        # e.g., "require_approval"
        self.approver_id = approver_id

class ApprovalWorkflow:
    def __init__(self, rules: List[ApprovalRule]):
        self.rules = rules
    
    async def process_expense(self, expense: Expense) -> ApprovalDecision:
        for rule in self.rules:
            if self._evaluate_condition(rule.condition, expense):
                if rule.action == "auto_approve":
                    return ApprovalDecision(
                        action=ApprovalAction.APPROVED,
                        approver_id="system",
                        reason="Auto-approved by policy"
                    )
                elif rule.action == "require_approval":
                    approver = await self._find_approver(expense, rule.approver_id)
                    await self._create_approval_request(expense, approver)
                    return ApprovalDecision(
                        action=ApprovalAction.PENDING,
                        approver_id=approver.id,
                        reason="Requires manager approval"
                    )
        
        return ApprovalDecision(action=ApprovalAction.APPROVED, reason="Default approval")
```

##### Notification Service

**Multi-Channel Architecture:**
```python
from abc import ABC, abstractmethod

class NotificationChannel(ABC):
    @abstractmethod
    async def send(self, recipient: str, message: NotificationMessage):
        pass

class PushNotificationChannel(NotificationChannel):
    async def send(self, recipient: str, message: NotificationMessage):
        await fcm_client.send_to_device(
            token=recipient,
            notification=Notification(
                title=message.title,
                body=message.body
            ),
            data=message.data
        )

class EmailNotificationChannel(NotificationChannel):
    async def send(self, recipient: str, message: NotificationMessage):
        await email_client.send_email(
            to=recipient,
            subject=message.title,
            html_content=message.render_html_template()
        )

class NotificationService:
    def __init__(self):
        self.channels = {
            'push': PushNotificationChannel(),
            'email': EmailNotificationChannel(),
            'sms': SMSNotificationChannel()
        }
    
    async def send_notification(self, user: User, event: DomainEvent):
        preferences = await self._get_user_preferences(user.id)
        message = self._create_message(event, user)
        
        for channel_type in preferences.enabled_channels:
            channel = self.channels[channel_type]
            await channel.send(user.contact_info[channel_type], message)
```

---

## 3. Database Design

### 3.1 PostgreSQL Schema

**Multi-Tenant Architecture with Row-Level Security:**

```sql
-- Enable Row Level Security
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

-- Create tenant isolation policy
CREATE POLICY tenant_isolation ON expenses
    FOR ALL TO authenticated_users
    USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

-- Core Tables
CREATE TABLE tenants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    domain VARCHAR(255) UNIQUE,
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role user_role NOT NULL DEFAULT 'employee',
    department_id UUID REFERENCES departments(id),
    manager_id UUID REFERENCES users(id),
    is_active BOOLEAN DEFAULT TRUE,
    mfa_secret VARCHAR(255),
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    version INTEGER DEFAULT 1
);

CREATE TABLE expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id),
    user_id UUID NOT NULL REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    currency CHAR(3) DEFAULT 'USD',
    category_id UUID NOT NULL REFERENCES expense_categories(id),
    date_incurred DATE NOT NULL,
    status expense_status DEFAULT 'draft',
    business_purpose TEXT,
    client_id UUID REFERENCES clients(id),
    project_id UUID REFERENCES projects(id),
    submission_date TIMESTAMP,
    approval_date TIMESTAMP,
    payment_date TIMESTAMP,
    gl_account_code VARCHAR(50),
    
    -- Audit and versioning
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    created_by UUID NOT NULL REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    version INTEGER DEFAULT 1,
    
    -- Full-text search
    search_vector TSVECTOR GENERATED ALWAYS AS (
        to_tsvector('english', 
            COALESCE(title, '') || ' ' || 
            COALESCE(description, '') || ' ' ||
            COALESCE(business_purpose, '')
        )
    ) STORED
);

-- Indexes for performance
CREATE INDEX idx_expenses_user_status ON expenses(user_id, status);
CREATE INDEX idx_expenses_tenant_date ON expenses(tenant_id, date_incurred DESC);
CREATE INDEX idx_expenses_search ON expenses USING GIN(search_vector);
CREATE INDEX idx_expenses_amount_category ON expenses(category_id, amount);

-- Receipts table with JSONB for OCR data
CREATE TABLE receipts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expense_id UUID NOT NULL REFERENCES expenses(id) ON DELETE CASCADE,
    file_name VARCHAR(255) NOT NULL,
    file_size BIGINT NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    file_url TEXT NOT NULL,
    file_hash VARCHAR(64) UNIQUE, -- SHA-256 for deduplication
    
    -- OCR data with structured extraction
    ocr_data JSONB DEFAULT '{}',
    ocr_confidence DECIMAL(3,2),
    ocr_processed_at TIMESTAMP,
    
    -- Image metadata
    image_width INTEGER,
    image_height INTEGER,
    image_dpi INTEGER,
    
    created_at TIMESTAMP DEFAULT NOW(),
    
    CONSTRAINT valid_ocr_confidence CHECK (ocr_confidence BETWEEN 0 AND 1)
);

-- Approval workflow table
CREATE TABLE approvals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expense_id UUID NOT NULL REFERENCES expenses(id),
    approver_id UUID NOT NULL REFERENCES users(id),
    sequence_order INTEGER NOT NULL,
    status approval_status DEFAULT 'pending',
    comments TEXT,
    approved_at TIMESTAMP,
    
    -- Delegation support
    delegated_from UUID REFERENCES users(id),
    delegation_reason TEXT,
    
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(expense_id, sequence_order)
);
```

### 3.2 Event Store Design

**Event Sourcing for Audit Trails:**

```sql
CREATE TABLE event_store (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    aggregate_id UUID NOT NULL,
    aggregate_type VARCHAR(100) NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    event_data JSONB NOT NULL,
    event_metadata JSONB DEFAULT '{}',
    sequence_number BIGINT NOT NULL,
    occurred_at TIMESTAMP DEFAULT NOW(),
    user_id UUID REFERENCES users(id),
    correlation_id UUID,
    causation_id UUID,
    
    -- Partition by tenant for performance
    UNIQUE(tenant_id, aggregate_id, sequence_number)
) PARTITION BY HASH(tenant_id);

-- Create partitions (example for 4 partitions)
CREATE TABLE event_store_p0 PARTITION OF event_store FOR VALUES WITH (modulus 4, remainder 0);
CREATE TABLE event_store_p1 PARTITION OF event_store FOR VALUES WITH (modulus 4, remainder 1);
CREATE TABLE event_store_p2 PARTITION OF event_store FOR VALUES WITH (modulus 4, remainder 2);
CREATE TABLE event_store_p3 PARTITION OF event_store FOR VALUES WITH (modulus 4, remainder 3);

-- Indexes for event querying
CREATE INDEX idx_event_store_aggregate ON event_store(tenant_id, aggregate_id, sequence_number);
CREATE INDEX idx_event_store_type_time ON event_store(tenant_id, event_type, occurred_at);
```

### 3.3 Redis Caching Strategy

**Multi-Layer Caching:**

```python
class CacheService:
    def __init__(self):
        self.redis_client = redis.Redis(decode_responses=True)
        self.cache_layers = {
            'session': {'ttl': 3600, 'prefix': 'sess:'},
            'user': {'ttl': 1800, 'prefix': 'user:'},
            'expense': {'ttl': 300, 'prefix': 'exp:'},
            'analytics': {'ttl': 900, 'prefix': 'analytics:'}
        }
    
    async def get_user_expenses(self, user_id: str, filters: dict) -> List[Expense]:
        cache_key = f"user:{user_id}:expenses:{hash(str(filters))}"
        
        cached = await self.redis_client.get(cache_key)
        if cached:
            return json.loads(cached)
        
        # Fetch from database
        expenses = await self._fetch_user_expenses(user_id, filters)
        
        # Cache with appropriate TTL
        await self.redis_client.setex(
            cache_key, 
            self.cache_layers['expense']['ttl'], 
            json.dumps(expenses, default=str)
        )
        
        return expenses
    
    async def invalidate_user_cache(self, user_id: str):
        pattern = f"user:{user_id}:*"
        keys = await self.redis_client.keys(pattern)
        if keys:
            await self.redis_client.delete(*keys)
```

---

## 4. Security Architecture

### 4.1 Authentication & Authorization

**Multi-Factor Authentication Flow:**

```python
class MFAService:
    def __init__(self):
        self.totp_service = TOTPService()
        self.sms_service = SMSService()
    
    async def initiate_login(self, email: str, password: str) -> LoginResponse:
        user = await self.authenticate_credentials(email, password)
        
        if not user:
            raise AuthenticationError("Invalid credentials")
        
        if user.mfa_enabled:
            # Generate temporary session token
            temp_token = self.generate_temp_token(user)
            
            # Send MFA challenge
            if user.mfa_method == 'totp':
                return LoginResponse(
                    requires_mfa=True,
                    mfa_method='totp',
                    temp_token=temp_token
                )
            elif user.mfa_method == 'sms':
                code = await self.sms_service.send_verification_code(user.phone)
                return LoginResponse(
                    requires_mfa=True,
                    mfa_method='sms',
                    temp_token=temp_token
                )
        
        # Standard login without MFA
        return self.complete_login(user)
    
    async def verify_mfa(self, temp_token: str, mfa_code: str) -> LoginResponse:
        user = self.verify_temp_token(temp_token)
        
        if user.mfa_method == 'totp':
            if not self.totp_service.verify(user.mfa_secret, mfa_code):
                raise MFAError("Invalid TOTP code")
        elif user.mfa_method == 'sms':
            if not await self.sms_service.verify_code(user.phone, mfa_code):
                raise MFAError("Invalid SMS code")
        
        return self.complete_login(user)
```

### 4.2 Data Encryption

**Encryption at Rest and in Transit:**

```python
from cryptography.fernet import Fernet
import base64

class EncryptionService:
    def __init__(self, encryption_key: bytes):
        self.cipher_suite = Fernet(encryption_key)
    
    def encrypt_sensitive_data(self, data: str) -> str:
        """Encrypt PII and sensitive financial data"""
        encrypted_bytes = self.cipher_suite.encrypt(data.encode())
        return base64.b64encode(encrypted_bytes).decode()
    
    def decrypt_sensitive_data(self, encrypted_data: str) -> str:
        """Decrypt sensitive data for authorized access"""
        encrypted_bytes = base64.b64decode(encrypted_data.encode())
        decrypted_bytes = self.cipher_suite.decrypt(encrypted_bytes)
        return decrypted_bytes.decode()

# Database column-level encryption
class EncryptedColumn(TypeDecorator):
    impl = String
    
    def process_bind_param(self, value, dialect):
        if value is not None:
            return encryption_service.encrypt_sensitive_data(value)
        return value
    
    def process_result_value(self, value, dialect):
        if value is not None:
            return encryption_service.decrypt_sensitive_data(value)
        return value

# Usage in models
class User(BaseModel):
    email = Column(EncryptedColumn(255), nullable=False)
    phone = Column(EncryptedColumn(20))
    ssn = Column(EncryptedColumn(11))  # For tax reporting
```

### 4.3 Compliance Framework

**SOX, GDPR, and PCI DSS Compliance:**

```python
class ComplianceService:
    def __init__(self):
        self.audit_logger = AuditLogger()
        self.data_retention = DataRetentionService()
    
    async def log_financial_transaction(self, 
                                       user_id: str, 
                                       action: str, 
                                       expense_id: str, 
                                       changes: dict):
        """SOX-compliant audit logging"""
        audit_entry = AuditEntry(
            user_id=user_id,
            action=action,
            resource_type='expense',
            resource_id=expense_id,
            changes=changes,
            ip_address=get_client_ip(),
            user_agent=get_user_agent(),
            timestamp=datetime.utcnow(),
            compliance_flags=['SOX']
        )
        
        await self.audit_logger.log(audit_entry)
    
    async def handle_gdpr_request(self, user_id: str, request_type: str):
        """GDPR data subject request handling"""
        if request_type == 'export':
            return await self._export_user_data(user_id)
        elif request_type == 'delete':
            return await self._anonymize_user_data(user_id)
        elif request_type == 'rectification':
            return await self._get_rectification_form(user_id)
    
    async def _anonymize_user_data(self, user_id: str):
        """Anonymize user data while preserving financial records"""
        async with database.transaction():
            # Anonymize PII
            await database.execute("""
                UPDATE users 
                SET email = 'anonymized@' || id::text,
                    first_name = 'Anonymized',
                    last_name = 'User',
                    phone = NULL,
                    updated_at = NOW()
                WHERE id = :user_id
            """, {'user_id': user_id})
            
            # Preserve financial data for SOX compliance
            await database.execute("""
                INSERT INTO anonymization_log (user_id, anonymized_at, reason)
                VALUES (:user_id, NOW(), 'GDPR deletion request')
            """, {'user_id': user_id})
```

---

## 5. API Design

### 5.1 RESTful API Specification

**OpenAPI 3.0 Schema:**

```yaml
openapi: 3.0.3
info:
  title: ExpenseFlow API
  version: 1.0.0
  description: Comprehensive expense management API
  
servers:
  - url: https://api.expenseflow.com/v1
    description: Production server
  - url: https://staging-api.expenseflow.com/v1
    description: Staging server

security:
  - BearerAuth: []
  - ApiKeyAuth: []

paths:
  /expenses:
    get:
      summary: List expenses
      parameters:
        - name: status
          in: query
          schema:
            type: string
            enum: [draft, submitted, approved, rejected, paid]
        - name: category_id
          in: query
          schema:
            type: string
            format: uuid
        - name: date_from
          in: query
          schema:
            type: string
            format: date
        - name: date_to
          in: query
          schema:
            type: string
            format: date
        - name: page
          in: query
          schema:
            type: integer
            minimum: 1
            default: 1
        - name: limit
          in: query
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 20
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/Expense'
                  pagination:
                    $ref: '#/components/schemas/Pagination'
                  meta:
                    type: object
                    properties:
                      total_amount:
                        type: number
                        format: decimal
                      currency:
                        type: string
    
    post:
      summary: Create expense
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ExpenseCreate'
      responses:
        '201':
          description: Expense created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Expense'
        '400':
          description: Validation error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ValidationError'

  /expenses/{expense_id}/receipts:
    post:
      summary: Upload receipt
      parameters:
        - name: expense_id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      requestBody:
        required: true
        content:
          multipart/form-data:
            schema:
              type: object
              properties:
                file:
                  type: string
                  format: binary
                auto_extract:
                  type: boolean
                  default: true
      responses:
        '201':
          description: Receipt uploaded
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Receipt'

components:
  schemas:
    Expense:
      type: object
      properties:
        id:
          type: string
          format: uuid
        title:
          type: string
          maxLength: 255
        description:
          type: string
        amount:
          type: number
          format: decimal
          minimum: 0.01
        currency:
          type: string
          pattern: '^[A-Z]{3}$'
        category:
          $ref: '#/components/schemas/ExpenseCategory'
        date_incurred:
          type: string
          format: date
        status:
          type: string
          enum: [draft, submitted, approved, rejected, paid]
        receipts:
          type: array
          items:
            $ref: '#/components/schemas/Receipt'
        created_at:
          type: string
          format: date-time
        updated_at:
          type: string
          format: date-time
    
    Receipt:
      type: object
      properties:
        id:
          type: string
          format: uuid
        file_name:
          type: string
        file_url:
          type: string
          format: uri
        file_size:
          type: integer
        mime_type:
          type: string
        ocr_data:
          type: object
          properties:
            extracted_amount:
              type: number
              format: decimal
            extracted_date:
              type: string
              format: date
            extracted_vendor:
              type: string
            confidence:
              type: number
              format: float
              minimum: 0
              maximum: 1
        created_at:
          type: string
          format: date-time

  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key
```

### 5.2 GraphQL Schema (Optional)

**For Complex Analytics Queries:**

```graphql
type Query {
  expenses(
    filters: ExpenseFilters
    pagination: PaginationInput
    sorting: SortingInput
  ): ExpenseConnection!
  
  expenseAnalytics(
    dateRange: DateRangeInput!
    groupBy: [AnalyticsGroupBy!]!
    filters: ExpenseFilters
  ): ExpenseAnalytics!
  
  approvalQueue(
    status: ApprovalStatus = PENDING
    priority: Priority
  ): [ExpenseApproval!]!
}

type Mutation {
  createExpense(input: CreateExpenseInput!): ExpensePayload!
  updateExpense(id: ID!, input: UpdateExpenseInput!): ExpensePayload!
  submitExpense(id: ID!): ExpensePayload!
  approveExpense(id: ID!, comment: String): ExpensePayload!
  rejectExpense(id: ID!, comment: String!): ExpensePayload!
}

type Subscription {
  expenseUpdated(userId: ID!): ExpenseUpdate!
  approvalQueueUpdated(approverId: ID!): ApprovalQueueUpdate!
}

type Expense {
  id: ID!
  title: String!
  description: String
  amount: Decimal!
  currency: Currency!
  category: ExpenseCategory!
  dateIncurred: Date!
  status: ExpenseStatus!
  user: User!
  receipts: [Receipt!]!
  approvals: [ExpenseApproval!]!
  createdAt: DateTime!
  updatedAt: DateTime!
}

type ExpenseAnalytics {
  totalAmount: Decimal!
  expenseCount: Int!
  averageAmount: Decimal!
  categoryBreakdown: [CategoryAmount!]!
  trendData: [TrendDataPoint!]!
  comparisonToPrevious: ComparisonData!
}
```

---

## 6. Integration Architecture

### 6.1 Accounting System Integration

**Generic Integration Framework:**

```python
from abc import ABC, abstractmethod
from typing import Dict, List, Any

class AccountingSystemAdapter(ABC):
    @abstractmethod
    async def authenticate(self, credentials: Dict[str, Any]) -> bool:
        pass
    
    @abstractmethod
    async def create_expense_entry(self, expense: Expense) -> str:
        pass
    
    @abstractmethod
    async def get_chart_of_accounts(self) -> List[GLAccount]:
        pass
    
    @abstractmethod
    async def sync_vendors(self) -> List[Vendor]:
        pass

class QuickBooksAdapter(AccountingSystemAdapter):
    def __init__(self, oauth_credentials: Dict[str, str]):
        self.client = QuickBooksClient(oauth_credentials)
    
    async def create_expense_entry(self, expense: Expense) -> str:
        qb_expense = {
            "Account": {"value": expense.gl_account_code},
            "Amount": float(expense.amount),
            "Description": expense.description,
            "TxnDate": expense.date_incurred.isoformat(),
            "PaymentType": "Cash",
            "EntityRef": {
                "value": await self._get_or_create_vendor(expense.vendor_name)
            }
        }
        
        response = await self.client.create("Purchase", qb_expense)
        return response["Purchase"]["Id"]
    
    async def _get_or_create_vendor(self, vendor_name: str) -> str:
        # Search for existing vendor
        vendors = await self.client.query(
            f"SELECT * FROM Vendor WHERE Name = '{vendor_name}'"
        )
        
        if vendors:
            return vendors[0]["Id"]
        
        # Create new vendor
        vendor_data = {
            "Name": vendor_name,
            "CompanyName": vendor_name
        }
        response = await self.client.create("Vendor", vendor_data)
        return response["Vendor"]["Id"]

class XeroAdapter(AccountingSystemAdapter):
    def __init__(self, oauth_credentials: Dict[str, str]):
        self.client = XeroClient(oauth_credentials)
    
    async def create_expense_entry(self, expense: Expense) -> str:
        xero_expense = {
            "Type": "SPEND",
            "Contact": {
                "Name": expense.user.full_name
            },
            "Date": expense.date_incurred.isoformat(),
            "LineItems": [
                {
                    "Description": expense.description,
                    "Quantity": 1.0,
                    "UnitAmount": float(expense.amount),
                    "AccountCode": expense.gl_account_code,
                    "TaxType": "NONE"
                }
            ],
            "Status": "AUTHORISED"
        }
        
        response = await self.client.create_bank_transaction(xero_expense)
        return response["BankTransactions"][0]["BankTransactionID"]

# Integration service
class AccountingIntegrationService:
    def __init__(self):
        self.adapters = {}
    
    def register_adapter(self, system_type: str, adapter: AccountingSystemAdapter):
        self.adapters[system_type] = adapter
    
    async def sync_expense(self, expense: Expense, system_type: str) -> str:
        adapter = self.adapters.get(system_type)
        if not adapter:
            raise IntegrationError(f"No adapter found for {system_type}")
        
        try:
            external_id = await adapter.create_expense_entry(expense)
            
            # Store integration record
            integration_record = IntegrationRecord(
                expense_id=expense.id,
                system_type=system_type,
                external_id=external_id,
                sync_status="success",
                synced_at=datetime.utcnow()
            )
            await self.save_integration_record(integration_record)
            
            return external_id
            
        except Exception as e:
            # Log error and store failed sync record
            await self.log_integration_error(expense.id, system_type, str(e))
            raise
```

### 6.2 Payment System Integration

**Multi-Provider Payment Processing:**

```python
class PaymentProcessor:
    def __init__(self):
        self.providers = {
            'ach': ACHPaymentProvider(),
            'wire': WireTransferProvider(),
            'paypal': PayPalProvider(),
            'check': CheckPaymentProvider()
        }
    
    async def process_reimbursement(self, 
                                   expense: Expense, 
                                   payment_method: str) -> PaymentResult:
        provider = self.providers.get(payment_method)
        if not provider:
            raise PaymentError(f"Unsupported payment method: {payment_method}")
        
        # Validate payment eligibility
        await self._validate_payment_eligibility(expense)
        
        # Process payment
        payment_request = PaymentRequest(
            amount=expense.amount,
            currency=expense.currency,
            recipient=expense.user.payment_info,
            reference=f"EXP-{expense.id}",
            description=f"Expense reimbursement: {expense.title}"
        )
        
        try:
            result = await provider.process_payment(payment_request)
            
            # Update expense status
            expense.status = ExpenseStatus.PAID
            expense.payment_date = datetime.utcnow()
            expense.payment_reference = result.transaction_id
            
            await self._save_expense(expense)
            
            # Send payment notification
            await self._notify_payment_processed(expense, result)
            
            return result
            
        except PaymentProviderError as e:
            await self._handle_payment_failure(expense, e)
            raise

class ACHPaymentProvider(PaymentProviderBase):
    async def process_payment(self, request: PaymentRequest) -> PaymentResult:
        # Validate bank account information
        if not self._validate_bank_account(request.recipient.bank_account):
            raise PaymentError("Invalid bank account information")
        
        # Create ACH transfer
        ach_request = {
            "amount": int(request.amount * 100),  # Convert to cents
            "currency": request.currency.lower(),
            "destination": request.recipient.bank_account.account_number,
            "routing_number": request.recipient.bank_account.routing_number,
            "description": request.description,
            "reference": request.reference
        }
        
        response = await self.ach_client.create_transfer(ach_request)
        
        return PaymentResult(
            transaction_id=response["id"],
            status="pending",
            estimated_arrival=datetime.utcnow() + timedelta(days=1),
            fees=response.get("fees", 0)
        )
```

---

## 7. Scalability & Performance

### 7.1 Auto-Scaling Architecture

**Kubernetes Deployment:**

```yaml
# expense-service-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: expense-service
  labels:
    app: expense-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: expense-service
  template:
    metadata:
      labels:
        app: expense-service
    spec:
      containers:
      - name: expense-service
        image: expenseflow/expense-service:1.0.0
        ports:
        - containerPort: 8000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: url
        - name: REDIS_URL
          valueFrom:
            secretKeyRef:
              name: redis-secret
              key: url
        resources:
          requests:
            cpu: "200m"
            memory: "256Mi"
          limits:
            cpu: "500m"
            memory: "512Mi"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 5

---
apiVersion: v1
kind: Service
metadata:
  name: expense-service
spec:
  selector:
    app: expense-service
  ports:
  - port: 80
    targetPort: 8000
  type: ClusterIP

---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: expense-service-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: expense-service
  minReplicas: 3
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 10
        periodSeconds: 60
```

### 7.2 Database Performance Optimization

**Query Optimization and Partitioning:**

```sql
-- Partition expenses table by date for better performance
CREATE TABLE expenses_partitioned (
    LIKE expenses INCLUDING ALL
) PARTITION BY RANGE (date_incurred);

-- Create monthly partitions
CREATE TABLE expenses_2025_01 PARTITION OF expenses_partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');
CREATE TABLE expenses_2025_02 PARTITION OF expenses_partitioned
    FOR VALUES FROM ('2025-02-01') TO ('2025-03-01');
-- ... continue for all months

-- Materialized view for analytics
CREATE MATERIALIZED VIEW expense_analytics AS
SELECT 
    DATE_TRUNC('month', date_incurred) as month,
    category_id,
    department_id,
    COUNT(*) as expense_count,
    SUM(amount) as total_amount,
    AVG(amount) as avg_amount,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY amount) as median_amount
FROM expenses e
JOIN users u ON e.user_id = u.id
WHERE e.status IN ('approved', 'paid')
GROUP BY 1, 2, 3;

-- Refresh materialized view
CREATE INDEX idx_expense_analytics_month_category ON expense_analytics(month, category_id);
```

**Connection Pooling Configuration:**

```python
from sqlalchemy.pool import QueuePool

# Database connection pool configuration
DATABASE_CONFIG = {
    "url": DATABASE_URL,
    "poolclass": QueuePool,
    "pool_size": 20,           # Number of persistent connections
    "max_overflow": 30,        # Additional connections beyond pool_size
    "pool_timeout": 30,        # Timeout for getting connection from pool
    "pool_recycle": 3600,      # Recycle connections after 1 hour
    "pool_pre_ping": True,     # Validate connections before use
}

# Read replica configuration for analytics
READ_REPLICA_CONFIG = {
    "url": READ_REPLICA_URL,
    "poolclass": QueuePool,
    "pool_size": 10,
    "max_overflow": 20,
    "pool_timeout": 30,
    "pool_recycle": 3600,
    "pool_pre_ping": True,
}

class DatabaseService:
    def __init__(self):
        self.write_engine = create_engine(**DATABASE_CONFIG)
        self.read_engine = create_engine(**READ_REPLICA_CONFIG)
    
    def get_write_session(self):
        return sessionmaker(bind=self.write_engine)()
    
    def get_read_session(self):
        return sessionmaker(bind=self.read_engine)()
```

### 7.3 CDN and Caching Strategy

**Multi-Layer Caching Architecture:**

```python
class CachingService:
    def __init__(self):
        self.redis_client = redis.Redis(decode_responses=True)
        self.memcached_client = memcache.Client(['localhost:11211'])
        self.cdn_client = CloudFrontClient()
    
    async def get_user_expenses(self, user_id: str, page: int = 1) -> List[Expense]:
        # L1 Cache: Application memory (very short TTL)
        cache_key = f"expenses:{user_id}:page:{page}"
        
        # L2 Cache: Redis (medium TTL)
        cached_data = await self.redis_client.get(cache_key)
        if cached_data:
            return json.loads(cached_data)
        
        # L3 Cache: Database query result cache
        db_cache_key = f"db_query:{hash(f'expenses_user_{user_id}_page_{page}')}"
        db_result = await self.memcached_client.get(db_cache_key)
        
        if db_result:
            # Store in Redis for faster access
            await self.redis_client.setex(cache_key, 300, json.dumps(db_result, default=str))
            return db_result
        
        # Fetch from database
        expenses = await self._fetch_from_database(user_id, page)
        
        # Update all cache layers
        await self.memcached_client.set(db_cache_key, expenses, time=600)
        await self.redis_client.setex(cache_key, 300, json.dumps(expenses, default=str))
        
        return expenses
    
    async def invalidate_user_cache(self, user_id: str):
        """Invalidate all cache layers for a user"""
        # Invalidate Redis cache
        pattern = f"expenses:{user_id}:*"
        keys = await self.redis_client.keys(pattern)
        if keys:
            await self.redis_client.delete(*keys)
        
        # Invalidate memcached (pattern-based deletion not supported)
        # Use cache tagging or maintain key lists
        
        # Invalidate CDN cache for user-specific assets
        await self.cdn_client.create_invalidation(
            paths=[f"/api/users/{user_id}/expenses/*"]
        )
```

---

## 8. Monitoring & Observability

### 8.1 Application Performance Monitoring

**Comprehensive Monitoring Stack:**

```python
import structlog
from opentelemetry import trace, metrics
from opentelemetry.exporter.jaeger.thrift import JaegerExporter
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.sqlalchemy import SQLAlchemyInstrumentor

# Structured logging configuration
structlog.configure(
    processors=[
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.stdlib.PositionalArgumentsFormatter(),
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.UnicodeDecoder(),
        structlog.processors.JSONRenderer()
    ],
    context_class=dict,
    logger_factory=structlog.stdlib.LoggerFactory(),
    wrapper_class=structlog.stdlib.BoundLogger,
    cache_logger_on_first_use=True,
)

# Tracing setup
tracer = trace.get_tracer(__name__)
meter = metrics.get_meter(__name__)

# Custom metrics
expense_creation_counter = meter.create_counter(
    name="expenses_created_total",
    description="Total number of expenses created"
)

expense_approval_histogram = meter.create_histogram(
    name="expense_approval_duration_seconds",
    description="Time taken to approve expenses"
)

class MonitoringService:
    def __init__(self):
        self.logger = structlog.get_logger()
    
    async def log_expense_creation(self, expense: Expense, user: User):
        with tracer.start_as_current_span("expense_creation") as span:
            span.set_attributes({
                "expense.id": str(expense.id),
                "expense.amount": float(expense.amount),
                "expense.category": expense.category.name,
                "user.id": str(user.id),
                "user.department": user.department.name
            })
            
            self.logger.info(
                "Expense created",
                expense_id=str(expense.id),
                user_id=str(user.id),
                amount=float(expense.amount),
                category=expense.category.name,
                department=user.department.name
            )
            
            # Update metrics
            expense_creation_counter.add(1, {
                "category": expense.category.name,
                "department": user.department.name
            })
    
    async def log_approval_workflow(self, approval: Approval, duration_seconds: float):
        with tracer.start_as_current_span("expense_approval") as span:
            span.set_attributes({
                "approval.id": str(approval.id),
                "approval.status": approval.status.value,
                "expense.amount": float(approval.expense.amount),
                "duration_seconds": duration_seconds
            })
            
            self.logger.info(
                "Expense approval completed",
                approval_id=str(approval.id),
                expense_id=str(approval.expense_id),
                status=approval.status.value,
                duration_seconds=duration_seconds
            )
            
            # Update metrics
            expense_approval_histogram.record(duration_seconds, {
                "status": approval.status.value,
                "amount_range": self._get_amount_range(approval.expense.amount)
            })
```

### 8.2 Health Checks and Circuit Breakers

**Service Health Monitoring:**

```python
from circuit_breaker import CircuitBreaker
from typing import Dict, Any

class HealthCheckService:
    def __init__(self):
        self.checks = {
            'database': self._check_database,
            'redis': self._check_redis,
            'ocr_service': self._check_ocr_service,
            'file_storage': self._check_file_storage,
            'notification_service': self._check_notification_service
        }
        
        # Circuit breakers for external services
        self.ocr_circuit_breaker = CircuitBreaker(
            failure_threshold=5,
            recovery_timeout=30,
            expected_exception=OCRServiceError
        )
    
    async def health_check(self) -> Dict[str, Any]:
        """Comprehensive health check"""
        results = {}
        overall_status = "healthy"
        
        for service_name, check_function in self.checks.items():
            try:
                start_time = time.time()
                result = await check_function()
                duration = time.time() - start_time
                
                results[service_name] = {
                    "status": "healthy" if result else "unhealthy",
                    "response_time": duration,
                    "timestamp": datetime.utcnow().isoformat()
                }
                
                if not result:
                    overall_status = "degraded"
                    
            except Exception as e:
                results[service_name] = {
                    "status": "unhealthy",
                    "error": str(e),
                    "timestamp": datetime.utcnow().isoformat()
                }
                overall_status = "unhealthy"
        
        return {
            "status": overall_status,
            "services": results,
            "timestamp": datetime.utcnow().isoformat()
        }
    
    async def _check_database(self) -> bool:
        try:
            async with database.get_session() as session:
                result = await session.execute("SELECT 1")
                return result.scalar() == 1
        except Exception:
            return False
    
    @ocr_circuit_breaker
    async def _check_ocr_service(self) -> bool:
        try:
            # Simple health check for OCR service
            response = await ocr_client.health_check()
            return response.status_code == 200
        except Exception:
            return False

# Circuit breaker decorator for OCR service calls
class OCRService:
    def __init__(self):
        self.circuit_breaker = CircuitBreaker(
            failure_threshold=3,
            recovery_timeout=60,
            expected_exception=(OCRServiceError, ConnectionError)
        )
    
    @circuit_breaker
    async def extract_receipt_data(self, image_bytes: bytes) -> ReceiptData:
        """OCR extraction with circuit breaker protection"""
        try:
            result = await self._call_ocr_api(image_bytes)
            return self._parse_ocr_result(result)
        except Exception as e:
            # Log the error and potentially fallback to manual entry
            logger.error(f"OCR service failed: {e}")
            raise OCRServiceError(f"Failed to extract receipt data: {e}")
```

---

## 9. Deployment Architecture

### 9.1 Infrastructure as Code

**Terraform Configuration:**

```hcl
# main.tf
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}

# VPC and Networking
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "expenseflow-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  enable_nat_gateway = true
  enable_vpn_gateway = true
  
  tags = {
    Environment = var.environment
    Project     = "ExpenseFlow"
  }
}

# EKS Cluster
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  
  cluster_name    = "expenseflow-cluster"
  cluster_version = "1.27"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  
  node_groups = {
    main = {
      desired_capacity = 3
      max_capacity     = 10
      min_capacity     = 3
      
      instance_types = ["t3.medium"]
      
      k8s_labels = {
        Environment = var.environment
        NodeGroup   = "main"
      }
    }
  }
  
  tags = {
    Environment = var.environment
    Project     = "ExpenseFlow"
  }
}

# RDS PostgreSQL
resource "aws_db_instance" "postgres" {
  identifier = "expenseflow-postgres"
  
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.medium"
  
  allocated_storage     = 100
  max_allocated_storage = 1000
  storage_type          = "gp2"
  storage_encrypted     = true
  
  db_name  = "expenseflow"
  username = var.db_username
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = false
  final_snapshot_identifier = "expenseflow-postgres-final-snapshot"
  
  tags = {
    Environment = var.environment
    Project     = "ExpenseFlow"
  }
}

# Read Replica
resource "aws_db_instance" "postgres_read_replica" {
  identifier = "expenseflow-postgres-read-replica"
  
  replicate_source_db = aws_db_instance.postgres.id
  instance_class      = "db.t3.medium"
  
  auto_minor_version_upgrade = false
  
  tags = {
    Environment = var.environment
    Project     = "ExpenseFlow"
    Role        = "read-replica"
  }
}

# ElastiCache Redis
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id         = "expenseflow-redis"
  description                  = "Redis cluster for ExpenseFlow"
  
  node_type                    = "cache.t3.micro"
  port                         = 6379
  parameter_group_name         = "default.redis7"
  
  num_cache_clusters           = 2
  automatic_failover_enabled   = true
  multi_az_enabled            = true
  
  subnet_group_name = aws_elasticache_subnet_group.redis.name
  security_group_ids = [aws_security_group.redis.id]
  
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  
  tags = {
    Environment = var.environment
    Project     = "ExpenseFlow"
  }
}

# S3 Bucket for file storage
resource "aws_s3_bucket" "file_storage" {
  bucket = "expenseflow-files-${var.environment}"
  
  tags = {
    Environment = var.environment
    Project     = "ExpenseFlow"
  }
}

resource "aws_s3_bucket_encryption_configuration" "file_storage" {
  bucket = aws_s3_bucket.file_storage.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "file_storage" {
  bucket = aws_s3_bucket.file_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}
```

### 9.2 CI/CD Pipeline

**GitHub Actions Workflow:**

```yaml
# .github/workflows/deploy.yml
name: Deploy ExpenseFlow

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: expenseflow_test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
      
      redis:
        image: redis:7
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.11'
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
        pip install -r requirements-dev.txt
    
    - name: Run tests
      env:
        TEST_DATABASE_URL: postgresql://postgres:postgres@localhost/expenseflow_test
        TEST_REDIS_URL: redis://localhost:6379
      run: |
        pytest --cov=. --cov-report=xml --cov-report=html
    
    - name: Upload coverage reports
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.xml
    
    - name: Run security checks
      run: |
        bandit -r src/
        safety check
  
  build:
    needs: test
    runs-on: ubuntu-latest
    
    outputs:
      image: ${{ steps.image.outputs.image }}
      digest: ${{ steps.build.outputs.digest }}
    
    steps:
    - name: Checkout
      uses: actions/checkout@v3
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2
    
    - name: Log in to Container Registry
      uses: docker/login-action@v2
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v4
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
        tags: |
          type=ref,event=branch
          type=ref,event=pr
          type=sha,prefix={{branch}}-
    
    - name: Build and push
      id: build
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max
    
    - name: Output image
      id: image
      run: |
        echo "image=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}@${{ steps.build.outputs.digest }}" >> $GITHUB_OUTPUT
  
  deploy-staging:
    if: github.ref == 'refs/heads/develop'
    needs: build
    runs-on: ubuntu-latest
    environment: staging
    
    steps:
    - name: Checkout
      uses: actions/checkout@v3
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-west-2
    
    - name: Update kubeconfig
      run: aws eks update-kubeconfig --name expenseflow-staging-cluster
    
    - name: Deploy to staging
      run: |
        helm upgrade --install expenseflow-staging ./helm/expenseflow \
          --namespace staging \
          --create-namespace \
          --set image.repository=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }} \
          --set image.digest=${{ needs.build.outputs.digest }} \
          --set environment=staging \
          --values helm/values-staging.yaml
    
    - name: Run smoke tests
      run: |
        kubectl wait --for=condition=ready pod -l app=expenseflow --timeout=300s -n staging
        pytest tests/smoke/
  
  deploy-production:
    if: github.ref == 'refs/heads/main'
    needs: build
    runs-on: ubuntu-latest
    environment: production
    
    steps:
    - name: Checkout
      uses: actions/checkout@v3
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-west-2
    
    - name: Update kubeconfig
      run: aws eks update-kubeconfig --name expenseflow-production-cluster
    
    - name: Deploy to production with blue-green
      run: |
        helm upgrade --install expenseflow-production ./helm/expenseflow \
          --namespace production \
          --create-namespace \
          --set image.repository=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }} \
          --set image.digest=${{ needs.build.outputs.digest }} \
          --set environment=production \
          --values helm/values-production.yaml \
          --wait \
          --timeout=10m
    
    - name: Run production health checks
      run: |
        kubectl wait --for=condition=ready pod -l app=expenseflow --timeout=600s -n production
        pytest tests/integration/ --env=production
```

---

## 10. Risk Mitigation & Disaster Recovery

### 10.1 Business Continuity Plan

**Multi-Region Disaster Recovery:**

```python
class DisasterRecoveryService:
    def __init__(self):
        self.primary_region = "us-west-2"
        self.dr_region = "us-east-1"
        self.rto_target = timedelta(hours=4)  # Recovery Time Objective
        self.rpo_target = timedelta(hours=1)  # Recovery Point Objective
    
    async def initiate_failover(self, reason: str, initiated_by: str):
        """Initiate failover to disaster recovery region"""
        failover_id = str(uuid.uuid4())
        
        # Log the failover initiation
        await self._log_disaster_event(
            event_type="failover_initiated",
            failover_id=failover_id,
            reason=reason,
            initiated_by=initiated_by
        )
        
        try:
            # 1. Stop write operations to primary region
            await self._enable_read_only_mode()
            
            # 2. Promote read replica in DR region
            await self._promote_read_replica()
            
            # 3. Update DNS to point to DR region
            await self._update_dns_routing()
            
            # 4. Start services in DR region
            await self._start_dr_services()
            
            # 5. Verify system health in DR region
            health_status = await self._verify_dr_health()
            
            if health_status.is_healthy:
                await self._log_disaster_event(
                    event_type="failover_completed",
                    failover_id=failover_id,
                    duration=datetime.utcnow() - failover_start_time
                )
                return FailoverResult(success=True, failover_id=failover_id)
            else:
                await self._rollback_failover(failover_id)
                return FailoverResult(success=False, reason="Health check failed")
                
        except Exception as e:
            await self._handle_failover_error(failover_id, e)
            raise DisasterRecoveryError(f"Failover failed: {e}")
    
    async def _promote_read_replica(self):
        """Promote read replica to primary in DR region"""
        # AWS RDS promote read replica
        rds_client = boto3.client('rds', region_name=self.dr_region)
        
        response = rds_client.promote_read_replica(
            DBInstanceIdentifier='expenseflow-postgres-dr'
        )
        
        # Wait for promotion to complete
        waiter = rds_client.get_waiter('db_instance_available')
        waiter.wait(
            DBInstanceIdentifier='expenseflow-postgres-dr',
            WaiterConfig={'Delay': 30, 'MaxAttempts': 120}
        )
    
    async def _update_dns_routing(self):
        """Update Route 53 to point to DR region"""
        route53 = boto3.client('route53')
        
        # Update A record to point to DR load balancer
        response = route53.change_resource_record_sets(
            HostedZoneId='Z123456789',
            ChangeBatch={
                'Changes': [
                    {
                        'Action': 'UPSERT',
                        'ResourceRecordSet': {
                            'Name': 'api.expenseflow.com',
                            'Type': 'A',
                            'AliasTarget': {
                                'DNSName': 'dr-alb.us-east-1.elb.amazonaws.com',
                                'EvaluateTargetHealth': False,
                                'HostedZoneId': 'Z35SXDOTRQ7X7K'
                            }
                        }
                    }
                ]
            }
        )
```

### 10.2 Data Backup and Recovery

**Automated Backup Strategy:**

```python
class BackupService:
    def __init__(self):
        self.s3_client = boto3.client('s3')
        self.rds_client = boto3.client('rds')
        self.backup_bucket = "expenseflow-backups"
    
    async def perform_full_backup(self):
        """Perform comprehensive system backup"""
        backup_id = f"backup_{datetime.utcnow().strftime('%Y%m%d_%H%M%S')}"
        
        try:
            # 1. Database backup
            db_backup = await self._backup_database(backup_id)
            
            # 2. File storage backup
            files_backup = await self._backup_file_storage(backup_id)
            
            # 3. Configuration backup
            config_backup = await self._backup_configurations(backup_id)
            
            # 4. Create backup manifest
            manifest = BackupManifest(
                backup_id=backup_id,
                timestamp=datetime.utcnow(),
                components={
                    'database': db_backup,
                    'files': files_backup,
                    'config': config_backup
                },
                size_bytes=db_backup.size + files_backup.size + config_backup.size
            )
            
            await self._store_backup_manifest(manifest)
            
            # 5. Verify backup integrity
            verification_result = await self._verify_backup_integrity(backup_id)
            
            if not verification_result.is_valid:
                raise BackupError(f"Backup verification failed: {verification_result.errors}")
            
            return BackupResult(
                backup_id=backup_id,
                success=True,
                manifest=manifest
            )
            
        except Exception as e:
            await self._cleanup_failed_backup(backup_id)
            raise BackupError(f"Backup failed: {e}")
    
    async def _backup_database(self, backup_id: str) -> BackupComponent:
        """Create RDS snapshot"""
        snapshot_id = f"expenseflow-snapshot-{backup_id}"
        
        response = self.rds_client.create_db_snapshot(
            DBSnapshotIdentifier=snapshot_id,
            DBInstanceIdentifier='expenseflow-postgres'
        )
        
        # Wait for snapshot completion
        waiter = self.rds_client.get_waiter('db_snapshot_completed')
        waiter.wait(
            DBSnapshotIdentifier=snapshot_id,
            WaiterConfig={'Delay': 30, 'MaxAttempts': 120}
        )
        
        # Get snapshot details
        snapshots = self.rds_client.describe_db_snapshots(
            DBSnapshotIdentifier=snapshot_id
        )
        snapshot = snapshots['DBSnapshots'][0]
        
        return BackupComponent(
            type='database',
            location=f"rds://snapshot/{snapshot_id}",
            size=snapshot['AllocatedStorage'] * 1024 * 1024 * 1024,  # Convert GB to bytes
            checksum=snapshot['DBSnapshotArn']
        )
    
    async def restore_from_backup(self, backup_id: str, restore_point: datetime = None):
        """Restore system from backup"""
        restore_id = f"restore_{datetime.utcnow().strftime('%Y%m%d_%H%M%S')}"
        
        try:
            # 1. Load backup manifest
            manifest = await self._load_backup_manifest(backup_id)
            
            # 2. Verify backup integrity before restore
            verification = await self._verify_backup_integrity(backup_id)
            if not verification.is_valid:
                raise RestoreError(f"Cannot restore from corrupted backup: {verification.errors}")
            
            # 3. Create restore point snapshot
            await self._create_restore_point_snapshot(restore_id)
            
            # 4. Restore database
            await self._restore_database(manifest.components['database'], restore_point)
            
            # 5. Restore file storage
            await self._restore_file_storage(manifest.components['files'])
            
            # 6. Restore configurations
            await self._restore_configurations(manifest.components['config'])
            
            # 7. Verify restore
            health_check = await self._verify_system_health()
            
            if not health_check.is_healthy:
                # Rollback to restore point
                await self._rollback_to_restore_point(restore_id)
                raise RestoreError(f"Restore verification failed: {health_check.errors}")
            
            return RestoreResult(
                restore_id=restore_id,
                success=True,
                backup_id=backup_id,
                restored_at=datetime.utcnow()
            )
            
        except Exception as e:
            await self._handle_restore_failure(restore_id, e)
            raise RestoreError(f"Restore failed: {e}")
```

---

## 11. Conclusion

This comprehensive system architecture for ExpenseFlow addresses all critical technical challenges while maintaining enterprise-grade security, scalability, and compliance requirements. The architecture provides:

### Key Strengths

**1. Scalability & Performance**
- Microservices architecture supporting 10,000+ concurrent users
- Multi-layer caching strategy with Redis and CDN
- Database partitioning and read replicas for optimal performance
- Auto-scaling Kubernetes deployments

**2. Security & Compliance**
- Multi-factor authentication and RBAC
- End-to-end encryption and PCI DSS compliance
- Complete audit trails for SOX compliance
- GDPR-compliant data handling and privacy controls

**3. Reliability & Availability**
- 99.9% uptime through redundant infrastructure
- Circuit breakers and graceful degradation
- Comprehensive disaster recovery with 4-hour RTO
- Automated backup and restore procedures

**4. Developer Experience**
- Clear API design with OpenAPI documentation
- Comprehensive monitoring and observability
- Infrastructure as Code with Terraform
- Automated CI/CD pipelines

### Technology Stack Summary

| Component | Technology | Justification |
|-----------|------------|---------------|
| Mobile App | Flutter | Cross-platform with native performance |
| Web Dashboard | Next.js | SSR for performance, React ecosystem |
| Backend API | FastAPI | High performance, async, OpenAPI support |
| Database | PostgreSQL | ACID compliance, JSON support, performance |
| Caching | Redis | In-memory performance, pub/sub capabilities |
| File Storage | AWS S3 | Scalable, durable, cost-effective |
| Container Orchestration | Kubernetes | Industry standard, auto-scaling |
| CI/CD | GitHub Actions | Integrated with repository, cost-effective |
| Monitoring | Prometheus/Grafana | Open source, comprehensive metrics |
| Message Queue | Redis Streams | Simple, performant, already in stack |

### Implementation Roadmap

**Phase 1 (Months 1-3): Core Foundation**
- Set up infrastructure and CI/CD pipelines
- Implement core API services and database schema
- Basic mobile app with expense submission
- Simple web dashboard for approvals

**Phase 2 (Months 4-6): Advanced Features**
- OCR integration and receipt processing
- Real-time notifications and updates
- Advanced analytics and reporting
- Security hardening and compliance features

**Phase 3 (Months 7-9): Enterprise Features**
- Multi-tenant architecture implementation
- Accounting system integrations
- Advanced approval workflows
- Performance optimization and scaling

**Phase 4 (Months 10-12): Optimization & Enhancement**
- AI-powered insights and analytics
- Mobile offline synchronization
- Advanced compliance features
- Performance monitoring and optimization

This architecture serves as a comprehensive blueprint for building a modern, scalable, and secure expense management platform that can grow with organizational needs while maintaining the highest standards of security and compliance.

---

*Document Version: 1.0*  
*Author: Mike (System Architect)*  
*Date: July 31, 2025*  
*Next Review: August 15, 2025*