#!/bin/bash

# AI Agent Team - Develop Mode Helper Script
# Usage: ./scripts/develop.sh [agent-name] "[feature description]"

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
    print_error "Usage: ./scripts/develop.sh [agent-name] \"[feature description]\""
    echo ""
    echo "Available development agents:"
    echo "  backend-developer    - Backend/API Implementation"
    echo "  web-developer        - Web Frontend Implementation"
    echo "  mobile-developer     - Mobile App Implementation"
    echo "  qa-tester           - Testing Implementation"
    echo "  devops-engineer     - Infrastructure Implementation"
    echo ""
    echo "Example:"
    echo "  ./scripts/develop.sh backend-developer \"Implement user authentication with JWT\""
    exit 1
fi

AGENT_NAME=$1
FEATURE_DESC=${2:-"the requested feature"}

# Validate agent name for development
VALID_DEV_AGENTS=("backend-developer" "web-developer" "mobile-developer" "qa-tester" "devops-engineer")

if [[ ! " ${VALID_DEV_AGENTS[@]} " =~ " ${AGENT_NAME} " ]]; then
    print_error "Invalid development agent: ${AGENT_NAME}"
    echo "Valid development agents: ${VALID_DEV_AGENTS[*]}"
    echo ""
    print_info "💡 For design/planning agents, use: ./scripts/design.sh"
    exit 1
fi

# Agent name mapping for display
declare -A AGENT_NAMES
AGENT_NAMES[backend-developer]="Luke - Backend Developer"
AGENT_NAMES[web-developer]="Jim - Web Developer"
AGENT_NAMES[mobile-developer]="Bob - Mobile Developer"
AGENT_NAMES[qa-tester]="Vijay - QA Tester"
AGENT_NAMES[devops-engineer]="Alex - DevOps Engineer"

# Check if design documents exist
declare -A DESIGN_DOCS
DESIGN_DOCS[backend-developer]="design-phase/BACKEND-DEV.md"
DESIGN_DOCS[web-developer]="design-phase/WEB-DEV.md"
DESIGN_DOCS[mobile-developer]="design-phase/MOBILE-DEV.md"
DESIGN_DOCS[qa-tester]="design-phase/QA-TESTING.md"
DESIGN_DOCS[devops-engineer]="design-phase/DEVOPS-DEPLOY.md"

DESIGN_DOC=${DESIGN_DOCS[$AGENT_NAME]}

print_info "💻 DEVELOP PHASE - Invoking ${AGENT_NAMES[$AGENT_NAME]}"
print_info "🔨 Feature: ${FEATURE_DESC}"
print_info "🎯 Mode: Code Implementation"
echo ""

# Check if design document exists
if [ ! -f "$DESIGN_DOC" ]; then
    print_warning "⚠️  Design document not found: ${DESIGN_DOC}"
    print_warning "💡 Consider running design phase first:"
    echo "   ./scripts/design.sh ${AGENT_NAME} \"your project description\""
    echo ""
    print_warning "🚀 Proceeding anyway - agent will work without design document..."
else
    print_success "✅ Design document found: ${DESIGN_DOC}"
    print_info "📚 Agent will automatically reference this design document first"
fi

echo ""

print_warning "💡 DEVELOP PHASE automatically implements working code"
print_warning "🔧 The agent will write production-ready code following design specifications"
print_warning "⏱️  This may take a few moments to complete..."
echo ""

# Execute the command
print_info "🚀 Executing: claude --agent ${AGENT_NAME}"
echo ""

# Create prompt based on agent type and feature
case $AGENT_NAME in
    backend-developer)
        PROMPT="[DEVELOP PHASE] Implement ${FEATURE_DESC}. Follow the FastAPI patterns and architecture defined in design-phase/BACKEND-DEV.md. Include proper error handling, validation, and security measures."
        ;;
    web-developer)
        PROMPT="[DEVELOP PHASE] Implement ${FEATURE_DESC}. Follow the Next.js architecture and component patterns defined in design-phase/WEB-DEV.md. Include proper styling, state management, and accessibility."
        ;;
    mobile-developer)
        PROMPT="[DEVELOP PHASE] Implement ${FEATURE_DESC}. Follow the Flutter architecture and BLoC patterns defined in design-phase/MOBILE-DEV.md. Include proper state management and platform integration."
        ;;
    qa-tester)
        PROMPT="[DEVELOP PHASE] Create comprehensive tests for ${FEATURE_DESC}. Follow the testing strategy defined in design-phase/QA-TESTING.md. Include unit tests, integration tests, and proper test coverage."
        ;;
    devops-engineer)
        PROMPT="[DEVELOP PHASE] Implement infrastructure for ${FEATURE_DESC}. Follow the deployment strategy defined in design-phase/DEVOPS-DEPLOY.md. Include containerization, orchestration, and monitoring."
        ;;
esac

print_info "📝 Auto-generated prompt:"
echo "   ${PROMPT}"
echo ""

# Note: In a real implementation, you would execute claude here
# For this script, we're showing what would happen
print_warning "🔧 To execute this development session, run:"
echo "   claude --agent ${AGENT_NAME}"
echo ""
print_warning "📋 Then provide this prompt:"
echo "   ${PROMPT}"
echo ""

print_success "🎯 Develop phase setup complete for ${AGENT_NAMES[$AGENT_NAME]}!"
print_info "🔧 Expected output: Production-ready code following design specifications"

# Additional tips based on agent
case $AGENT_NAME in
    backend-developer)
        echo ""
        print_info "💡 Backend Development Tips:"
        echo "   • Agent will create FastAPI endpoints with proper validation"
        echo "   • Database models and migrations will be included"
        echo "   • Authentication and security will be implemented"
        ;;
    web-developer)
        echo ""
        print_info "💡 Web Development Tips:"
        echo "   • Agent will create React components with TypeScript"
        echo "   • State management and API integration will be included"
        echo "   • Responsive design and accessibility will be implemented"
        ;;
    mobile-developer)
        echo ""
        print_info "💡 Mobile Development Tips:"
        echo "   • Agent will create Flutter widgets with BLoC pattern"
        echo "   • Platform-specific features will be included"
        echo "   • Offline functionality and data sync will be implemented"
        ;;
esac