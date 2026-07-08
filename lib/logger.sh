#!/bin/bash

################################################################################
# Logger Library
# Logging utilities for the toolkit
################################################################################

# Default log file
LOG_FILE="${HOME}/.local/share/rr-toolkit/logs/toolkit.log"
LOG_LEVEL="${LOG_LEVEL:-info}"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Initialize logger
init_logger() {
    mkdir -p "$(dirname "${LOG_FILE}")"
    if [ ! -f "${LOG_FILE}" ]; then
        touch "${LOG_FILE}"
    fi
}

# Log message with timestamp
log_message() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[${timestamp}] [${level}] ${message}" >> "${LOG_FILE}"
}

# Log info
log_info() {
    log_message "INFO" "$@"
    if [ "${DEBUG}" == "1" ]; then
        echo -e "${BLUE}[INFO]${NC} $@"
    fi
}

# Log error
log_error() {
    log_message "ERROR" "$@"
    echo -e "${RED}[ERROR]${NC} $@" >&2
}

# Log warning
log_warning() {
    log_message "WARNING" "$@"
    echo -e "${YELLOW}[WARNING]${NC} $@"
}

# Log success
log_success() {
    log_message "SUCCESS" "$@"
    echo -e "${GREEN}[SUCCESS]${NC} $@"
}

# Log debug
log_debug() {
    if [ "${DEBUG}" == "1" ]; then
        log_message "DEBUG" "$@"
        echo -e "${BLUE}[DEBUG]${NC} $@"
    fi
}

# Get logs
get_logs() {
    if [ -f "${LOG_FILE}" ]; then
        tail -n "${1:-50}" "${LOG_FILE}"
    fi
}

# Clear logs
clear_logs() {
    if [ -f "${LOG_FILE}" ]; then
        > "${LOG_FILE}"
        log_info "Logs cleared"
    fi
}
