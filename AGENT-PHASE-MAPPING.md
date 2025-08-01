# AI Agent Team - Agent Phase Mapping

**Clear documentation of which agents work in which development phases**

---

## 🎯 **Two Development Phases**

### **🏗️ Design Phase**
**Purpose:** Create comprehensive planning documents and system architecture  
**Trigger:** `[DESIGN PHASE]` in prompts or design-related keywords  
**Output:** Detailed specifications and implementation roadmaps

### **💻 Implementation Phase**  
**Purpose:** Write actual production code following design specifications  
**Trigger:** `[DEVELOP PHASE]` in prompts or implementation-related keywords  
**Output:** Working code that follows design specifications

---

## 📊 **Agent Phase Matrix**

| Agent | Name | Role | Design Phase | Implementation Phase |
|--------|------|------|-------------|---------------------|
| 🎯 | **Will** | Product Owner | ✅ Requirements & User Stories | ❌ N/A |
| 🏗️ | **Mike** | System Architect | ✅ System Architecture | ❌ N/A |
| 🎨 | **Jennifer** | Mobile UI Designer | ✅ Mobile UI Design | ❌ N/A |
| 🎨 | **Amy** | Web UI Designer | ✅ Web UI Design | ❌ N/A |
| 🔒 | **Sarah** | Security Engineer | ✅ Security Architecture | ✅ Security Validation |
| 📱 | **Bob** | Mobile Developer | ✅ Mobile Dev Planning | ✅ Flutter Implementation |
| 💻 | **Jim** | Web Developer | ✅ Web Dev Planning | ✅ Next.js Implementation |
| ⚙️ | **Luke** | Backend Developer | ✅ Backend Dev Planning | ✅ FastAPI Implementation |
| 🧪 | **Vijay** | QA Tester | ✅ Testing Strategy | ✅ Test Implementation |
| 🚀 | **Alex** | DevOps Engineer | ✅ Infrastructure Planning | ✅ DevOps Implementation |

---

## 🏗️ **Design Phase Agents (Phase 1)**

### **Design-Only Agents**
These agents **ONLY** work in the Design Phase because their expertise is planning and specification:

#### **🎯 Will - Product Owner**
- **Design Phase:** ✅ Requirements gathering, user stories, PRD creation
- **Implementation Phase:** ❌ Not applicable
- **Why Design-Only:** Product ownership is about planning, not coding

#### **🏗️ Mike - System Architect** 
- **Design Phase:** ✅ System architecture, technical design, scalability planning
- **Implementation Phase:** ❌ Not applicable  
- **Why Design-Only:** Architecture is about design decisions, not implementation

#### **🎨 Jennifer - Mobile UI Designer**
- **Design Phase:** ✅ Mobile interface design, wireframes, user experience
- **Implementation Phase:** ❌ Not applicable
- **Why Design-Only:** UI design creates specifications, doesn't write code

#### **🎨 Amy - Web UI Designer**
- **Design Phase:** ✅ Web dashboard design, responsive layouts, UI components
- **Implementation Phase:** ❌ Not applicable
- **Why Design-Only:** UI design creates mockups and specs, doesn't implement

### **Dual-Phase Agents (Planning + Implementation)**
These agents work in **BOTH** Design Phase AND Implementation Phase:

#### **🔒 Sarah - Security Engineer**
- **Design Phase:** ✅ Security architecture, threat modeling, compliance framework
- **Implementation Phase:** ✅ Security validation, penetration testing, code review
- **Why Both:** Security needs both planning and ongoing validation

#### **📱 Bob - Mobile Developer**
- **Design Phase:** ✅ Mobile development planning, Flutter architecture
- **Implementation Phase:** ✅ Flutter/Dart code implementation
- **Why Both:** Needs to plan the mobile architecture AND write the code

#### **💻 Jim - Web Developer**
- **Design Phase:** ✅ Web development planning, Next.js architecture  
- **Implementation Phase:** ✅ React/Next.js code implementation
- **Why Both:** Needs to plan the web architecture AND write the code

#### **⚙️ Luke - Backend Developer**
- **Design Phase:** ✅ Backend development planning, API architecture
- **Implementation Phase:** ✅ FastAPI/Python code implementation  
- **Why Both:** Needs to plan the backend architecture AND write the code

#### **🧪 Vijay - QA Tester**
- **Design Phase:** ✅ Testing strategy, test planning, QA processes
- **Implementation Phase:** ✅ Test automation, test execution, quality validation
- **Why Both:** Needs to plan testing approach AND implement actual tests

#### **🚀 Alex - DevOps Engineer**
- **Design Phase:** ✅ Infrastructure planning, deployment strategy
- **Implementation Phase:** ✅ CI/CD implementation, infrastructure deployment
- **Why Both:** Needs to plan infrastructure AND implement deployment pipelines

---

## 🔄 **Phase Workflow**

### **Design Phase Sequence:**
```
User Input
    ↓
Will (Requirements) → Mike (Architecture)
    ↓
Jennifer (Mobile UI) + Amy (Web UI) + Sarah (Security)
    ↓  
Bob (Mobile Plan) + Jim (Web Plan) + Luke (Backend Plan)
    ↓
Vijay (Testing Strategy) → Alex (Infrastructure Plan)
    ↓
Complete Design Documents
```

### **Implementation Phase Sequence:**
```
Design Documents
    ↓
Sarah (Security Validation) + Luke (Backend Code) 
    ↓
Bob (Mobile Code) + Jim (Web Code)
    ↓  
Vijay (Test Implementation) → Alex (DevOps Implementation)
    ↓
Production-Ready Application
```

---

## 💡 **Key Insights**

### **Why Some Agents Are Design-Only:**
- **Will, Mike, Jennifer, Amy** create specifications that others implement
- Their output is **documentation and designs**, not code
- They provide the **foundation** for implementation agents

### **Why Some Agents Are Dual-Phase:**
- **Sarah, Bob, Jim, Luke, Vijay, Alex** need both planning AND execution expertise
- They **create their own implementation roadmaps** in Design Phase
- They **follow their own plans** in Implementation Phase
- This ensures **consistency** between planning and execution

### **Agent Dependencies:**
- **Implementation agents read Design Phase outputs**
- **Luke reads design-phase/BACKEND-DEV.md** (his own design document)
- **Bob reads design-phase/MOBILE-DEV.md + design-phase/MOBILE-UI.md** (his plan + Jennifer's design)
- **Cross-validation occurs** between related agents

---

## 🎯 **Usage Examples**

### **Design Phase Usage:**
```bash
# Interactive Mode
claude --agent po
[DESIGN PHASE] Create expense management system requirements

# CLI Mode  
claude --design --agent po "Create expense management system"
```

### **Implementation Phase Usage:**
```bash
# Interactive Mode
claude --agent backend-developer
[DEVELOP PHASE] Implement authentication endpoints from design-phase/BACKEND-DEV.md

# CLI Mode
claude --develop --agent backend-developer "Implement authentication endpoints"
```

### **Invalid Usage Examples:**
```bash
# ❌ INVALID - Will doesn't do implementation
claude --develop --agent po "Implement requirements"

# ❌ INVALID - Jennifer doesn't write code  
claude --develop --agent mobile-ui-designer "Implement mobile screens"

# ✅ CORRECT - Bob implements Jennifer's designs
claude --develop --agent mobile-developer "Implement mobile screens from design-phase/MOBILE-UI.md"
```

---

This clear mapping ensures you always know which agents to use for which development phases and prevents confusion about agent capabilities.