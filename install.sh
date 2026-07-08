#!/bin/bash

################################################################################
# RR-Performance-Toolkit Installation Script
# This script sets up the toolkit with all necessary directories and permissions
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config/rr-toolkit"
LOG_DIR="${HOME}/.local/share/rr-toolkit/logs"
DATA_DIR="${HOME}/.local/share/rr-toolkit/data"
BIN_INSTALL_DIR="/usr/local/bin"

# Functions
print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  RR-Performance-Toolkit Installation"
    echo -e "${BLUE}║${NC}  Android Performance Toolkit for Termux"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

check_requirements() {
    print_info "Checking requirements..."
    
    # Check if bash is available
    if ! command -v bash &> /dev/null; then
        print_error "Bash is not installed"
        return 1
    fi
    print_success "Bash found"
    
    # Check if basic utilities are available
    for cmd in grep sed awk; do
        if ! command -v $cmd &> /dev/null; then
            print_warning "$cmd not found (optional)"
        else
            print_success "$cmd found"
        fi
    done
    
    return 0
}

create_directories() {
    print_info "Creating directory structure..."
    
    # Create main directories
    mkdir -p "${TOOLKIT_DIR}/bin" 2>/dev/null || true
    mkdir -p "${TOOLKIT_DIR}/tools" 2>/dev/null || true
    mkdir -p "${TOOLKIT_DIR}/lib" 2>/dev/null || true
    mkdir -p "${TOOLKIT_DIR}/profiles" 2>/dev/null || true
    mkdir -p "${TOOLKIT_DIR}/docs" 2>/dev/null || true
    mkdir -p "${TOOLKIT_DIR}/examples" 2>/dev/null || true
    
    print_success "Created project directories"
    
    # Create user config directories
    mkdir -p "${CONFIG_DIR}/profiles" 2>/dev/null || true
    print_success "Created config directory: ${CONFIG_DIR}"
    
    # Create log directory
    mkdir -p "${LOG_DIR}" 2>/dev/null || true
    print_success "Created log directory: ${LOG_DIR}"
    
    # Create data directory
    mkdir -p "${DATA_DIR}" 2>/dev/null || true
    print_success "Created data directory: ${DATA_DIR}"
}

