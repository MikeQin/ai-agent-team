# AI Agent Team - Claude Configuration Guide

This document provides detailed configuration and customization instructions for the AI Agent Team system with the new **two-phase approach**.

## 🎯 **Usage Modes**

The AI Agent Team supports two distinct usage modes to accommodate different development workflows and preferences:

### **🗣️ Interactive Mode (Direct Claude Conversation)**
**Best for:** Exploration, learning, initial planning, and iterative development

**How it works:**
- Use agents directly in conversation with Claude
- No CLI installation or setup required
- Real-time feedback and clarification
- Natural conversation flow with immediate responses

**Usage Examples:**
```
claude --agent po
[DESIGN PHASE] Create comprehensive requirements for a multi-platform expense management system

claude --agent backend-developer  
[DEVELOP PHASE] Implement user authentication following the design in design-phase/BACKEND-DEV.md
```

**Benefits:**
- ✅ **Zero setup** - works immediately in any Claude interface
- ✅ **Interactive feedback** - ask questions and get immediate clarification
- ✅ **Iterative refinement** - easily modify and improve requirements
- ✅ **Learning friendly** - perfect for understanding the framework
- ✅ **Flexible workflow** - change direction based on real-time insights

### **💻 CLI Mode (Terminal Commands)**
**Best for:** Production workflows, automation, team collaboration, and scripting

**How it works:**
- Execute agents through terminal commands
- Integrate with development tools and CI/CD pipelines
- Batch processing and automation capabilities
- Version control integration

**Usage Examples:**
```bash
# CLI Flags Method (Recommended)
claude --design --agent po "Create expense management system"
claude --develop --agent backend-developer "Implement authentication endpoints"

# Helper Scripts (Alternative)
./scripts/design.sh po "Create expense management system"
./scripts/develop.sh backend-developer "Implement authentication endpoints"
```

**Benefits:**
- ✅ **Automation ready** - script entire development workflows
- ✅ **CI/CD integration** - incorporate into build and deployment pipelines
- ✅ **Team collaboration** - consistent execution across team members
- ✅ **Version control** - track agent executions and outputs
- ✅ **Production workflows** - reliable and repeatable processes

### **🔄 Mode Flexibility**
**You can seamlessly switch between modes:**
- Start with **Interactive Mode** for exploration and planning
- Move to **CLI Mode** for production implementation and automation
- Use **Interactive Mode** for troubleshooting and refinement
- Return to **CLI Mode** for final deployment and delivery

## 🎯 **NEW: Two-Phase Architecture**

The AI Agent Team now operates with a **crystal-clear two-phase approach** that eliminates confusion and provides explicit control over planning vs implementation.

## 📋 **Agent Phase Reference**

**📄 See [../AGENT-PHASE-MAPPING.md](../AGENT-PHASE-MAPPING.md) for complete agent phase documentation**

### **🏗️ Design Phase Agents**
- **Design-Only (4):** Will, Mike, Jennifer, Amy - Create specifications only
- **Dual-Phase (6):** Sarah, Bob, Jim, Luke, Vijay, Alex - Plan AND implement

### **💻 Implementation Phase Agents**  
- **Implementation-Capable (6):** Sarah, Bob, Jim, Luke, Vijay, Alex - Write actual code

### **🏗️ Phase 1: DESIGN PHASE**
- 🎯 **Purpose:** Create comprehensive planning documents
- 🏗️ **Output:** Architecture specifications, implementation roadmaps  
- ✅ **Completion:** All design documents exist and are validated

```
User Input → [DESIGN PHASE]
    ↓
Will (Product Owner) → PRD Creation
    ↓
Mike (System Architect) → System Design
    ↓ ↓ ↓
Jennifer      Amy        Sarah
(Mobile UI)   (Web UI)   (Security)
    ↓ ↓ ↓
Bob           Jim        Luke
(Mobile Dev)  (Web Dev)  (Backend Dev)
    ↓ ↓ ↓
Vijay (QA Tester) → Testing Strategy
    ↓
Alex (DevOps Engineer) → Infrastructure Plan
    ↓
Complete Design Documents in design-phase/
```

### **💻 Phase 2: IMPLEMENTATION PHASE**
- 💻 **Purpose:** Write actual production code following design specifications
- 🔧 **Output:** Working applications, tests, infrastructure
- ✅ **Completion:** Production-ready system is deployed

