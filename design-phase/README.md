# Design Phase - Your Project Workspace

**DESIGN PHASE workspace for creating comprehensive project specifications**

---

## 🏗️ **About the Design Phase**

This is your **active workspace** for DESIGN PHASE - where you create comprehensive planning documents and system architecture for your projects. The AI Agent Team uses this folder to systematically build complete design specifications.

## 📁 **Expected Structure**

When you complete a full DESIGN PHASE workflow, this folder will contain:

```
design-phase/
├── README.md                     # This guide
├── PRD.md                        # Product Requirements (Will - PO)
├── DESIGN.md                     # System Architecture (Mike - Architect)
├── MOBILE-UI.md                  # Mobile UI Design (Jennifer)
├── WEB-UI.md                     # Web Dashboard Design (Amy)
├── SECURITY.md                   # Security Architecture (Sarah)
├── MOBILE-DEV.md                 # Mobile Development Plan (Bob)
├── WEB-DEV.md                    # Web Development Plan (Jim)
├── BACKEND-DEV.md                # Backend Development Plan (Luke)
├── QA-TESTING.md                 # Testing Strategy (Vijay)
└── DEVOPS-DEPLOY.md              # Infrastructure Plan (Alex)
```

## 🚀 **How to Use This Workspace**

### **Start Your Design Phase**

1. **Begin with Requirements Gathering**
   ```bash
   claude --agent po
   # Prompt: [DESIGN PHASE] Gather requirements for [your project description]
   ```

2. **Create System Architecture**
   ```bash
   claude --agent architect
   # Prompt: [DESIGN PHASE] Design system architecture for [your project]
   ```

3. **Continue with Specialized Design**
   ```bash
   # Security framework
   claude --agent security-engineer
   # Prompt: [DESIGN PHASE] Create security architecture for [your project]
   
   # UI/UX Design (can run in parallel)
   claude --agent mobile-ui-designer
   # Prompt: [DESIGN PHASE] Design mobile interface for [your project]
   
   claude --agent web-ui-designer
   # Prompt: [DESIGN PHASE] Design web dashboard for [your project]
   ```

4. **Development Planning**
   ```bash
   # Implementation plans (reference earlier designs)
   claude --agent backend-developer
   # Prompt: [DESIGN PHASE] Plan backend architecture for [your project]
   
   claude --agent web-developer
   # Prompt: [DESIGN PHASE] Plan web frontend architecture for [your project]
   
   claude --agent mobile-developer
   # Prompt: [DESIGN PHASE] Plan mobile app architecture for [your project]
   ```

5. **Testing and Infrastructure**
   ```bash
   # Quality assurance strategy
   claude --agent qa-tester
   # Prompt: [DESIGN PHASE] Create testing strategy for [your project]
   
   # Infrastructure and deployment
   claude --agent devops-engineer
   # Prompt: [DESIGN PHASE] Plan infrastructure and deployment for [your project]
   ```

### **Using Helper Scripts**

For easier workflow management:

```bash
# Design phase with helper scripts
./scripts/design.sh po "Create project management SaaS platform"
./scripts/design.sh architect "Design scalable microservices architecture"
./scripts/design.sh backend-developer "Plan FastAPI backend with PostgreSQL"
```

## 📊 **Workflow Dependencies**

**Sequential Dependencies:**
```
Will (PO) → Mike (Architect) → Security Framework
    ↓
UI Design Phase (Jennifer + Amy in parallel)
    ↓
Development Planning (Bob + Jim + Luke reference all above)
    ↓
Testing Strategy (Vijay references all development plans)
    ↓
Infrastructure Planning (Alex references complete system)
```

**Parallel Execution Opportunities:**
- UI designers can work simultaneously after architecture is complete
- Development planners can work in parallel once UI designs are ready
- Some specialized areas (security, testing) can overlap with development planning

## 🔄 **Moving to Implementation**

Once your design phase is complete:

1. **Review All Documents** - Ensure comprehensive coverage
2. **Move to Implementation Workspace** - Use `../implementation/` folder
3. **Begin DEVELOP PHASE** - Reference your design documents
4. **Follow Implementation Plans** - Built by your development planning agents

```bash
# Example transition to implementation
cd ../implementation/

# Implement following your design specifications
claude --agent backend-developer
# Prompt: [DEVELOP PHASE] Implement user authentication system following design-phase/BACKEND-DEV.md
```

## 📚 **Example Reference**

**Want to see what a complete design phase looks like?**

Check out the ExpenseFlow showcase in `examples/expenseflow/design/` to see:
- ✅ How agents build on each other's work
- ✅ Quality standards for design documentation  
- ✅ Complete workflow from requirements to deployment plans
- ✅ Enterprise-grade specifications and architecture

## 💡 **Best Practices**

### **Design Phase Management**
- ✅ **Complete requirements first** - Everything builds on the PRD
- ✅ **Don't skip security** - Security architecture affects all implementations
- ✅ **Validate dependencies** - Each agent references previous outputs
- ✅ **Review before implementing** - Ensure design completeness

### **Quality Standards**
- ✅ **Comprehensive documentation** - Each document should be implementation-ready
- ✅ **Clear specifications** - Developers should know exactly what to build
- ✅ **Security considerations** - Built into design, not added later
- ✅ **Testing strategy** - Quality planned from the beginning

### **Workflow Efficiency**
- ✅ **Use helper scripts** - Clearer phase selection and validation
- ✅ **Parallel execution** - Speed up design phase where possible
- ✅ **Document decisions** - Capture architectural choices and rationale

---

**This workspace transforms your project ideas into comprehensive, implementation-ready specifications using the systematic AI Agent Team approach.**