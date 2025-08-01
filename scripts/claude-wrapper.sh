#!/bin/bash

# AI Agent Team - Claude Code Wrapper Script
# Adds --design and --develop flags to claude commands
# Usage: ./scripts/claude-wrapper.sh [--design|--develop] --agent [agent-name] "[prompt]"

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

# Initialize variables
PHASE=""
AGENT=""
PROMPT=""
CLAUDE_ARGS=()

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --design)
            PHASE="DESIGN"
            shift
            ;;
        --develop)
            PHASE="DEVELOP"
            shift
            ;;
        --agent)
            AGENT="$2"
            CLAUDE_ARGS+=("--agent" "$2")
            shift 2
            ;;
        *)
            # Collect remaining arguments (prompt and other claude flags)
            CLAUDE_ARGS+=("$1")
            shift
            ;;
    esac
done

# Check if phase flag was provided
if [ -z "$PHASE" ]; then
    print_error "Mode flag required: --design or --develop"
    echo ""
    echo "Usage Examples:"
    echo "  # DESIGN PHASE - Create planning documents"
    echo "  claude --design --agent po \"Create expense management system\""
    echo "  claude --design --agent backend-developer \"Plan FastAPI architecture\""
    echo ""
    echo "  # DEVELOP PHASE - Implement actual code"
    echo "  claude --develop --agent backend-developer \"Implement authentication endpoints\""
    echo "  claude --develop --agent web-developer \"Create dashboard component\""
    echo ""
    echo "  # Traditional method (still supported)"
    echo "  claude --agent backend-developer"
    echo "  # Then provide prompt: [DESIGN PHASE] Plan backend architecture"
    exit 1
fi

# Check if agent was provided
if [ -z "$AGENT" ]; then
    print_error "Agent name required with --agent flag"
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

# Validate agent name
if [[ -z "${AGENT_NAMES[$AGENT]}" ]]; then
    print_error "Invalid agent name: $AGENT"
    echo "Valid agents: ${!AGENT_NAMES[@]}"
    exit 1
fi

# Display phase information
if [ "$PHASE" = "DESIGN" ]; then
    print_info "🏗️  DESIGN PHASE - ${AGENT_NAMES[$AGENT]}"
    print_info "📋 Purpose: Create comprehensive planning documents"
    print_info "📁 Output: design-phase/ folder"
else
    print_info "💻 DEVELOP PHASE - ${AGENT_NAMES[$AGENT]}"
    print_info "🔨 Purpose: Implement actual working code"
    print_info "📁 Output: implementation/ folder"
fi

echo ""

# Check for design documents if in DEVELOP PHASE
if [ "$PHASE" = "DEVELOP" ]; then
    declare -A DESIGN_DOCS
    DESIGN_DOCS[backend-developer]="design-phase/BACKEND-DEV.md"
    DESIGN_DOCS[web-developer]="design-phase/WEB-DEV.md"
    DESIGN_DOCS[mobile-developer]="design-phase/MOBILE-DEV.md"
    DESIGN_DOCS[qa-tester]="design-phase/QA-TESTING.md"
    DESIGN_DOCS[devops-engineer]="design-phase/DEVOPS-DEPLOY.md"
    
    DESIGN_DOC=${DESIGN_DOCS[$AGENT]}
    
    if [ -n "$DESIGN_DOC" ] && [ ! -f "$DESIGN_DOC" ]; then
        print_warning "⚠️  Design document not found: ${DESIGN_DOC}"
        print_warning "💡 Consider running design phase first:"
        echo "   claude --design --agent ${AGENT} \"your project description\""
        echo ""
        print_warning "🚀 Proceeding anyway - agent will work without design document..."
        echo ""
    elif [ -n "$DESIGN_DOC" ]; then
        print_success "✅ Design document found: ${DESIGN_DOC}"
        print_info "📚 Agent will automatically reference this design document"
        echo ""
    fi
fi

# Prepare the enhanced prompt with phase information
ENHANCED_PROMPT=""

# Extract the user prompt from remaining arguments
USER_PROMPT=""
for arg in "${CLAUDE_ARGS[@]}"; do
    if [[ "$arg" != "--agent" && "$arg" != "$AGENT" ]]; then
        if [[ "$arg" != -* ]]; then
            USER_PROMPT="$arg"
            break
        fi
    fi
done

# Create enhanced prompt with phase prefix
if [ -n "$USER_PROMPT" ]; then
    ENHANCED_PROMPT="[${PHASE} PHASE] ${USER_PROMPT}"
else
    ENHANCED_PROMPT="[${PHASE} PHASE] Please proceed with ${PHASE,,} phase workflow."
fi

print_info "🚀 Executing: claude --agent ${AGENT}"
print_info "📝 Enhanced prompt: ${ENHANCED_PROMPT}"
echo ""

# Execute claude with enhanced prompt
print_success "🎯 Starting ${PHASE} PHASE session with ${AGENT_NAMES[$AGENT]}"
echo ""

# Note: In a real implementation, this would execute claude
# For demonstration, we show what would be executed
print_warning "🔧 Command to execute:"
echo "claude --agent ${AGENT}"
echo ""
print_warning "📋 Enhanced prompt to provide:"
echo "\"${ENHANCED_PROMPT}\""
echo ""

# Uncomment the following line to actually execute claude
# exec claude --agent "$AGENT" <<< "$ENHANCED_PROMPT"

print_success "🎯 ${PHASE} phase session prepared for ${AGENT_NAMES[$AGENT]}!"

# Additional phase-specific tips
if [ "$PHASE" = "DESIGN" ]; then
    echo ""
    print_info "💡 DESIGN PHASE Tips:"
    echo "   • Agent will create comprehensive planning documents"
    echo "   • Focus on architecture, patterns, and specifications"
    echo "   • Output will be saved in design-phase/ folder"
    echo "   • Use this for project planning and requirement gathering"
else
    echo ""
    print_info "💡 DEVELOP PHASE Tips:"
    echo "   • Agent will write actual production code"
    echo "   • Follows design specifications from design-phase/"
    echo "   • Output will be implementation-ready code"
    echo "   • Use this for feature development and coding tasks"
fi