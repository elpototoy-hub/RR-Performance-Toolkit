#!/bin/bash

################################################################################
# Thermal Monitor Tool
# Track device temperature and thermal throttling
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

[ -f "${LIB_DIR}/common.sh" ] && source "${LIB_DIR}/common.sh"
[ -f "${LIB_DIR}/logger.sh" ] && source "${LIB_DIR}/logger.sh"

get_temperature() {
    if [ -d /sys/class/thermal ]; then
        for zone in /sys/class/thermal/thermal_zone*/temp; do
            if [ -f "$zone" ]; then
                local temp=$(cat "$zone" 2>/dev/null)
                echo "$((temp / 1000))"
                return 0
            fi
        done
    fi
    echo "N/A"
}

show_thermal_stats() {
    echo "========================================"
    echo "Thermal Information"
    echo "========================================"
    
    local temp=$(get_temperature)
    echo "Current Temperature: ${temp}°C"
    echo ""
    
    # Temperature assessment
    echo "Temperature Status:"
    if [ "${temp}" != "N/A" ]; then
        if [ "${temp}" -lt 40 ]; then
            echo "✓ Cool - No thermal concerns"
        elif [ "${temp}" -lt 50 ]; then
            echo "⚠ Warm - Monitor temperature"
        else
            echo "✗ Hot - Thermal throttling may occur"
        fi
    fi
    echo ""
}

watch_temperature() {
    local threshold=${1:-45}
    local alert_threshold=${2:-55}
    
    echo "Watching temperature (threshold: ${threshold}°C, alert: ${alert_threshold}°C)..."
    echo "Press Ctrl+C to stop"
    echo ""
    
    while true; do
        local temp=$(get_temperature)
        local timestamp=$(date '+%H:%M:%S')
        
        if [ "${temp}" != "N/A" ]; then
            if [ "${temp}" -ge "${alert_threshold}" ]; then
                echo "[${timestamp}] ALERT: Temperature ${temp}°C (exceeds ${alert_threshold}°C)"
            elif [ "${temp}" -ge "${threshold}" ]; then
                echo "[${timestamp}] WARNING: Temperature ${temp}°C (exceeds ${threshold}°C)"
            else
                echo "[${timestamp}] OK: Temperature ${temp}°C"
            fi
        fi
        
        sleep 5
    done
}

main() {
    case "${1}" in
        --stats)
            show_thermal_stats
            ;;
        --watch)
            local threshold=${3:-45}
            local alert=${5:-55}
            watch_temperature "${threshold}" "${alert}"
            ;;
        --alert-threshold)
            watch_temperature 45 "${2}"
            ;;
        *)
            show_thermal_stats
            ;;
    esac
}

main "$@"