```
Design Documents → [DEVELOP PHASE]
    ↓
Backend Implementation (Luke)
Frontend Implementation (Jim)
Mobile Implementation (Bob)
    ↓
Testing Implementation (Vijay)
    ↓
Infrastructure Implementation (Alex)
    ↓
Production-Ready Application
```

## 🔄 **Mode-Based Operation**

### **🆕 CLI Flags Method (Recommended)**
**The clearest way to specify what you want to do:**

**Design Mode:**
```bash
claude --design --agent [agent-name] "[description]"
```

**Develop Mode:**
```bash
claude --develop --agent [agent-name] "[description]"
```

**Examples:**
```bash
# DESIGN PHASE - Crystal clear planning
claude --design --agent po "Create expense management system"
claude --design --agent architect "Design scalable microservices architecture"
claude --design --agent backend-developer "Plan FastAPI backend with PostgreSQL"

# IMPLEMENTATION PHASE - Crystal clear coding
claude --develop --agent backend-developer "Implement user authentication system"
claude --develop --agent web-developer "Create dashboard components"
claude --develop --agent qa-tester "Build comprehensive test automation"
```

### **Traditional Phase Triggers (Still Supported):**
- `[DESIGN PHASE]` in prompts - Triggers Design Phase
- `[DEVELOP PHASE]` in prompts - Triggers Implementation Phase
- Keywords: "design", "plan", "architecture", "strategy" (auto-detection for Design Phase)
- Keywords: "implement", "code", "build", "create" (auto-detection for Implementation Phase)
- Helper script: `./scripts/design.sh` - Design Phase execution
- Helper script: `./scripts/develop.sh` - Implementation Phase execution

## 🔧 **Enhanced Agent Configuration**

### **New Phase-Based Agent Structure**

Each agent now follows this enhanced YAML front matter structure:

```yaml
---
name: agent-name
description: Agent purpose and expertise description
tools: List, Of, Available, Tools
---

## 🎯 Phase-Based Operation

### 🏗️ DESIGN PHASE
Trigger: [DESIGN PHASE] in prompt or keywords like "design", "plan"
What I Do: Create comprehensive planning documents
Documents I Reference: Input specifications from previous agents
Output: Detailed specification document in design-phase/

### 💻 IMPLEMENTATION PHASE  
Trigger: [DEVELOP PHASE] in prompt or keywords like "implement", "code"
What I Do: Write actual production code
Documents I Reference: MY OWN implementation plan FIRST, then related specs
Output: Production-ready code following design specifications
```

### **Agent Phase Capabilities**

| Agent Type | Design Phase | Implementation Phase | Why |
|------------|-------------|---------------------|-----|
| **Requirements/Architecture** | ✅ | ❌ | Create specifications, don't implement |
| **UI/UX Design** | ✅ | ❌ | Create mockups and designs, don't code |
| **Development** | ✅ | ✅ | Plan architecture AND write code |
| **Security/QA/DevOps** | ✅ | ✅ | Plan strategies AND implement solutions |

### **Enhanced Agent Requirements**

All agents now must:
1. **Detect phase** from prompt patterns (`[DESIGN PHASE]` vs `[DEVELOP PHASE]`)
2. **Reference appropriate documents** based on the current phase
3. **Follow phase-specific workflows** (planning vs implementation)
4. **Self-validate** against design specifications in implementation phase
5. **Maintain consistency** between design and implementation phases
6. **Know their phase limitations** (design-only vs dual-phase agents)

### Available Tools by Agent Type

| Agent Type | Tools Available |
|------------|----------------|
| **Requirements/Design** | Read, Write, Bash, TodoWrite |
| **Development** | Read, Write, Edit, Bash, TodoWrite, Grep, Glob |
| **Operations** | Read, Write, Edit, Bash, TodoWrite, Grep, Glob |

## 🎯 **Customizing Two-Phase Agents**

### **Modifying Mode-Based Agents**

To customize an agent's behavior for the two-phase approach:

1. **Edit the agent definition file** in `.claude/agents/`
2. **Update phase-specific workflows** for design vs develop phases
3. **Modify document references** for each phase
4. **Adjust output structure** to match your requirements

Example: Customizing the Backend Developer for Node.js:

