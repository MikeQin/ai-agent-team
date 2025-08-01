# Scripts - Helper Tools for Enhanced UX

**Comprehensive helper scripts for crystal-clear AI Agent Team workflow**

---

## 🎯 **Available Scripts**

### **🆕 claude-wrapper.sh - CLI Flags Support**
**New! The requested --design and --develop flags**

**Purpose:** Provides explicit CLI flags for crystal-clear phase selection

**Usage:**
```bash
# DESIGN PHASE - Create planning documents
claude --design --agent [agent-name] "[description]"

# DEVELOP PHASE - Implement actual code  
claude --develop --agent [agent-name] "[description]"
```

**Examples:**
```bash
# Design phase
claude --design --agent po "Create expense management system"
claude --design --agent backend-developer "Plan FastAPI architecture"

# Implementation phase
claude --develop --agent backend-developer "Implement authentication"
claude --develop --agent web-developer "Create dashboard component"
```

**Features:**
- ✅ **Explicit phase flags** - No confusion about what you're doing
- ✅ **Agent validation** - Validates agent names before execution
- ✅ **Design document checking** - Warns if design design-phase missing in develop phase
- ✅ **Enhanced prompts** - Automatically adds `[DESIGN PHASE]` or `[DEVELOP PHASE]` prefix
- ✅ **Comprehensive feedback** - Clear status messages and tips

### **design.sh - Legacy Design Mode Helper**
**Traditional helper script for design workflow**

**Purpose:** Helper for design phase workflow with validation and guidance

**Usage:**
```bash
./scripts/design.sh [agent-name] "[project description]"
```

**Examples:**
```bash
./scripts/design.sh po "Create expense management system"
./scripts/design.sh architect "Design scalable microservices"
```

### **develop.sh - Legacy Develop Mode Helper**
**Traditional helper script for implementation workflow**

**Purpose:** Helper for develop phase workflow with design document validation

**Usage:**
```bash
./scripts/develop.sh [agent-name] "[feature description]"
```

**Examples:**
```bash
./scripts/develop.sh backend-developer "Implement authentication endpoints"
./scripts/develop.sh web-developer "Create dashboard layout"
```

## 🚀 **Recommended Usage**

### **🔥 New CLI Flags Method (Recommended)**
**Crystal clear, no ambiguity:**

```bash
# Design workflow
claude --design --agent po "Project requirements"
claude --design --agent architect "System architecture" 
claude --design --agent backend-developer "API architecture"

# Implementation workflow
claude --develop --agent backend-developer "Authentication system"
claude --develop --agent web-developer "User dashboard"
claude --develop --agent qa-tester "Test automation"
```

### **📋 Traditional Prompt Method (Still Supported)**
**Original approach with prompt keywords:**

```bash
# Design workflow
claude --agent po
# Prompt: [DESIGN PHASE] Gather requirements for project management system

# Implementation workflow  
claude --agent backend-developer
# Prompt: [DEVELOP PHASE] Implement user authentication endpoints
```

### **🛠️ Legacy Helper Scripts**
**Original helper scripts (still functional):**

```bash
# Design phase
./scripts/design.sh po "Project requirements"
./scripts/design.sh architect "System architecture"

# Implementation phase
./scripts/develop.sh backend-developer "Authentication system"
./scripts/develop.sh web-developer "Dashboard component"
```

## 📊 **Method Comparison**

| Method | Clarity | Ease of Use | Validation | Recommended |
|--------|---------|-------------|------------|-------------|
| **CLI Flags** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ **Yes** |
| **Prompt Patterns** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ✅ Supported |
| **Helper Scripts** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ✅ Legacy |

## 🔧 **Script Installation**

### **Make Scripts Executable**
```bash
chmod +x scripts/*.sh
```

### **Add to PATH (Optional)**
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:$(pwd)/scripts"

# Then use directly:
claude-wrapper.sh --design --agent po "Project requirements"
```

### **Create Aliases (Optional)**
```bash
# Add to ~/.bashrc or ~/.zshrc
alias design='claude --design --agent'
alias develop='claude --develop --agent'