setup_permissions() {
    print_info "Setting up permissions..."
    
    # Make main script executable
    if [ -f "${TOOLKIT_DIR}/rr-toolkit" ]; then
        chmod +x "${TOOLKIT_DIR}/rr-toolkit"
        print_success "Made rr-toolkit executable"
    fi
    
    # Make install script executable
    chmod +x "${TOOLKIT_DIR}/install.sh"
    print_success "Made install.sh executable"
    
    # Make all scripts in tools directory executable
    if [ -d "${TOOLKIT_DIR}/tools" ]; then
        chmod +x "${TOOLKIT_DIR}/tools"/*.sh 2>/dev/null || true
        print_success "Made all tools executable"
    fi
    
    # Make all scripts in lib directory executable
    if [ -d "${TOOLKIT_DIR}/lib" ]; then
        chmod +x "${TOOLKIT_DIR}/lib"/*.sh 2>/dev/null || true
        print_success "Made all lib scripts executable"
    fi
    
    # Make all scripts in bin directory executable
    if [ -d "${TOOLKIT_DIR}/bin" ]; then
        chmod +x "${TOOLKIT_DIR}/bin"/*.sh 2>/dev/null || true
        print_success "Made all bin scripts executable"
    fi
}

create_symlink() {
    print_info "Setting up command-line access..."
    
    # Check if we can create symlink
    if [ -w "$(dirname "${BIN_INSTALL_DIR}")" ] || sudo -n true 2>/dev/null; then
        if [ ! -L "${BIN_INSTALL_DIR}/rr-toolkit" ]; then
            if [ -w "$(dirname "${BIN_INSTALL_DIR}")" ]; then
                ln -s "${TOOLKIT_DIR}/rr-toolkit" "${BIN_INSTALL_DIR}/rr-toolkit" 2>/dev/null || true
                print_success "Created symlink in ${BIN_INSTALL_DIR}"
            else
                print_warning "Cannot create system symlink (no sudo). You can still run: ${TOOLKIT_DIR}/rr-toolkit"
            fi
        else
            print_success "Symlink already exists"
        fi
    else
        print_warning "Skipping system symlink (would require sudo)"
    fi
}

setup_config() {
    print_info "Setting up configuration..."
    
    # Create default config if it doesn't exist
    if [ ! -f "${CONFIG_DIR}/config.conf" ]; then
        cat > "${CONFIG_DIR}/config.conf" << 'EOF'
# RR-Performance-Toolkit Configuration
# Edit this file to customize toolkit behavior

# Monitoring settings
MONITOR_INTERVAL=5
MONITOR_DURATION=3600

# Battery settings
BATTERY_ALERT_THRESHOLD=20
BATTERY_DRAIN_WARNING=5

# Thermal settings
THERMAL_WARNING=45
THERMAL_CRITICAL=55

# Performance profiles
DEFAULT_PROFILE="balanced"
AUTO_OPTIMIZE=false

# Output settings
LOG_LEVEL="info"
LOG_FILE="${HOME}/.local/share/rr-toolkit/logs/toolkit.log"
OUTPUT_FORMAT="text"
EOF
        print_success "Created default configuration"
    else
        print_warning "Configuration already exists at ${CONFIG_DIR}/config.conf"
    fi
}

verify_installation() {
    print_info "Verifying installation..."
    
    local errors=0
    
    # Check main directories
    for dir in bin tools lib profiles docs; do
        if [ -d "${TOOLKIT_DIR}/${dir}" ]; then
            print_success "Directory ${dir}/ exists"
        else
            print_warning "Directory ${dir}/ missing (will be created on first use)"
        fi
    done
    
    # Check config directory
    if [ -d "${CONFIG_DIR}" ]; then
        print_success "Config directory exists"
    else
        print_error "Config directory not found"
        ((errors++))
    fi
    
    # Check log directory
    if [ -d "${LOG_DIR}" ]; then
        print_success "Log directory exists"
    else
        print_error "Log directory not found"
        ((errors++))
    fi
    
    return $errors
}

display_next_steps() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Installation Complete!${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}Quick Start:${NC}"
    echo ""
    
    # Check if symlink was created
    if [ -L "${BIN_INSTALL_DIR}/rr-toolkit" ] || command -v rr-toolkit &> /dev/null; then
        echo "  Start toolkit:"
        echo "    ${BLUE}rr-toolkit${NC}"
        echo ""
        echo "  Get help:"
        echo "    ${BLUE}rr-toolkit --help${NC}"
    else
        echo "  Start toolkit:"
        echo "    ${BLUE}${TOOLKIT_DIR}/rr-toolkit${NC}"
        echo ""
        echo "  Or add to PATH:"
        echo "    ${BLUE}export PATH=\"\$PATH:${TOOLKIT_DIR}\"${NC}"
        echo ""
        echo "  Get help:"
        echo "    ${BLUE}${TOOLKIT_DIR}/rr-toolkit --help${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Configuration:${NC}"
    echo "  Edit config at: ${BLUE}${CONFIG_DIR}/config.conf${NC}"
    echo "  View logs at: ${BLUE}${LOG_DIR}${NC}"
    echo ""
    echo -e "${YELLOW}Documentation:${NC}"
    echo "  See README.md for full documentation"
    echo "  Additional docs in: ${BLUE}${TOOLKIT_DIR}/docs${NC}"
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo ""
}

main() {
    print_header
    
    # Run installation steps
    check_requirements || exit 1
    echo ""
    
    create_directories
    echo ""
    
    setup_permissions
    echo ""
    
    create_symlink
    echo ""
    
    setup_config
    echo ""
    
    verify_installation
    echo ""
    
    display_next_steps
    
    print_success "Installation finished!"
    echo ""
}

# Run installation
main "$@"