```yaml
---
name: backend-developer
description: Luke - Backend Developer agent customized for Node.js and Express
tools: Read, Write, Edit, Bash, TodoWrite, Grep, Glob
---

## 🎯 Mode-Based Operation

### 🏗️ DESIGN PHASE
Trigger: [DESIGN PHASE] in prompt or keywords like "design", "plan"
What I Do: Create comprehensive Node.js backend architecture plans
Documents I Reference: PRD, system architecture, security requirements
Output: Detailed Node.js/Express implementation plan in design-phase/BACKEND-DEV.md

### 💻 DEVELOP PHASE  
Trigger: [DEVELOP PHASE] in prompt or keywords like "implement", "code"
What I Do: Write actual Node.js/Express code
Documents I Reference: design-phase/BACKEND-DEV.md FIRST, then security and testing requirements
Output: Production-ready Node.js code following design specifications

### Technical Standards
- **Node.js/Express**: Follow Node.js best practices and Express conventions
- **Database Design**: MongoDB with Mongoose ODM
- **Authentication**: Passport.js integration
```

### Adding New Agents

To add a new agent to the team:

1. **Create agent definition file** in `.claude/agents/`
2. **Update the workflow** in `INIT-PRD.md` and `README.md`
3. **Define input/output dependencies** with other agents
4. **Add to project structure** documentation

Example: Adding a DevRel Agent:

```yaml
---
name: devrel-engineer
description: Taylor - Developer Relations Engineer for API documentation and developer experience
tools: Read, Write, Bash, TodoWrite
---

You are Taylor, a Developer Relations Engineer specializing in API documentation and developer experience...
```

### Removing Agents

To remove an agent:

1. **Delete the agent definition file**
2. **Update workflow dependencies** in other agents
3. **Modify project structure** documentation
4. **Update README.md** team table

## 🚀 **CLI Flags & Helper Scripts Configuration**

### **🆕 CLI Wrapper Script (claude-wrapper.sh)**

**The new CLI flags implementation provides crystal-clear phase selection:**

```bash
# Installation (make executable)
chmod +x scripts/claude-wrapper.sh

# Usage with CLI flags
./scripts/claude-wrapper.sh --design --agent po "Create expense management system"
./scripts/claude-wrapper.sh --develop --agent backend-developer "Implement authentication"
```

**Features:**
- ✅ **Explicit phase flags** - No confusion about what you're doing
- ✅ **Agent validation** - Validates agent names before execution
- ✅ **Design document checking** - Warns if design design-phase missing in develop phase
- ✅ **Enhanced prompts** - Automatically adds `[DESIGN PHASE]` or `[DEVELOP PHASE]` prefix
- ✅ **Comprehensive feedback** - Clear status messages and tips

**Setting up PATH alias (optional):**
```bash
# Add to ~/.bashrc or ~/.zshrc for easy access
export PATH="$PATH:$(pwd)/scripts"

# Then use directly:
claude-wrapper.sh --design --agent po "Requirements"
claude-wrapper.sh --develop --agent backend-developer "Authentication"
```

### **Using Traditional Helper Scripts**

The framework also includes traditional helper scripts for legacy support:

**Design Mode Helper:**
```bash
./scripts/design.sh [agent-name] "[project description]"

# Examples
./scripts/design.sh po "Create expense management system"
./scripts/design.sh backend-developer "Plan FastAPI backend architecture"
```

**Develop Mode Helper:**
```bash
./scripts/develop.sh [agent-name] "[feature description]"

# Examples
./scripts/develop.sh backend-developer "Implement authentication endpoints"
./scripts/develop.sh web-developer "Create dashboard component"
```

### **Customizing Helper Scripts**

To customize helper scripts for your organization:

1. **Modify prompt templates** in `scripts/design.sh` and `scripts/develop.sh`
2. **Add custom validation logic** for your specific agent names
3. **Update color schemes** and output formatting
4. **Add integration** with your development tools

## 🔄 **Two-Phase Workflow Customization**

### **Phase 1: Design Workflow**

The design phase supports both sequential and parallel execution:

- **Sequential**: Each agent waits for previous design documents
- **Parallel**: UI designers can work concurrently after architect completes

**Customizing Design Phase:**
```bash
# RECOMMENDED: CLI Flags Method
# Complete design workflow
claude --design --agent po "Project requirements"
claude --design --agent architect "System architecture"  
claude --design --agent security-engineer "Security framework"

# Parallel UI design
claude --design --agent mobile-ui-designer "Mobile interface" &
claude --design --agent web-ui-designer "Web dashboard" &
wait

# Development planning
claude --design --agent backend-developer "API architecture"
claude --design --agent web-developer "Frontend architecture"
claude --design --agent mobile-developer "Mobile architecture"

# ALTERNATIVE: Traditional Helper Scripts (Still Supported)
./scripts/design.sh po "Project requirements"
./scripts/design.sh architect "System architecture"
```

