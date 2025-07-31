# AI Agent Team - Claude Configuration Guide

This document provides detailed configuration and customization instructions for the AI Agent Team system.

## 🏗️ Agent Architecture

The AI Agent Team follows a structured workflow where each agent has specific responsibilities and dependencies:

### Agent Dependencies

```
User Input
    ↓
Will (Product Owner)
    ↓
Mike (System Architect)
    ↓ ↓ ↓
Jennifer  Amy  Sarah
(Mobile UI) (Web UI) (Security)
    ↓ ↓ ↓
Bob  Jim  Luke
(Mobile Dev) (Web Dev) (Backend Dev)
    ↓ ↓ ↓
Vijay (QA Tester)
    ↓
Alex (DevOps Engineer)
    ↓
Final Deliverables
```

## 🔧 Agent Configuration

### Agent Definition Structure

Each agent follows this YAML front matter structure:

```yaml
---
name: agent-name
description: Agent purpose and expertise description
tools: List, Of, Available, Tools
---
```

### Core Agent Requirements

All agents must:
1. **Identify themselves** with name and role at the start
2. **Validate input dependencies** before beginning work
3. **Follow consistent output formats** using structured Markdown
4. **Reference other agents' outputs** when building on their work

### Available Tools by Agent Type

| Agent Type | Tools Available |
|------------|----------------|
| **Requirements/Design** | Read, Write, Bash, TodoWrite |
| **Development** | Read, Write, Edit, Bash, TodoWrite, Grep, Glob |
| **Operations** | Read, Write, Edit, Bash, TodoWrite, Grep, Glob |

## 🎯 Customizing Agents

### Modifying Existing Agents

To customize an agent's behavior:

1. **Edit the agent definition file** in `.claude/agents/`
2. **Modify the methodology section** to change approaches
3. **Update tool specifications** if different tools are needed
4. **Adjust output structure** to match your requirements

Example: Customizing the Backend Developer for different tech stack:

```yaml
---
name: backend-developer
description: Luke - Backend Developer agent customized for Node.js and Express
tools: Read, Write, Edit, Bash, TodoWrite, Grep, Glob
---

You are Luke, a senior Backend Developer specializing in Node.js and Express development...

### Technical Standards
- **Node.js/Express**: Follow Node.js best practices and Express conventions
- **Database Design**: MongoDB with Mongoose ODM
- **Authentication**: Passport.js integration
...
```

### Adding New Agents

To add a new agent to the team:

1. **Create agent definition file** in `.claude/agents/`
2. **Update the workflow** in `prd.md` and `README.md`
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

## 🔄 Workflow Customization

### Sequential vs Parallel Execution

The current workflow supports both:

- **Sequential**: Each agent waits for the previous to complete
- **Parallel**: UI designers and developers can work concurrently

To modify the workflow:

1. **Update agent input dependencies** in each agent definition
2. **Modify the workflow diagram** in `README.md`
3. **Update success criteria** in PRD

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