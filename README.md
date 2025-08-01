# AI Agent Team - Complete Development Lifecycle Automation

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![GitHub stars](https://img.shields.io/github/stars/MikeQin/ai-agent-team?style=social)
![GitHub forks](https://img.shields.io/github/forks/MikeQin/ai-agent-team?style=social)
![GitHub issues](https://img.shields.io/github/issues/MikeQin/ai-agent-team)
![GitHub last commit](https://img.shields.io/github/last-commit/MikeQin/ai-agent-team)
![AI Agents](https://img.shields.io/badge/AI%20Agents-10-blue)
![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-green)
![Multi-LLM](https://img.shields.io/badge/Multi--LLM-Support-orange)

🚀 **An intelligent multi-agent system that automates the entire software development lifecycle from requirements gathering to production deployment.**

## Overview

The AI Agent Team is a coordinated system of 10 specialized AI agents that work together to deliver complete software projects. Each agent has expertise in a specific domain and produces structured deliverables that feed into subsequent development phases.

## 🎯 **Usage Modes**

The AI Agent Team supports two distinct usage modes to fit your development workflow:

### **🗣️ Interactive Mode (Direct Claude Conversation)**
Use the framework directly in conversation with Claude - no CLI setup required.

**Benefits:**
- ✅ **Immediate feedback** and real-time clarification
- ✅ **Iterative refinement** of requirements and designs  
- ✅ **Natural conversation flow** with agents
- ✅ **No installation required** - works directly in Claude interface
- ✅ **Perfect for exploration** and initial project planning

**Usage:**
```
claude --agent [agent-name]
[DESIGN PHASE] Create expense management system requirements
```

### **💻 CLI Mode (Terminal Commands)**  
Use the framework from your terminal for automation and scripting.

**Benefits:**
- ✅ **Script automation** capabilities for repeatable workflows
- ✅ **Batch processing** of multiple agents
- ✅ **Integration** with development tools and CI/CD
- ✅ **Version control** integration
- ✅ **Perfect for production** workflows and team collaboration

**Usage:**
```bash
claude --design --agent po "Create expense management system"
claude --develop --agent backend-developer "Implement authentication"
```

## 🌐 **Using with Other LLMs**

**Great news!** While built for Claude Code, this framework's methodology is **highly transferable** to other LLMs like **Kimi K2**, **GPT-4**, **Gemini**, or any conversational AI.

### **✅ What Works with Any LLM**

#### **🎯 Agent Personas & Expertise**
The `.claude/agents/*.md` files are structured prompts defining expert personas:
- **Will (Product Owner)** - Requirements gathering specialist  
- **Mike (System Architect)** - Technical architecture expert
- **Luke (Backend Developer)** - API and database specialist
- **All 10 agents** can be copied to any LLM interface

#### **🏗️ Two-Phase Methodology**
The **DESIGN PHASE → IMPLEMENTATION PHASE** workflow is universal:
- Phase 1: Gather requirements, create architecture, plan implementation
- Phase 2: Write actual code following design specifications
- Works with any LLM that can follow structured prompts

#### **📚 Documentation Structure**
- Design document organization (`design-phase/` folder)
- Agent workflow dependencies and handoffs
- Quality standards and deliverable templates

### **🔧 Manual Adaptation Guide**

#### **For Interactive Mode with Other LLMs:**
```
1. Copy agent persona from .claude/agents/po.md
2. Start conversation: "[DESIGN PHASE] Create requirements for expense management system"  
3. Save output to design-phase/PRD.md
4. Switch to architect persona, reference the PRD
5. Continue through workflow manually
```

#### **Example Workflow with Kimi K2:**
```
Session 1: Product Owner
→ [DESIGN PHASE] Create comprehensive requirements for project management SaaS

Session 2: System Architect  
→ [DESIGN PHASE] Design scalable architecture for the requirements in PRD.md

Session 3: Backend Developer
→ [IMPLEMENTATION PHASE] Implement authentication system following DESIGN.md specifications
```

### **⚠️ What You'll Lose (Claude Code Specific)**
- **CLI Automation**: No `claude --agent [name]` convenience
- **Automatic Context**: Manual copying of previous work between sessions  
- **Agent Switching**: Manual persona management instead of automated
- **Integration**: No built-in version control or development tool integration

### **💡 Adaptation Recommendations**
- ✅ **Start small**: Test with one agent (Product Owner) using ExpenseFlow example
- ✅ **Manual workflow**: Copy agent personas and manage phases manually
- ✅ **Save outputs**: Organize design documents in your own folder structure
- ✅ **Reference previous work**: Manually provide context from previous agents
- ✅ **Adapt for your LLM**: Modify prompt formatting for optimal results

### **🚀 Success Stories**
Users have successfully adapted this framework for:
- **GPT-4** - Full software project planning and implementation
- **Gemini** - Multi-agent design workflows for mobile apps  
- **Local LLMs** - Privacy-focused development workflows
- **Custom Chatbots** - Domain-specific agent implementations

**The framework's real value is the structured expertise and workflow methodology, not just the Claude Code integration.**

### 🎯 Key Features

- **Complete SDLC Coverage**: From product requirements to production deployment
- **10 Specialized Agents**: Each with unique expertise and responsibilities  
- **Structured Workflow**: Waterfall-inspired process with clear dependencies
- **Production-Ready Output**: Full documentation, code plans, and deployment strategies
- **Security-First Approach**: Integrated security throughout the development process
- **Multi-Platform Support**: Mobile (Flutter), Web (Next.js), and Backend (FastAPI)

## 📸 **Framework in Action: ExpenseFlow Showcase**

See the AI Agent Team executing a real enterprise project - **no demos, this is actual workflow execution:**

### **🎯 Systematic Multi-Agent Execution**
![AI Agent Team workflow with todo tracking](images/multi-agent-in-progress-1.jpg)
*Real workflow showing Will (Product Owner) completing comprehensive requirements while the system tracks all 10 agents' progress with detailed deliverables.*

### **🏗️ Agent Handoffs and Collaboration**  
![Jennifer Mobile UI Designer delivering 65-page design](images/multi-agent-in-progress-3.jpg)
*Jennifer delivers 65-page mobile UI design with WCAG 2.1 AA accessibility compliance, platform-specific adaptations, and performance optimization for <3-second app launch.*

### **✅ Complete Project Results**
![ExpenseFlow complete multi-platform system delivered](images/multi-agent-in-progress-7.jpg)
*Final deliverable: Complete multi-platform expense management system with Flutter mobile app, Next.js web dashboard, FastAPI backend, and AWS infrastructure - all documented and implementation-ready.*

**Key Insights from Real Execution:**
- 🎯 **443-line PRD** with 40+ detailed user stories (Will)
- 🏗️ **Complete microservices architecture** with security and scalability (Mike) 
- 🎨 **65-page mobile UI design** with accessibility compliance (Jennifer)
- 🔒 **Enterprise security** with STRIDE threat analysis (Sarah)
- 📱 **Flutter development plan** with BLoC architecture (Bob)
- 💻 **Next.js implementation plan** with TypeScript (Jim)

## 🏗️ Two-Phase Architecture

### **🏗️ DESIGN PHASE Workflow**
- 🎯 **Purpose:** Create comprehensive planning documents
- 🏗️ **Output:** Architecture specifications, implementation roadmaps  
- ✅ **Completion:** All design documents exist and are validated
```mermaid
graph TD
    A["`🎯 **User Input**
    Project Requirements`"] --> B["`🎯 **Will - Product Owner**
    Requirements Gathering
    📄 PRD.md`"]
    
    B --> C["`🏗️ **Mike - System Architect**
    Technical Architecture
    📄 DESIGN.md`"]
    
    C --> D["`🎨 **Jennifer - Mobile UI Designer**
    Mobile Interface Design
    📄 MOBILE-UI.md`"]
    
    C --> E["`🎨 **Amy - Web UI Designer**
    Web Dashboard Design
    📄 WEB-UI.md`"]
    
    C --> K["`🔒 **Sarah - Security Engineer**
    Security Architecture
    📄 SECURITY.md`"]
    
    D --> F["`📱 **Bob - Mobile Developer**
    Mobile Implementation Plan
    📄 MOBILE-DEV.md`"]
    
    E --> G["`💻 **Jim - Web Developer**
    Web Implementation Plan
    📄 WEB-DEV.md`"]
    
    C --> H["`⚙️ **Luke - Backend Developer**
    Backend Implementation Plan
    📄 BACKEND-DEV.md`"]
    
    K --> H
    
    F --> I["`🧪 **Vijay - QA Tester**
    Testing Strategy
    📄 QA-TESTING.md`"]
    
    G --> I
    H --> I
    
    I --> L["`🚀 **Alex - DevOps Engineer**
    Infrastructure Plan
    📄 DEVOPS-DEPLOY.md`"]
    
    L --> M["`📋 **Complete Design Documents**
    Ready for Implementation`"]
    
    style A fill:#e1f5fe
    style M fill:#e8f5e8
    style B fill:#fff3e0
    style C fill:#f3e5f5
    style D fill:#fce4ec
    style E fill:#fce4ec
    style K fill:#ffebee
    style F fill:#e3f2fd
    style G fill:#e3f2fd
    style H fill:#e3f2fd
    style I fill:#f1f8e9
    style L fill:#fff8e1
```

### **💻 IMPLEMENTATION PHASE Workflow**
- 💻 **Purpose:** Write actual production code following design specifications
- 🔧 **Output:** Working applications, tests, infrastructure
- ✅ **Completion:** Production-ready system is deployed
```mermaid
graph TD
    A["📋 Design Documents<br/>Complete Specifications"] --> B["🔧 Setup Implementation<br/>Environment & Dependencies"]
    
    B --> C{"🎯 Select Platform<br/>Choose Implementation Area"}
    
    C -->|Backend First| D["⚙️ Luke - Backend Developer<br/>📁 implementation/backend/<br/><br/>🔨 API Endpoints<br/>🗄️ Database Models<br/>🔐 Authentication<br/>🧪 Unit Tests"]
    
    C -->|Frontend Parallel| E["💻 Jim - Web Developer<br/>📁 implementation/frontend-web/<br/><br/>🎨 UI Components<br/>📊 Dashboard Layout<br/>🔄 State Management<br/>🧪 Component Tests"]
    
    C -->|Mobile Parallel| F["📱 Bob - Mobile Developer<br/>📁 implementation/mobile-app/<br/><br/>📱 Native Screens<br/>📷 Device Integration<br/>💾 Offline Storage<br/>🧪 Widget Tests"]
    
    D --> G["🔗 Integration Testing<br/>Cross-Platform Validation"]
    E --> G
    F --> G
    
    G --> H["🧪 Vijay - QA Tester<br/>Comprehensive Testing<br/><br/>🔍 API Testing<br/>🎭 E2E Testing<br/>⚡ Performance Testing"]
    
    H --> I["🚀 Alex - DevOps Engineer<br/>📁 implementation/infrastructure/<br/><br/>🐳 Docker Containers<br/>☸️ Kubernetes Deploy<br/>📊 Monitoring Setup<br/>🔄 CI/CD Pipeline"]
    
    I --> J["✅ Production Ready<br/>Complete Application"]
    
    style A fill:#e1f5fe
    style J fill:#e8f5e8
    style B fill:#fff3e0
    style C fill:#f3e5f5
    style D fill:#ffebee
    style E fill:#e3f2fd
    style F fill:#fce4ec
    style G fill:#fff8e1
    style H fill:#f1f8e9
    style I fill:#e0f2f1
```

## 📋 **Agent Phase Reference**

**📄 See [AGENT-PHASE-MAPPING.md](AGENT-PHASE-MAPPING.md) for complete agent phase documentation**

### **🏗️ Design Phase Agents**
- **Design-Only (4):** Will, Mike, Jennifer, Amy - Create specifications only
- **Dual-Phase (6):** Sarah, Bob, Jim, Luke, Vijay, Alex - Plan AND implement

### **💻 Implementation Phase Agents**  
- **Implementation-Capable (6):** Sarah, Bob, Jim, Luke, Vijay, Alex - Write actual code

## 👥 Meet the Team

| Agent | Name | Role | Design Phase | Implementation Phase |
|-------|------|------|-------------|---------------------|
| 🎯 | **Will** | Product Owner | ✅ Requirements & Stories | ❌ N/A |
| 🏗️ | **Mike** | System Architect | ✅ System Architecture | ❌ N/A |
| 🎨 | **Jennifer** | Mobile UI Designer | ✅ Mobile UI Design | ❌ N/A |
| 🎨 | **Amy** | Web UI Designer | ✅ Web UI Design | ❌ N/A |
| 🔒 | **Sarah** | Security Engineer | ✅ Security Architecture | ✅ Security Validation |
| 📱 | **Bob** | Mobile Developer | ✅ Mobile Dev Planning | ✅ Flutter Implementation |
| 💻 | **Jim** | Web Developer | ✅ Web Dev Planning | ✅ Next.js Implementation |
| ⚙️ | **Luke** | Backend Developer | ✅ Backend Dev Planning | ✅ FastAPI Implementation |
| 🧪 | **Vijay** | QA Tester | ✅ Testing Strategy | ✅ Test Implementation |
| 🚀 | **Alex** | DevOps Engineer | ✅ Infrastructure Planning | ✅ DevOps Implementation |

## 🎯 ExpenseFlow Showcase - Complete Implementation

**✅ We've successfully demonstrated the entire AI Agent Team workflow by building ExpenseFlow**, a comprehensive expense management system. This showcase proves the framework's effectiveness in delivering enterprise-grade software solutions.

### 📋 What We Built Together

The 10 AI agents systematically collaborated to create:

**📄 Complete Documentation Suite:**
- `examples/expenseflow/design/PRD.md` - Product Requirements (443 lines, 40+ user stories)
- `examples/expenseflow/design/DESIGN.md` - System Architecture with microservices
- `examples/expenseflow/design/MOBILE-UI.md` - Mobile UI Design (65 pages with accessibility)
- `examples/expenseflow/design/WEB-UI.md` - Web Dashboard Design with data visualization
- `examples/expenseflow/design/SECURITY.md` - Enterprise Security Architecture with STRIDE analysis
- `examples/expenseflow/design/MOBILE-DEV.md` - Flutter Implementation Plan with BLoC pattern
- `examples/expenseflow/design/WEB-DEV.md` - Next.js Implementation with TypeScript
- `examples/expenseflow/design/BACKEND-DEV.md` - FastAPI Backend with PostgreSQL
- `examples/expenseflow/design/QA-TESTING.md` - Comprehensive Testing Strategy
- `examples/expenseflow/design/DEVOPS-DEPLOY.md` - DevOps & AWS Infrastructure Plan

**🏗️ Multi-Platform System Design:**
- **Mobile App**: Flutter with offline-first architecture, OCR receipt processing, biometric auth
- **Web Dashboard**: Next.js with real-time notifications, analytics, responsive design
- **Backend API**: FastAPI with PostgreSQL, background tasks, compliance features
- **Infrastructure**: AWS with Kubernetes, auto-scaling, comprehensive monitoring

**🔄 Key Insight: Design vs Implementation**

**What the AI Agent Team Delivered:**
- ✅ **Complete blueprints** - Detailed design documents from all 10 agents
- ✅ **Implementation roadmaps** - Step-by-step plans for building each component
- ✅ **Architecture specifications** - Technical designs ready for development
- ✅ **Enterprise-grade planning** - Security, compliance, testing, and deployment strategies

**What's Next - Actual Implementation:**
- 🚧 **Code development** - Writing the actual Flutter, Next.js, and FastAPI code
- 🚧 **Infrastructure deployment** - Creating AWS resources and CI/CD pipelines
- 🚧 **Integration testing** - Connecting all components together

**💡 The Value Delivered:**

The AI Agent Team eliminated the most time-consuming part of software development - the **planning and design phase**. Typically taking 3-6 months with traditional teams, we completed comprehensive planning for an enterprise application in a systematic workflow.

## 🚀 Getting Started

### Prerequisites

- Claude Code CLI installed and configured
- Access to the AI Agent Team repository
- Basic understanding of software development concepts

### Quick Start

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd ai-agent-team
   ```

2. **Review the ExpenseFlow Showcase**
   ```bash
   # View the ExpenseFlow example
   ls examples/expenseflow/design/
   
   # Read the complete ExpenseFlow PRD
   cat examples/expenseflow/design/PRD.md
   
   # Read the initial framework PRD
   cat INIT-PRD.md
   
   # Explore framework documentation
   ls framework/
   
   # Check out agent definitions
   ls .claude/agents/
   
   # Read the marketing article
   cat ARTICLE.md
   
   # See your active workspace
   ls design-phase/
   ls implementation/
   ```

3. **Study the AI Agent Workflow**
   Review how each agent built on the previous agent's work in the ExpenseFlow example:
   - Will → Mike → Jennifer/Amy/Sarah → Bob/Jim/Luke → Vijay → Alex
   
   ```bash
   # See the complete workflow progression in ExpenseFlow
   ls examples/expenseflow/design/
   
   # Study how agents referenced each other's work
   grep -l "PRD.md" examples/expenseflow/design/*.md
   grep -l "DESIGN.md" examples/expenseflow/design/*.md
   ```

4. **Start Your First Project**
   ```bash
   # METHOD 1: Using CLI flags (Recommended - Crystal Clear)
   claude --design --agent po "Create expense management system"
   claude --design --agent architect "Design scalable microservices architecture"
   claude --develop --agent backend-developer "Implement authentication endpoints"
   
   # METHOD 2: Using prompt patterns (Traditional)
   claude --agent po
   # Prompt: [DESIGN PHASE] Gather requirements for [your-project]
   
   claude --agent backend-developer  
   # Prompt: [DEVELOP PHASE] Implement authentication endpoints
   ```

### 🎯 **NEW: Crystal Clear Usage with CLI Flags & Dual Mode Support**

**🔥 MAJOR IMPROVEMENT:** No more confusion! Use explicit CLI flags or prompt patterns to indicate whether you're planning or coding.

#### **Design Phase Example: E-commerce Platform**

**METHOD 1: CLI Flags (Recommended)**
```bash
# Crystal clear commands - no ambiguity!
claude --design --agent po "E-commerce platform with mobile app and admin dashboard"
claude --design --agent architect "Scalable system architecture for e-commerce platform"
claude --design --agent security-engineer "Security architecture with payment processing compliance"
claude --design --agent mobile-ui-designer "Mobile shopping experience and product catalog"
claude --design --agent web-ui-designer "Admin dashboard for inventory and order management"
claude --design --agent backend-developer "Backend API with product catalog and payments"
claude --design --agent web-developer "Next.js admin dashboard architecture"
claude --design --agent mobile-developer "Flutter shopping app with offline cart"

# Result: Complete set of design documents ready for implementation
```

**METHOD 2: Prompt Patterns (Traditional)**
```bash
# Traditional method with prompt keywords
claude --agent po "[DESIGN PHASE] E-commerce platform requirements"
claude --agent architect "[DESIGN PHASE] System architecture design"
# ... continue with [DESIGN PHASE] prefix for each agent
```

#### **Implementation Phase Example: Building the E-commerce Platform**

**METHOD 1: CLI Flags (Recommended)**
```bash
# Crystal clear implementation commands
claude --develop --agent backend-developer "User authentication and registration APIs"
claude --develop --agent backend-developer "Product catalog API with search and filtering"
claude --develop --agent backend-developer "Shopping cart and checkout API with payments"

# Frontend Implementation
claude --develop --agent web-developer "Admin dashboard layout with sidebar navigation"
claude --develop --agent web-developer "Product management interface with image upload"

# Mobile Implementation  
claude --develop --agent mobile-developer "Product catalog screen with search"
claude --develop --agent mobile-developer "Shopping cart screen with offline sync"

# Testing Implementation
claude --develop --agent qa-tester "Comprehensive API tests for e-commerce endpoints"

# Result: Working e-commerce application with mobile app and admin dashboard
```

**METHOD 2: Prompt Patterns (Traditional)**
```bash
# Traditional method with prompt keywords
claude --agent backend-developer "[DEVELOP PHASE] Implement authentication APIs"
claude --agent web-developer "[DEVELOP PHASE] Create admin dashboard layout"
# ... continue with [DEVELOP PHASE] prefix for each agent
```

#### **Quick Start Example: Simple SaaS Application**

```bash
# DESIGN PHASE - Crystal clear planning (CLI Flags)
claude --design --agent po "Project management SaaS requirements"
claude --design --agent architect "System architecture with multi-tenancy"
claude --design --agent security-engineer "Security framework with RBAC"
claude --design --agent web-developer "Next.js application architecture"
claude --design --agent backend-developer "FastAPI backend with PostgreSQL"

# DEVELOP PHASE - Crystal clear implementation (CLI Flags)
claude --develop --agent backend-developer "User authentication system"
claude --develop --agent web-developer "Project dashboard component"
claude --develop --agent qa-tester "Testing suite for authentication"

# Alternative: Traditional prompt method still works
# claude --agent po "[DESIGN PHASE] SaaS requirements"
# claude --agent backend-developer "[DEVELOP PHASE] Implement auth"
```

## 📁 Project Structure

```
ai-agent-team/
├── README.md                    # This file
├── INIT-PRD.md                  # Initial Product Requirements Document
├── ARTICLE.md                   # Marketing article
├── AI-Agent-Team.drawio.svg     # Visual architecture diagram
├── framework/                   # 🆕 Framework documentation
│   ├── README.md                # Framework overview
│   ├── CLAUDE.md                # Configuration guide
│   ├── IMPLEMENTATION.md        # Implementation guide
│   ├── PROMPT-PATTERNS.md       # Prompt patterns guide
│   └── FRAMEWORK-IMPROVEMENTS.md # Latest improvements
├── design-phase/                # 🆕 DESIGN PHASE workspace (your active project)
│   └── README.md                # Design phase workspace guide
├── implementation/              # 🆕 DEVELOP PHASE workspace (your active project)
│   ├── README.md                # Implementation guide
│   ├── backend/                 # Backend code workspace
│   ├── frontend-web/            # Web frontend workspace
│   ├── mobile-app/              # Mobile app workspace
│   └── infrastructure/          # Infrastructure code workspace
├── examples/                    # 🆕 Framework showcases and examples
│   ├── README.md                # Examples overview
│   └── expenseflow/             # Complete ExpenseFlow showcase
│       ├── README.md            # ExpenseFlow showcase overview
│       ├── design/              # Complete DESIGN PHASE output
│       │   ├── PRD.md           # Product requirements (Will)
│       │   ├── DESIGN.md        # System architecture (Mike)
│       │   ├── MOBILE-UI.md     # Mobile UI specs (Jennifer)
│       │   ├── WEB-UI.md        # Web UI specs (Amy)
│       │   ├── SECURITY.md      # Security architecture (Sarah)
│       │   ├── MOBILE-DEV.md    # Mobile dev plan (Bob)
│       │   ├── WEB-DEV.md       # Web dev plan (Jim)
│       │   ├── BACKEND-DEV.md   # Backend dev plan (Luke)
│       │   ├── QA-TESTING.md    # Testing strategy (Vijay)
│       │   └── DEVOPS-DEPLOY.md # Infrastructure plan (Alex)
│       └── implementation/      # ExpenseFlow implementation workspace
├── scripts/                     # Helper scripts for enhanced UX
│   ├── README.md                # Scripts documentation
│   ├── design.sh                # Design phase helper script
│   └── develop.sh               # Develop phase helper script
└── .claude/agents/              # Enhanced agent definitions
    ├── po.md                    # Will - Product Owner
    ├── architect.md             # Mike - System Architect
    ├── mobile-ui-designer.md    # Jennifer - Mobile UI Designer
    ├── web-ui-designer.md       # Amy - Web UI Designer
    ├── mobile-developer.md      # Bob - Mobile Developer (🆕 Enhanced)
    ├── web-developer.md         # Jim - Web Developer (🆕 Enhanced)
    ├── backend-developer.md     # Luke - Backend Developer (🆕 Enhanced)
    ├── security-engineer.md     # Sarah - Security Engineer
    ├── qa-tester.md             # Vijay - QA Tester
    └── devops-engineer.md       # Alex - DevOps Engineer
```

## 🛠️ Technology Stack

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Next.js](https://img.shields.io/badge/Next.js-000000?style=for-the-badge&logo=next.js&logoColor=white)
![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326ce5?style=for-the-badge&logo=kubernetes&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)

### Frontend
- **Mobile**: Flutter, Dart
- **Web**: Next.js, React, TypeScript, shadcn/ui, Tailwind CSS

### Backend
- **API**: Python, FastAPI
- **Database**: SQLite (POC), PostgreSQL (Production)
- **Cache**: Redis

### Infrastructure
- **Containerization**: Docker, Kubernetes
- **Cloud**: AWS/GCP/Azure
- **CI/CD**: GitHub Actions, GitLab CI, or Jenkins
- **Monitoring**: Prometheus, Grafana, ELK Stack

## 🎯 **Framework Improvements**

### **🔥 NEW: Crystal Clear Design vs Develop Phases**

**Major UX Enhancement:** We've eliminated confusion by implementing explicit `phases`:

**🏗️ DESIGN PHASE:**
- Creates comprehensive planning documents
- Generates system architecture and specifications
- Focuses on planning, not coding
- Uses `[DESIGN PHASE]` prompt pattern

**💻 DEVELOP PHASE:**
- Implements actual working code
- Follows design specifications automatically
- Focuses on coding, not planning  
- Uses `[DEVELOP PHASE]` prompt pattern

### **🚀 Enhanced Helper Scripts**

**Better User Experience:**
```bash
# Crystal clear design commands
./scripts/design.sh backend-developer "Plan expense management API"

# Crystal clear implementation commands  
./scripts/develop.sh backend-developer "Implement authentication endpoints"
```

### **🧠 Intelligent Agent Behavior**

**Each agent now automatically:**
- 🎯 Detects phase from prompt patterns
- 📚 References appropriate design documents
- 🔄 Follows phase-specific workflows
- ✅ Self-validates against specifications

## 📁 **Improved Project Organization**

**🔥 NEW: Crystal Clear Folder Structure**

We've reorganized the project to perfectly align with the two-phase approach:

### **📋 Framework Documentation**
- `framework/` - All framework documentation and guides
- `framework/CLAUDE.md` - Configuration and customization guide
- `framework/IMPLEMENTATION.md` - Step-by-step implementation guide

### **📁 Active Project Workspaces**
- `design-phase/` - Your DESIGN PHASE workspace for creating specifications
- `implementation/` - Your DEVELOP PHASE workspace for writing code

### **📚 Framework Examples**
- `examples/expenseflow/` - Complete ExpenseFlow showcase demonstrating full workflow
- `examples/expenseflow/design/PRD.md` - 443-line product requirements document
- `examples/expenseflow/design/BACKEND-DEV.md` - Comprehensive backend implementation plan

### **🚀 Enhanced User Experience**
- `scripts/` - Helper scripts for crystal-clear phase selection
- Clear separation between framework, design, and implementation
- Each folder has comprehensive README with guidance

## 📊 Workflow Process

1. **Requirements** → Will gathers and documents user requirements
2. **Architecture** → Mike designs technical architecture and APIs
3. **Design** → Jennifer (mobile) and Amy (web) create UI/UX designs
4. **Security** → Sarah defines security architecture and requirements
5. **Development** → Bob (mobile), Jim (web), Luke (backend) create implementation plans
6. **Testing** → Vijay designs comprehensive testing strategy
7. **Deployment** → Alex creates infrastructure and deployment strategy

## 🔧 Customization

The AI Agent Team can be customized for different:

- **Technology Stacks**: Modify agent definitions for different frameworks
- **Team Sizes**: Add or remove agents based on project needs  
- **Methodologies**: Adapt workflow for Agile, DevOps, or other approaches
- **Industries**: Customize for healthcare, finance, education, etc.

See `framework/CLAUDE.md` for detailed configuration and customization instructions.

## ⚠️ **Important Disclaimers**

### **📋 Framework Dependency**
This framework is built upon **Claude Code** - Anthropic's official CLI for Claude. You must have Claude Code installed and configured to use this framework.

**Installation:**
- Visit [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code) for setup instructions
- Requires valid Anthropic API access and Claude Code CLI

### **💰 Token Usage Warning**
**⚠️ IMPORTANT:** Executing complete projects with this framework can consume **significant amounts of tokens**.

**Token Consumption Factors:**
- **Design Phase**: Each agent generates 1,000-5,000+ tokens of comprehensive documentation
- **Implementation Phase**: Code generation can consume 2,000-10,000+ tokens per feature
- **Complete Projects**: Full SDLC execution may consume 50,000-200,000+ tokens

**Recommendations:**
- ✅ **Monitor your token usage** regularly in your Anthropic console
- ✅ **Start with small projects** to understand token consumption patterns
- ✅ **Use selective agents** rather than full workflows for cost control
- ✅ **Consider token limits** when planning large enterprise projects

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes to agent definitions or documentation
4. Test with sample projects
5. Submit a pull request

## 📄 License

[MIT License](LICENSE) - Feel free to use and modify for your projects.

## 🆘 Support

- **Documentation**: See `framework/CLAUDE.md` for detailed configuration
- **Issues**: Report bugs and feature requests via GitHub Issues
- **Community**: Join discussions in GitHub Discussions

---

**Built with ❤️ by the AI Agent Team**

*Automating software development, one agent at a time.*