### **Phase 2: Implementation Workflow**

The implementation phase is feature-driven and can be parallelized:

**Customizing Implementation Phase:**
```bash
# RECOMMENDED: CLI Flags Method
# Backend implementation
claude --develop --agent backend-developer "Authentication system"
claude --develop --agent backend-developer "Core API endpoints"

# Frontend implementation (can run in parallel)
claude --develop --agent web-developer "Dashboard components" &
claude --develop --agent mobile-developer "Mobile screens" &
wait

# Testing and infrastructure
claude --develop --agent qa-tester "Test automation"
claude --develop --agent devops-engineer "Deployment infrastructure"

# ALTERNATIVE: Traditional Helper Scripts (Still Supported)
./scripts/develop.sh backend-developer "Authentication system"
./scripts/develop.sh web-developer "Dashboard components"
```

### Adding Workflow Stages

To add new stages (e.g., Business Analysis):

1. **Create new agent definition**
2. **Insert into workflow** at appropriate stage
3. **Update dependencies** of downstream agents
4. **Add to project structure** and documentation

## 🛠️ Technology Stack Customization

### Frontend Frameworks

To use different frontend frameworks:

**React Native instead of Flutter:**
```yaml
# mobile-developer.md
- **Tech Stack**: React Native, TypeScript, Expo
```

**Vue.js instead of React:**
```yaml
# web-developer.md  
- **Tech Stack**: Vue.js, Nuxt.js, Vuetify, TypeScript
```

### Backend Technologies

**Django instead of FastAPI:**
```yaml
# backend-developer.md
- **Tech Stack**: Python, Django, Django REST Framework, PostgreSQL
```

**Node.js instead of Python:**
```yaml
# backend-developer.md
- **Tech Stack**: Node.js, Express.js, TypeScript, PostgreSQL, Redis
```

### Database Options

**MySQL instead of PostgreSQL:**
```yaml
# backend-developer.md
- **Tech Stack**: Python, FastAPI, SQLite (POC), MySQL (Production), Redis
```

**NoSQL Database:**
```yaml
# backend-developer.md
- **Tech Stack**: Python, FastAPI, MongoDB, Redis
```

## 🔐 Security Customization

### Compliance Requirements

To customize for specific compliance:

**HIPAA Compliance:**
```yaml
# security-engineer.md
- **Compliance Requirements**: HIPAA compliance mapping, BAA requirements, PHI protection
```

**PCI DSS Compliance:**
```yaml
# security-engineer.md
- **Compliance Requirements**: PCI DSS Level 1 compliance, payment data protection
```

### Security Tools Integration

To integrate specific security tools:

```yaml
# security-engineer.md
- **Tech Stack**: OWASP ZAP, SonarQube, Snyk, Checkmarx, Veracode
```

## 🚀 Deployment Customization

### Cloud Provider Specific

**AWS-Specific Configuration:**
```yaml
# devops-engineer.md
- **Tech Stack**: AWS ECS, RDS, ElastiCache, CloudFormation, CodePipeline
```

**Google Cloud Configuration:**
```yaml
# devops-engineer.md
- **Tech Stack**: Google Cloud Run, Cloud SQL, Cloud Build, Terraform
```

**Azure Configuration:**
```yaml
# devops-engineer.md
- **Tech Stack**: Azure Container Instances, Azure SQL, Azure DevOps, ARM Templates
```

### Container Orchestration

**Docker Swarm instead of Kubernetes:**
```yaml
# devops-engineer.md
- **Tech Stack**: Docker, Docker Swarm, Docker Compose, Traefik
```

## 📊 Methodology Customization

### Agile Integration

To integrate with Agile methodologies:

1. **Modify Product Owner** to work in sprints
2. **Add sprint planning** to architect workflow
3. **Include retrospectives** in QA process

### DevOps Integration

To enhance DevOps practices:

1. **Add infrastructure as code** to all agents
2. **Include monitoring** in development agents
3. **Integrate testing** in DevOps workflows

## 🎨 Output Customization

### Documentation Formats

To change output formats:

**JSON instead of Markdown:**
```yaml
# All agents
- **Output Format**: All deliverables in structured JSON format
```

**Confluence Integration:**
```yaml
# All agents  
- **Output Format**: Confluence-compatible markup with page templates
```

### Template Customization

To use organization-specific templates:

1. **Create template files** in `templates/` directory
2. **Reference templates** in agent definitions
3. **Include branding** and style guidelines

## 💻 **Implementation Workspace Configuration**

### **Platform-Specific Workspaces**

The `implementation/` folder contains dedicated workspaces for each platform, each with comprehensive README templates:

**Backend Workspace (`implementation/backend/`):**
- FastAPI + Python structure recommendations
- Node.js + Express alternative structure
- Database integration patterns (PostgreSQL, SQLite)
- API development best practices
- Authentication and security implementation
- Testing strategies and tools

**Frontend Web Workspace (`implementation/frontend-web/`):**
- Next.js + React structure recommendations  
- React + Vite alternative structure
- Component architecture patterns
- State management (Context, Redux, React Query)
- UI/UX implementation guidelines
- Responsive design and accessibility

**Mobile App Workspace (`implementation/mobile-app/`):**
- Flutter + Dart structure recommendations
- React Native + TypeScript alternative structure
- Clean Architecture and BLoC patterns
- Device integration (camera, GPS, biometrics)
- Platform-specific considerations (iOS/Android)
- App store deployment guidelines

**Infrastructure Workspace (`implementation/infrastructure/`):**
- Kubernetes + Docker structure recommendations
- Docker Compose alternative for simpler setups
- CI/CD pipeline configurations
- Terraform Infrastructure as Code
- Monitoring and observability setup
- Security and compliance implementation

### **Workspace Customization**

To customize implementation workspaces for your technology stack:

1. **Update README templates** in each workspace folder
2. **Modify folder structures** to match your preferred patterns
3. **Add technology-specific** setup instructions
4. **Include organization-specific** standards and guidelines

Example: Customizing Backend for Django:
```bash
# Edit implementation/backend/README.md
# Add Django-specific structure and guidelines
# Update agent references to Django patterns
```

### **Integration Guidance**

Each workspace README includes:
- ✅ **Reference to design documents** - Links to design-phase specifications
- ✅ **Technology setup instructions** - Environment and dependency setup
- ✅ **Best practices** - Platform-specific development guidelines
- ✅ **Integration points** - How to connect with other platform components
- ✅ **Testing strategies** - Appropriate testing approaches for each platform
- ✅ **Common issues** - Troubleshooting guides and solutions

## 🔧 Advanced Configuration

### Multi-Project Support

To support multiple projects:

1. **Add project context** to agent definitions
2. **Create project-specific** configurations
3. **Implement project switching** logic

### Integration with External Tools

**Jira Integration:**
```yaml
# po.md
- **Capabilities**: Jira ticket creation, epic management, backlog prioritization
```

**Slack Integration:**
```yaml
# All agents
- **Notifications**: Slack channel updates for completed deliverables
```

### Performance Optimization

To optimize for large projects:

1. **Implement caching** for repeated analyses
2. **Add incremental processing** for large codebases  
3. **Parallel execution** where possible

## 🐛 Troubleshooting

### Common Issues

**Agent Dependencies Missing:**
- Verify input files exist before agent execution
- Check file paths and naming conventions

**Tool Access Issues:**
- Ensure agents have required tools in YAML front matter
- Verify Claude Code CLI permissions

**Output Format Inconsistencies:**
- Review agent methodology sections
- Ensure consistent Markdown formatting

### Debug Mode

To enable debug mode:
```yaml
# Add to any agent
debug: true
verbose_logging: true
```

## 📚 Best Practices

### Agent Development

1. **Keep agents focused** on single responsibilities
2. **Minimize dependencies** between agents
3. **Use consistent terminology** across all agents
4. **Include error handling** for missing inputs

### Workflow Management

1. **Validate inputs** before processing
2. **Provide clear error messages** for failures
3. **Create rollback strategies** for failed executions
4. **Monitor execution time** and performance

### Documentation

1. **Keep documentation current** with agent changes
2. **Include examples** for complex configurations
3. **Document dependencies** clearly
4. **Provide troubleshooting guides**

---

This configuration guide enables you to customize the AI Agent Team for your specific needs, technology preferences, and organizational requirements.