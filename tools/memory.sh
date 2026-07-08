#!/bin/bash

################################################################################
# Memory Manager Tool
# Monitor and manage memory usage
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

[ -f "${LIB_DIR}/common.sh" ] && source "${LIB_DIR}/common.sh"
[ -f "${LIB_DIR}/logger.sh" ] && source "${LIB_DIR}/logger.sh"

get_memory_stats() {
    if [ -f /proc/meminfo ]; then
        awk '
        /MemTotal:/ {total=$2}
        /MemAvailable:/ {available=$2}
        /Buffers:/ {buffers=$2}
        /Cached:/ {cached=$2}
        END {
            used = total - available;
            percent = int(used / total * 100);
            printf "%d|%d|%d|%d|%d|%d", total, used, available, buffers, cached, percent
        }' /proc/meminfo
    fi
}

show_memory_usage() {
    echo "========================================"
    echo "Memory Usage"
    echo "========================================"
    
    local stats=$(get_memory_stats)
    IFS='|' read -r total used available buffers cached percent <<< "$stats"
    
    echo "Total Memory: $((total / 1024))MB"
    echo "Used Memory: $((used / 1024))MB"
    echo "Available Memory: $((available / 1024))MB"
    echo "Buffers: $((buffers / 1024))MB"
    echo "Cached: $((cached / 1024))MB"
    echo "Usage: ${percent}%"
    echo ""
}

show_process_memory() {
    echo "========================================"
    echo "Top Memory-Consuming Processes"
    echo "========================================"
    
    if command -v ps &> /dev/null; then
        ps aux | sort -k4 -rn | head -10 | awk '{printf "%-8s %5s%% %s\n", $1, $4, $11}'
    else
        echo "ps command not available"
    fi
    echo ""
}

main() {
    case "${1}" in
        --usage)
            show_memory_usage
            ;;
        --show-processes)
            show_process_memory
            ;;
        --sort)
            echo "Sorting by: ${2}"
            show_process_memory
            ;;
        *)
            show_memory_usage
            ;;
    esac
}

main "$@"