# Then use:
design po "Project requirements"
develop backend-developer "Authentication system"
```

## 💡 **Best Practices**

### **Choose Your Method**
- ✅ **Use CLI flags** for maximum clarity and validation
- ✅ **Use prompt patterns** when you prefer traditional approach
- ✅ **Use helper scripts** for additional validation and guidance

### **Workflow Tips**
- ✅ **Start with design** - Always plan before implementing
- ✅ **Use consistent descriptions** - Clear, descriptive prompts
- ✅ **Validate dependencies** - Check for design design-phase before developing
- ✅ **Follow agent sequence** - Respect workflow dependencies

### **Error Prevention**
- ✅ **Validate agent names** - Use scripts to catch typos
- ✅ **Check design design-phase** - Ensure designs exist before implementation
- ✅ **Use explicit modes** - Avoid ambiguity with clear phase selection

## 🚀 **Complete Workflow Examples**

### **E-commerce Platform (CLI Flags Method)**
```bash
# DESIGN PHASE - Crystal clear planning
claude --design --agent po "E-commerce platform with mobile app and admin dashboard"
claude --design --agent architect "Scalable microservices architecture for e-commerce"
claude --design --agent security-engineer "Payment security and compliance framework"
claude --design --agent backend-developer "E-commerce API with product catalog and payments"
claude --design --agent web-developer "Admin dashboard with inventory management"
claude --design --agent mobile-developer "Shopping app with offline cart functionality"

# IMPLEMENTATION PHASE - Crystal clear coding
claude --develop --agent backend-developer "User authentication and registration system"
claude --develop --agent backend-developer "Product catalog API with search and filtering"
claude --develop --agent web-developer "Admin dashboard layout with sidebar navigation"
claude --develop --agent mobile-developer "Shopping cart screen with offline synchronization"
claude --develop --agent qa-tester "Comprehensive API tests for e-commerce endpoints"
```

### **SaaS Application (Mixed Methods)**
```bash
# Design with CLI flags
claude --design --agent po "Project management SaaS with team collaboration"
claude --design --agent architect "Multi-tenant architecture with RBAC"

# Implementation with prompt patterns (if preferred)
claude --agent backend-developer
# Prompt: [DEVELOP PHASE] Implement multi-tenant user authentication system

# Or continue with CLI flags
claude --develop --agent web-developer "Project dashboard with real-time collaboration"
```

## 🐛 **Troubleshooting**

### **Script Permissions**
```bash
# If scripts aren't executable
chmod +x scripts/*.sh
```

### **Path Issues**
```bash
# Run from project root
cd /path/to/ai-agent-team
./scripts/claude-wrapper.sh --design --agent po "Requirements"
```

### **Agent Name Validation**
```bash
# Check available agents
./scripts/claude-wrapper.sh --design --agent invalid-agent "Test"
# Will show list of valid agent names
```

### **Missing Design Documents**
```bash
# If develop phase warns about missing design design-phase
claude --design --agent backend-developer "Create backend architecture first"
# Then proceed with develop phase
claude --develop --agent backend-developer "Implement specific feature"
```

## 📚 **Advanced Usage**

### **Batch Processing with CLI Flags**
```bash
# Design entire project architecture
for agent in po architect security-engineer backend-developer web-developer; do
    claude --design --agent $agent "E-commerce platform component"
done

# Implement core features
for feature in "authentication" "product-catalog" "shopping-cart"; do
    claude --develop --agent backend-developer "Implement $feature system"
done
```

### **Custom Wrapper Scripts**
```bash
# Create project-specific aliases
echo 'alias ecom-design="claude --design --agent"' >> ~/.bashrc
echo 'alias ecom-develop="claude --develop --agent"' >> ~/.bashrc

# Then use:
ecom-design po "E-commerce requirements"
ecom-develop backend-developer "Payment processing API"
```

---

**These helper scripts provide multiple ways to interact with the AI Agent Team, ensuring maximum flexibility while maintaining crystal-clear phase separation and comprehensive validation.**