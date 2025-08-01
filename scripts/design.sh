#!/bin/bash

# AI Agent Team - Design Mode Helper Script
# Usage: ./scripts/design.sh [agent-name] "[project description]"

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if agent name is provided
if [ $# -lt 1 ]; then
    print_error "Usage: ./scripts/design.sh [agent-name] \"[project description]\""
    echo ""
    echo "Available agents:"
    echo "  po                   - Product Owner (Requirements)"
    echo "  architect            - System Architect (Architecture)"
    echo "  mobile-ui-designer   - Mobile UI Designer"
    echo "  web-ui-designer      - Web UI Designer"
    echo "  security-engineer    - Security Engineer"
    echo "  backend-developer    - Backend Developer"
    echo "  web-developer        - Web Developer"
    echo "  mobile-developer     - Mobile Developer"
    echo "  qa-tester           - QA Tester"
    echo "  devops-engineer     - DevOps Engineer"
    echo ""
    echo "Example:"
    echo "  ./scripts/design.sh po \"Create an expense management system\""
    exit 1
fi

AGENT_NAME=$1
PROJECT_DESC=${2:-"the application"}

# Validate agent name
VALID_AGENTS=("po" "architect" "mobile-ui-designer" "web-ui-designer" "security-engineer" "backend-developer" "web-developer" "mobile-developer" "qa-tester" "devops-engineer")

if [[ ! " ${VALID_AGENTS[@]} " =~ " ${AGENT_NAME} " ]]; then
    print_error "Invalid agent name: ${AGENT_NAME}"
    echo "Valid agents: ${VALID_AGENTS[*]}"
    exit 1
fi

# Agent name mapping for display
declare -A AGENT_NAMES
AGENT_NAMES[po]="Will - Product Owner"
AGENT_NAMES[architect]="Mike - System Architect"
AGENT_NAMES[mobile-ui-designer]="Jennifer - Mobile UI Designer"
AGENT_NAMES[web-ui-designer]="Amy - Web UI Designer"
AGENT_NAMES[security-engineer]="Sarah - Security Engineer"
AGENT_NAMES[backend-developer]="Luke - Backend Developer"
AGENT_NAMES[web-developer]="Jim - Web Developer"
AGENT_NAMES[mobile-developer]="Bob - Mobile Developer"
AGENT_NAMES[qa-tester]="Vijay - QA Tester"
AGENT_NAMES[devops-engineer]="Alex - DevOps Engineer"

print_info "🏗️  DESIGN PHASE - Invoking ${AGENT_NAMES[$AGENT_NAME]}"
print_info "📋 Project: ${PROJECT_DESC}"
print_info "🎯 Mode: Planning and Architecture Design"
echo ""

print_warning "💡 DESIGN PHASE automatically creates comprehensive planning documents"
print_warning "📄 The agent will generate detailed specifications in design-phase/ directory"
print_warning "⏱️  This may take a few moments to complete..."
echo ""

# Execute the command
print_info "🚀 Executing: claude --agent ${AGENT_NAME}"
echo ""

# Create prompt based on agent type
case $AGENT_NAME in
    po)
        PROMPT="[DESIGN PHASE] Gather comprehensive requirements and create user stories for ${PROJECT_DESC}. Include user personas, acceptance criteria, and detailed functional requirements."
        ;;
    architect)
        PROMPT="[DESIGN PHASE] Design scalable system architecture for ${PROJECT_DESC}. Include API design, database architecture, and integration patterns."
        ;;
    mobile-ui-designer)
        PROMPT="[DESIGN PHASE] Design mobile user interface and user experience for ${PROJECT_DESC}. Include user flows, wireframes, and accessibility considerations."
        ;;
    web-ui-designer)
        PROMPT="[DESIGN PHASE] Design web dashboard interface and user experience for ${PROJECT_DESC}. Include responsive design, data visualization, and interaction patterns."
        ;;
    security-engineer)
        PROMPT="[DESIGN PHASE] Create comprehensive security architecture and compliance framework for ${PROJECT_DESC}. Include threat modeling, authentication, and data protection."
        ;;
    backend-developer)
        PROMPT="[DESIGN PHASE] Plan backend API architecture and database design for ${PROJECT_DESC}. Include data models, API endpoints, and scalability considerations."
        ;;
    web-developer)
        PROMPT="[DESIGN PHASE] Plan Next.js application architecture and component structure for ${PROJECT_DESC}. Include state management, routing, and development patterns."
        ;;
    mobile-developer)
        PROMPT="[DESIGN PHASE] Plan Flutter application architecture and state management for ${PROJECT_DESC}. Include widget structure, data flow, and platform integration."
        ;;
    qa-tester)
        PROMPT="[DESIGN PHASE] Create comprehensive testing strategy and quality assurance plan for ${PROJECT_DESC}. Include test automation, performance testing, and quality metrics."
        ;;
    devops-engineer)
        PROMPT="[DESIGN PHASE] Design deployment infrastructure and CI/CD strategy for ${PROJECT_DESC}. Include containerization, orchestration, and monitoring."
        ;;
esac

print_info "📝 Auto-generated prompt:"
echo "   ${PROMPT}"
echo ""

# Note: In a real implementation, you would execute claude here
# For this script, we're showing what would happen
print_warning "🔧 To execute this design session, run:"
echo "   claude --agent ${AGENT_NAME}"
echo ""
print_warning "📋 Then provide this prompt:"
echo "   ${PROMPT}"
echo ""

print_success "🎯 Design phase setup complete for ${AGENT_NAMES[$AGENT_NAME]}!"
print_info "📚 Expected output: Comprehensive planning document in design-phase/ directory"