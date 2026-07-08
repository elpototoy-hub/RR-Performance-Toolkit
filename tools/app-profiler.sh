#!/bin/bash

################################################################################
# App Profiler Tool
# Profile individual applications' resource consumption
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

[ -f "${LIB_DIR}/common.sh" ] && source "${LIB_DIR}/common.sh"
[ -f "${LIB_DIR}/logger.sh" ] && source "${LIB_DIR}/logger.sh"

profile_app() {
    local package=$1
    
    echo "========================================"
    echo "App Profile: ${package}"
    echo "========================================"
    
    if command -v ps &> /dev/null; then
        # Get process information for the app
        local pids=$(pgrep -f "${package}" 2>/dev/null)
        
        if [ -z "${pids}" ]; then
            echo "Application not running: ${package}"
            return 1
        fi
        
        echo "Process Information:"
        ps aux | grep "${package}" | grep -v grep | awk '{printf "PID: %s, Memory: %s%%, CPU: %s%%\n", $2, $4, $3}'
        echo ""
        
        # Memory info
        echo "Memory Usage:"
        for pid in ${pids}; do
            if [ -f "/proc/${pid}/status" ]; then
                awk '/VmRSS:/ {printf "Resident Memory: %d KB\n", $2}' "/proc/${pid}/status"
            fi
        done
        echo ""
    else
        echo "ps command not available"
    fi
}

main() {
    local package="${1:-${2}}"
    
    if [ -z "${package}" ]; then
        echo "Usage: app-profiler.sh [PACKAGE_NAME]"
        echo "Example: app-profiler.sh com.android.chrome"
        return 1
    fi
    
    profile_app "${package}"
}

main "$@"
