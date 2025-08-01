# AI Agent Team Prompt Patterns Guide

**Crystal Clear Commands for Design vs Development**

---

## 🎯 **Two-Mode Operation**

The AI Agent Team now operates with explicit **DESIGN PHASE** and **DEVELOP PHASE** to eliminate confusion and ensure you always know what you're doing.

## 🏗️ **DESIGN PHASE Patterns**

**Purpose:** Create comprehensive planning documents and system architecture

### **🆕 CLI Flags Method (Recommended):**
```bash
claude --design --agent [agent-name] "[description]"
```

### **Traditional Method (Still Supported):**
```bash
claude --agent [agent-name]
# Prompt: [DESIGN PHASE] [description]
```

### **Examples:**

#### **Backend Development Planning:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
claude --design --agent backend-developer "Plan the ExpenseFlow backend architecture with FastAPI, PostgreSQL, and authentication system"

# ALTERNATIVE: Traditional Method (Still Supported)
claude --agent backend-developer
# Prompt: [DESIGN PHASE] Plan the ExpenseFlow backend architecture with FastAPI, PostgreSQL, and authentication system
```

#### **Frontend Development Planning:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
claude --design --agent web-developer "Design the Next.js web application architecture with dashboard, analytics, and real-time features"

# ALTERNATIVE: Traditional Method (Still Supported)
claude --agent web-developer
# Prompt: [DESIGN PHASE] Design the Next.js web application architecture with dashboard, analytics, and real-time features
```

#### **Mobile Development Planning:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
claude --design --agent mobile-developer "Plan the Flutter mobile app architecture with offline-first functionality and camera integration"

# ALTERNATIVE: Traditional Method (Still Supported)
claude --agent mobile-developer
# Prompt: [DESIGN PHASE] Plan the Flutter mobile app architecture with offline-first functionality and camera integration
```

#### **Complete Project Planning:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
# Full design workflow for new projects
claude --design --agent po "Gather comprehensive requirements for [project-name]"
claude --design --agent architect "Design system architecture based on the PRD"
claude --design --agent security-engineer "Create security architecture and compliance framework"
claude --design --agent backend-developer "Plan backend API architecture and database design"
claude --design --agent web-developer "Plan Next.js application architecture and components"
claude --design --agent mobile-developer "Plan Flutter application architecture and state management"
claude --design --agent qa-tester "Create comprehensive testing strategy"
claude --design --agent devops-engineer "Design deployment and infrastructure strategy"

# ALTERNATIVE: Traditional Method (Still Supported)
# claude --agent po
# Prompt: [DESIGN PHASE] Gather comprehensive requirements for [project-name]
# (Continue through all agents...)
```

## 💻 **DEVELOP PHASE Patterns**

**Purpose:** Implement actual working code following design specifications

### **🆕 CLI Flags Method (Recommended):**
```bash
claude --develop --agent [agent-name] "[description]"
```

### **Traditional Method (Still Supported):**
```bash
claude --agent [agent-name]
# Prompt: [DEVELOP PHASE] [description]
```

### **Examples:**

#### **Backend Implementation:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
claude --develop --agent backend-developer "Implement user authentication endpoints with JWT tokens and password hashing"
claude --develop --agent backend-developer "Create the expense CRUD API endpoints with validation and error handling"
claude --develop --agent backend-developer "Build the receipt upload service with OCR processing"

# ALTERNATIVE: Traditional Method (Still Supported)
# claude --agent backend-developer
# Prompt: [DEVELOP PHASE] Implement user authentication endpoints with JWT tokens and password hashing
```

#### **Frontend Implementation:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
claude --develop --agent web-developer "Implement the dashboard layout component with sidebar navigation"
claude --develop --agent web-developer "Create the expense approval workflow with real-time updates"
claude --develop --agent web-developer "Build the analytics dashboard with interactive charts"

# ALTERNATIVE: Traditional Method (Still Supported)
# claude --agent web-developer
# Prompt: [DEVELOP PHASE] Implement the dashboard layout component with sidebar navigation
```

#### **Mobile Implementation:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
claude --develop --agent mobile-developer "Implement the camera service for receipt capture with image optimization"
claude --develop --agent mobile-developer "Create the expense form screen with BLoC state management"
claude --develop --agent mobile-developer "Build the offline synchronization service with conflict resolution"

# ALTERNATIVE: Traditional Method (Still Supported)
# claude --agent mobile-developer
# Prompt: [DEVELOP PHASE] Implement the camera service for receipt capture with image optimization
```

#### **Testing Implementation:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
claude --develop --agent qa-tester "Implement comprehensive API testing for authentication endpoints"
claude --develop --agent qa-tester "Create E2E tests for the expense submission workflow"
claude --develop --agent qa-tester "Build performance testing suite for the mobile application"

# ALTERNATIVE: Traditional Method (Still Supported)
# claude --agent qa-tester
# Prompt: [DEVELOP PHASE] Implement comprehensive API testing for authentication endpoints
```

#### **Infrastructure Implementation:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
claude --develop --agent devops-engineer "Create Docker containers and Kubernetes manifests for production deployment"
claude --develop --agent devops-engineer "Implement CI/CD pipeline with automated testing and security scanning"
claude --develop --agent devops-engineer "Build monitoring and alerting infrastructure with Prometheus and Grafana"

