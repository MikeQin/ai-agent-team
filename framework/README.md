# AI Agent Team Framework Documentation

**Complete documentation for the AI Agent Team framework**

---

## 🎯 **Usage Modes**

The AI Agent Team supports two distinct usage modes to fit your development workflow:

### **🗣️ Interactive Mode (Direct Claude Conversation)**
- ✅ **Zero setup** - works immediately in any Claude interface
- ✅ **Real-time feedback** - ask questions and get immediate clarification
- ✅ **Perfect for exploration** - refine ideas through natural conversation
- ✅ **Iterative development** - easily modify requirements and designs

### **💻 CLI Mode (Terminal Commands)**
- ✅ **Automation ready** - script entire development workflows
- ✅ **Team collaboration** - consistent execution across team members
- ✅ **CI/CD integration** - incorporate into deployment pipelines
- ✅ **Production workflows** - reliable and repeatable processes

## 📋 **Framework Documentation**

This folder contains all the documentation you need to understand, configure, and extend the AI Agent Team framework.

### **📄 Core Documentation**

- **[CLAUDE.md](CLAUDE.md)** - Complete configuration and customization guide
- **[IMPLEMENTATION.md](IMPLEMENTATION.md)** - Step-by-step implementation guide  
- **[PROMPT-PATTERNS.md](PROMPT-PATTERNS.md)** - Design/develop phase prompt patterns
- **[FRAMEWORK-IMPROVEMENTS.md](FRAMEWORK-IMPROVEMENTS.md)** - Latest improvements and enhancements

## 🎯 **Quick Start Guide**

### **1. Understanding the Framework**
Start with **[CLAUDE.md](CLAUDE.md)** to understand:
- Two-phase architecture (DESIGN PHASE vs DEVELOP PHASE)
- Agent configuration and customization
- Workflow patterns and best practices

### **2. Using the Framework**
Read **[IMPLEMENTATION.md](IMPLEMENTATION.md)** for:
- Complete project implementation workflow
- Design phase execution steps
- Development phase implementation steps

### **3. Advanced Usage**
Explore **[PROMPT-PATTERNS.md](PROMPT-PATTERNS.md)** for:
- Explicit prompt patterns for each phase
- Best practices for agent interaction
- Advanced workflow examples

### **4. Latest Features**
Check **[FRAMEWORK-IMPROVEMENTS.md](FRAMEWORK-IMPROVEMENTS.md)** for:
- Recent enhancements and new features
- Migration guides for updates
- Performance improvements

## 🏗️ **Two-Phase Framework Overview**

### **Phase 1: DESIGN PHASE**
**Purpose:** Create comprehensive planning documents
**Location:** `../design-phase/` folder
**Commands:**
- **CLI Flags (Recommended):** `claude --design --agent [agent] "[project description]"`
- **Helper Scripts:** `./scripts/design.sh [agent] "[project description]"`
- **Traditional:** `claude --agent [agent]` + `[DESIGN PHASE] prompt`

### **Phase 2: DEVELOP PHASE**
**Purpose:** Implement actual working code
**Location:** `../implementation/` folder  
**Commands:**
- **CLI Flags (Recommended):** `claude --develop --agent [agent] "[feature description]"`
- **Helper Scripts:** `./scripts/develop.sh [agent] "[feature description]"`
- **Traditional:** `claude --agent [agent]` + `[DEVELOP PHASE] prompt`

## 🔧 **Framework Architecture**

```
AI Agent Team Framework
├── 10 Specialized Agents        # Each with domain expertise
├── Two-Phase Operation          # Design → Develop workflow
├── Helper Scripts              # Enhanced user experience
├── Auto-Documentation          # Self-generating specifications
└── Quality Assurance          # Built-in validation and testing
```

## 🎯 **Agent Specializations**

| Agent | Name | Design Phase | Develop Phase |
|-------|------|-------------|---------------|
| 🎯 | **Will** | Requirements & user stories | N/A |
| 🏗️ | **Mike** | System architecture | N/A |
| 🎨 | **Jennifer** | Mobile UI design | N/A |
| 🎨 | **Amy** | Web UI design | N/A |
| 🔒 | **Sarah** | Security architecture | Security validation |
| 📱 | **Bob** | Mobile dev planning | Flutter implementation |
| 💻 | **Jim** | Web dev planning | Next.js implementation |
| ⚙️ | **Luke** | Backend dev planning | FastAPI implementation |
| 🧪 | **Vijay** | Testing strategy | Test implementation |
| 🚀 | **Alex** | Infrastructure planning | DevOps implementation |

## 🔄 **Workflow Patterns**

### **Complete Project Workflow:**
```bash
# DESIGN PHASE - Create all planning documents (CLI Flags - Recommended)
claude --design --agent po "Project requirements"
claude --design --agent architect "System architecture"
claude --design --agent security-engineer "Security framework"
claude --design --agent backend-developer "API architecture planning"
claude --design --agent web-developer "Frontend architecture planning"
claude --design --agent mobile-developer "Mobile architecture planning"
claude --design --agent qa-tester "Testing strategy"
claude --design --agent devops-engineer "Infrastructure planning"

# DEVELOP PHASE - Implement features incrementally (CLI Flags - Recommended)
claude --develop --agent backend-developer "Core API endpoints"
claude --develop --agent web-developer "Dashboard components"
claude --develop --agent mobile-developer "Mobile screens"
claude --develop --agent qa-tester "Test automation"
claude --develop --agent devops-engineer "Infrastructure deployment"

# ALTERNATIVE: Traditional Helper Scripts (Still Supported)
# ./scripts/design.sh po "Project requirements"
# ./scripts/develop.sh backend-developer "Core API endpoints"
```

## 📚 **Learning Path**

### **For New Users:**
1. Read **[CLAUDE.md](CLAUDE.md)** - Framework overview and configuration
2. Try the helper scripts with a sample project
3. Review **[PROMPT-PATTERNS.md](PROMPT-PATTERNS.md)** for advanced usage

### **For Developers:**
1. Study **[IMPLEMENTATION.md](IMPLEMENTATION.md)** - Implementation workflows
2. Examine the ExpenseFlow showcase in `../design-phase/`
3. Practice with your own projects in `../implementation/`

### **For Customization:**
1. Understand agent definitions in `../.claude/agents/`
2. Follow customization guides in **[CLAUDE.md](CLAUDE.md)**
3. Review **[FRAMEWORK-IMPROVEMENTS.md](FRAMEWORK-IMPROVEMENTS.md)** for latest patterns

## 🚀 **Support & Resources**

- **GitHub Issues:** Report bugs and request features
- **Documentation:** This framework folder contains everything
- **Examples:** ExpenseFlow showcase demonstrates all capabilities
- **Scripts:** Helper scripts in `../scripts/` for enhanced UX

---

**This framework documentation provides everything you need to master the AI Agent Team system and build amazing software with AI-powered development workflows.**