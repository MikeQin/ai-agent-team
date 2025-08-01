# Examples - AI Agent Team Showcases

**Real-world demonstrations of the AI Agent Team framework**

---

## 📂 **Available Examples**

### 🏢 **ExpenseFlow - Enterprise Expense Management**
**Location:** `examples/expenseflow/`

Complete demonstration of the AI Agent Team two-phase workflow building an enterprise expense management system.

**What's Included:**
- ✅ **Complete DESIGN PHASE output** - 10 comprehensive design documents
- ✅ **Ready implementation workspace** - Platform-specific folders for DEVELOP PHASE
- ✅ **Multi-platform system** - Mobile app, web dashboard, backend API
- ✅ **Enterprise features** - Security, compliance, testing, deployment

**Features Designed:**
- Mobile expense submission with OCR receipt processing
- Web dashboard for approval workflows and analytics
- FastAPI backend with PostgreSQL and background tasks
- AWS infrastructure with Kubernetes deployment

[**→ Explore ExpenseFlow**](expenseflow/README.md)

---

## 🎯 **How to Use Examples**

### **For Learning**
```bash
# Study the complete design workflow
cd examples/expenseflow/design/
ls -la                              # See all design documents
cat PRD.md                          # Read requirements from Will (PO)
cat DESIGN.md                       # Study architecture from Mike
cat BACKEND-DEV.md                  # Learn implementation planning from Luke
```

### **For Reference**
- **Requirements Patterns** - See how Will gathers comprehensive requirements
- **Architecture Decisions** - Study Mike's system design approaches
- **Security Implementation** - Learn from Sarah's security architecture
- **Testing Strategies** - Reference Vijay's comprehensive QA approach

### **For Implementation**
```bash
# Use examples as starting points for your projects
cd examples/expenseflow/implementation/

# RECOMMENDED: CLI Flags Method - Crystal clear implementation
claude --develop --agent backend-developer "Implement authentication following ExpenseFlow backend plan"
claude --develop --agent web-developer "Create dashboard components following ExpenseFlow web design"
claude --develop --agent mobile-developer "Build expense submission screen following ExpenseFlow mobile design"

# ALTERNATIVE: Traditional Prompt Method (Still Supported)
claude --agent backend-developer
# Prompt: [DEVELOP PHASE] Implement authentication following ExpenseFlow backend plan
```

## 🚀 **Creating New Examples**

Want to add your own showcase? Follow this structure:

```
examples/your-project/
├── README.md                     # Project showcase overview
├── design/                       # All DESIGN PHASE outputs
│   ├── PRD.md                    # Requirements (Will)
│   ├── DESIGN.md                 # Architecture (Mike)
│   ├── [AGENT]-[SPECIALTY].md    # Other agent outputs
│   └── ...
└── implementation/               # DEVELOP PHASE workspace
    ├── backend/                  # Backend implementation
    ├── frontend-web/             # Web implementation  
    ├── mobile-app/               # Mobile implementation
    └── infrastructure/           # Infrastructure code
```

**Steps to Create:**
1. **Run complete DESIGN PHASE workflow** for your project
   ```bash
   # RECOMMENDED: CLI Flags Method
   claude --design --agent po "Your project requirements"
   claude --design --agent architect "Your system architecture"
   claude --design --agent backend-developer "Your backend implementation plan"
   # ... continue with other agents
   
   # ALTERNATIVE: Traditional Methods (Still Supported)
   ./scripts/design.sh po "Your project requirements"
   claude --agent po "[DESIGN PHASE] Your project requirements"
   ```
2. **Organize design documents** in `design/` folder
3. **Create implementation workspace** with platform folders
4. **Document the showcase** with comprehensive README
5. **Add to this examples index**

## 📊 **Example Metrics**

### **ExpenseFlow Showcase**
- **Design Documents:** 10 comprehensive files
- **Total Documentation:** 2000+ lines of specifications
- **Platforms Covered:** Mobile (Flutter), Web (Next.js), Backend (FastAPI)
- **Security Coverage:** STRIDE analysis, compliance framework
- **Testing Strategy:** Unit, integration, E2E, performance tests
- **Infrastructure:** AWS, Kubernetes, CI/CD, monitoring

## 💡 **Learning Outcomes**

**After studying these examples, you'll understand:**
- ✅ How AI agents collaborate systematically
- ✅ Quality standards for design documentation
- ✅ Two-phase workflow best practices
- ✅ Enterprise-grade planning approaches
- ✅ Multi-platform development strategies

**You'll be able to:**
- ✅ Plan comprehensive software projects
- ✅ Create high-quality design specifications
- ✅ Implement features following systematic approaches
- ✅ Scale the framework for your specific needs

---

**These examples prove that AI Agent Team can deliver enterprise-grade software planning and implementation guidance that matches or exceeds traditional development team quality.**