# ALTERNATIVE: Traditional Method (Still Supported)
# claude --agent devops-engineer
# Prompt: [DEVELOP PHASE] Create Docker containers and Kubernetes manifests for production deployment
```

## 🔄 **Mode Detection Examples**

### **Automatic Mode Detection**

**DESIGN PHASE Triggers:**
- `[DESIGN PHASE]` in prompt
- Keywords: "plan", "design", "architecture", "strategy", "framework"
- Phrases: "create a plan for", "design the system", "architect the solution"

**DEVELOP PHASE Triggers:**
- `[DEVELOP PHASE]` in prompt  
- Keywords: "implement", "code", "build", "create", "write"
- Phrases: "implement the feature", "build the component", "write the code"

### **Example Conversations:**

#### **Design Phase Example:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
claude --design --agent backend-developer "Plan a REST API for expense management with user authentication"
# Luke: "I'm in DESIGN PHASE. I'll create a comprehensive backend development plan in design-phase/BACKEND-DEV.md..."

# ALTERNATIVE: Traditional Method (Still Supported)
claude --agent backend-developer
# User: [DESIGN PHASE] Plan a REST API for expense management with user authentication
# Luke: "I'm in DESIGN PHASE. I'll create a comprehensive backend development plan in design-phase/BACKEND-DEV.md..."
```

#### **Implementation Phase Example:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
claude --develop --agent backend-developer "Implement the login endpoint with JWT token generation"
# Luke: "I'm in DEVELOP PHASE. Let me first read design-phase/BACKEND-DEV.md to understand my implementation plan, then I'll write the actual FastAPI code..."

# ALTERNATIVE: Traditional Method (Still Supported)
claude --agent backend-developer
# User: [DEVELOP PHASE] Implement the login endpoint with JWT token generation
# Luke: "I'm in DEVELOP PHASE. Let me first read design-phase/BACKEND-DEV.md to understand my implementation plan, then I'll write the actual FastAPI code..."
```

## 🎯 **Best Practices**

### **Design Phase Best Practices:**
1. **Start with Requirements:** Always begin with the Product Owner (po) agent
2. **Follow Dependencies:** Architect → UI Designers/Security → Developers → QA → DevOps
3. **Be Comprehensive:** Create detailed specifications that guide implementation
4. **Consider All Aspects:** Security, performance, testing, deployment from day one

### **Implementation Phase Best Practices:**
1. **Reference Design Documents:** Agents automatically read their own plans first
2. **Be Specific:** Request specific features rather than entire systems
3. **Iterate Incrementally:** Build features one at a time, testing as you go
4. **Cross-Validate:** Use multiple agents to validate implementations

## 📋 **Quick Reference**

### **Design Mode Commands:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
# Project Planning
claude --design --agent po "Create comprehensive requirements for [project]"

# System Architecture  
claude --design --agent architect "Design scalable system architecture"

# UI/UX Planning
claude --design --agent mobile-ui-designer "Design mobile user experience and interface"

# Development Planning
claude --design --agent backend-developer "Plan backend API architecture and database design"

# ALTERNATIVE: Traditional Method (Still Supported)
# claude --agent po
# Prompt: [DESIGN PHASE] Create comprehensive requirements for [project]
```

### **Develop Mode Commands:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
# Feature Implementation
claude --develop --agent backend-developer "Implement authentication system with JWT"

# Component Building
claude --develop --agent web-developer "Build dashboard component with data visualization"

# Testing Implementation
claude --develop --agent qa-tester "Create comprehensive test suite for API endpoints"

# ALTERNATIVE: Traditional Method (Still Supported)
# claude --agent backend-developer
# Prompt: [DEVELOP PHASE] Implement authentication system with JWT
```

## 🚀 **Advanced Usage**

### **Cross-Agent Validation:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
# After implementing a feature, validate with related agents
claude --develop --agent security-engineer "Review the authentication implementation for security compliance"
claude --develop --agent qa-tester "Create tests for the newly implemented authentication system"

# ALTERNATIVE: Traditional Method (Still Supported)
# claude --agent security-engineer
# Prompt: [DEVELOP PHASE] Review the authentication implementation for security compliance
```

### **Iterative Development:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
# Build features incrementally
claude --develop --agent backend-developer "Implement user registration endpoint"
claude --develop --agent backend-developer "Add email verification to user registration"
claude --develop --agent backend-developer "Implement password reset functionality"

# ALTERNATIVE: Traditional Method (Still Supported)
# claude --agent backend-developer
# Prompt: [DEVELOP PHASE] Implement user registration endpoint
```

### **Integration Testing:**
```bash
# RECOMMENDED: CLI Flags Method (Crystal Clear)
# Test integration between components
claude --develop --agent qa-tester "Create integration tests between frontend and backend authentication"

# ALTERNATIVE: Traditional Method (Still Supported)
# claude --agent qa-tester
# Prompt: [DEVELOP PHASE] Create integration tests between frontend and backend authentication
```

---

## 💡 **Key Benefits of This Pattern**

1. **🎯 Crystal Clear Intent:** No confusion about what you're doing
2. **🔄 Consistent Behavior:** Agents behave predictably based on phase
3. **📚 Automatic Context:** Agents know which documents to reference
4. **✅ Self-Validation:** Agents follow their own design specifications
5. **🚀 Efficient Workflow:** Seamless transition from planning to implementation

---

*This prompt pattern system transforms the AI Agent Team from an ambiguous tool into a crystal-clear development framework where you always know exactly what each command will do.*