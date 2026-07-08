#!/bin/bash

################################################################################
# Storage Analyzer Tool
# Analyze disk usage and identify space-consuming files/apps
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

[ -f "${LIB_DIR}/common.sh" ] && source "${LIB_DIR}/common.sh"
[ -f "${LIB_DIR}/logger.sh" ] && source "${LIB_DIR}/logger.sh"

get_storage_usage() {
    if command -v df &> /dev/null; then
        df -h / | tail -1 | awk '{print $2"|"$3"|"$4"|"$5}'
    else
        echo "N/A|N/A|N/A|N/A"
    fi
}

show_storage_usage() {
    echo "========================================"
    echo "Storage Usage"
    echo "========================================"
    
    local storage=$(get_storage_usage)
    IFS='|' read -r total used available percent <<< "$storage"
    
    echo "Total Storage: ${total}"
    echo "Used: ${used}"
    echo "Available: ${available}"
    echo "Usage: ${percent}"
    echo ""
}

show_largest_apps() {
    echo "========================================"
    echo "Largest Applications"
    echo "========================================"
    
    if [ -d /data/app ]; then
        echo "App Directory Sizes:"
        du -sh /data/app/*/ 2>/dev/null | sort -rh | head -10
    else
        echo "App directory not accessible"
    fi
    echo ""
}

show_cleanup_suggestions() {
    echo "========================================"
    echo "Cleanup Suggestions"
    echo "========================================"
    
    echo "Recommended cleanup actions:"
    echo "1. Clear app cache: rm -rf ~/.cache/*"
    echo "2. Clear app data: Clear unused app data in Settings"
    echo "3. Remove temporary files: rm -rf /tmp/*"
    echo "4. Uninstall unused apps"
    echo ""
}

main() {
    case "${1}" in
        --usage)
            show_storage_usage
            ;;
        --largest-apps)
            show_largest_apps
            ;;
        --suggest-cleanup)
            show_cleanup_suggestions
            ;;
        *)
            show_storage_usage
            ;;
    esac
}

main "$@"
